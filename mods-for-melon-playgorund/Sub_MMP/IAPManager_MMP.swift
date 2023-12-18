//
//  IAPManager_MMP.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 02.12.2023.
//

import SystemConfiguration
import Foundation
import StoreKit
import SwiftUI
import Pushwoosh
import Adjust
import Combine

class IAPManager_MMP: ObservableObject {

    @AppStorage("isFirstLoad") private var isFirstLoad = true

    @Published private(set) var isLoadingProducts = true
    @Published private(set) var error = ""
    @Published private(set) var boughtProducts = Set<ProductType_MMP>()
    @Published private(set) var isPurchasing = false

    private let productIds = ProductType_MMP.allCases.map({$0.productID})

    private var products = [Product]()
    private var updates: Task<Void, Never>? = nil

    var subscribedSuccess = PassthroughSubject<ProductType_MMP, Never>()

    init(isForWidget: Bool = false) {
        if !isForWidget {
            updates = observeTransactionUpdates()
            if checkInternetConnectivity() {
                Task {
                    do {
                        products = try await Product.products(for: productIds)
                        await updatePurchasedProducts()
                        await MainActor.run {
                            isLoadingProducts = false
                        }
                    } catch {
                        print(error.localizedDescription)
                        await MainActor.run {
                            self.error = error.localizedDescription
                            isLoadingProducts = false
                        }
                    }
                }
            } else {
                Task {
                    await updatePurchasedProducts()
                    isLoadingProducts = false
                }
            }
            Task {
                await finishAllTransactions()
            }
        }
    }

    deinit {
        updates?.cancel()
    }

    private func finishAllTransactions() async {
        for await result in Transaction.all {
            guard case .verified(let transaction) = result else {
                // Ignore unverified transactions.
                return
            }
            await transaction.finish()
        }
    }

    private func trackSubscription(transaction: StoreKit.Transaction, product: Product) {
        let price = NSDecimalNumber(decimal: product.price)
        let currency = product.priceFormatStyle.currencyCode
        let transactionId = String(transaction.id)
        let transactionDate = transaction.purchaseDate
        var salesRegion = ""
        if #available(iOS 16, *) {
            salesRegion = product.priceFormatStyle.locale.language.languageCode?.identifier ?? "US"
        } else {
            salesRegion = product.priceFormatStyle.locale.languageCode ?? "US"
        }

        if let subscription = ADJSubscription(price: price, currency: currency, transactionId: transactionId, andReceipt: transaction.jsonRepresentation) {
            subscription.setTransactionDate(transactionDate)
            subscription.setSalesRegion(salesRegion)
            Adjust.trackSubscription(subscription)
        }
    }

    private func pushwooshSetSubTag(value : Bool, productType: ProductType_MMP) {

        var tag = Configurations_MMP.mainSubscriptionPushTag

        switch productType {
        case .mainType:
            tag = Configurations_MMP.mainSubscriptionPushTag
        case .contentType:
            tag = Configurations_MMP.unlockContentSubscriptionPushTag
        case .funcType:
            tag = Configurations_MMP.unlockFuncSubscriptionPushTag
        case .otherType:
            tag = Configurations_MMP.unlockerThreeSubscriptionPushTag
        }

        Pushwoosh.sharedInstance().setTags([tag: value]) { error in
            if let err = error {
                print(err.localizedDescription)
                print("send tag error IAPManager")
            }
        }
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                await self.handle(updatedTransaction: verificationResult)
            }
        }
    }

    private func handle(updatedTransaction verificationResult: VerificationResult<StoreKit.Transaction>) async {
        guard case .verified(let transaction) = verificationResult else {
            // Ignore unverified transactions.
            return
        }
        if let product = ProductType_MMP.allCases.first(where: {$0.productID == transaction.productID}) {
            await MainActor.run {
                let expDate = transaction.expirationDate
                if transaction.revocationDate == nil && (expDate == nil || expDate ?? .now > .now) {
                    self.boughtProducts.insert(product)
                    self.pushwooshSetSubTag(value: true, productType: product)
                } else {
                    if !self.boughtProducts.contains(product) {
                        self.pushwooshSetSubTag(value: false, productType: product)
                    }
                }
            }
        }
        await transaction.finish()
    }

    func getPrice(of product: ProductType_MMP) -> String {
        if let product = products.first(where: {$0.id == product.productID}) {
            return product.displayPrice
        }
        return "$4.99"
    }

    func updatePurchasedProducts() async {
        if isFirstLoad {
            Task {
                for await _ in Transaction.currentEntitlements {

                }
                await MainActor.run {
                    isFirstLoad = false
                }
            }
        } else {
            for await result in Transaction.currentEntitlements {
                await handle(updatedTransaction: result)
            }
        }
    }

    @discardableResult
    func checkInternetConnectivity() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        if isReachable && !needsConnection {
            // Connected to the internet
            // Do your network-related tasks here
            return true
        } else {
            error = localizedString(forKey: "connectivityAlert")
            // Not connected to the internet
            return false
        }
    }

    func restore() {
        isPurchasing = true
        Task {
            do {
                try await AppStore.sync()
                for await result in Transaction.currentEntitlements {
                    await handle(updatedTransaction: result)
                }
                await MainActor.run {
                    isPurchasing = false
                }
            } catch {
                await MainActor.run {
                    isPurchasing = false
                }
                print(error)
            }
        }
    }

    func purchaseProduct(of type: ProductType_MMP) {
        if checkInternetConnectivity() {
            isPurchasing = true
            Task {
                if products.isEmpty {
                    do {
                        products = try await Product.products(for: productIds)
                    } catch {
                        await MainActor.run {
                            self.error = error.localizedDescription
                            self.isPurchasing = false
                        }
                        return
                    }
                }
                let product = products.first(where: {$0.id == type.productID})
                guard let product else {
                    await MainActor.run {
                        self.error = MMP_PurchaseError.invalidProduct.rawValue
                        self.isPurchasing = false
                    }
                    return
                }
                await updatePurchasedProducts()
                if !boughtProducts.contains(type) {
                    do {
                        let result = try await product.purchase()
                        switch result {
                        case let .success(.verified(transaction)):
                            // Successful purchase
                            await transaction.finish()
                            trackSubscription(transaction: transaction, product: product)
                            await MainActor.run {
                                self.boughtProducts.insert(type)
                                subscribedSuccess.send(type)
                            }
                        case let .success(.unverified(_, error)):
                            // Successful purchase but transaction/receipt can't be verified
                            // Could be a jailbroken phone
                            await MainActor.run {
                                self.error = error.localizedDescription
                            }
                            break
                        case .pending:
                            // Transaction waiting on SCA (Strong Customer Authentication) or
                            // approval from Ask to Buy
                            await MainActor.run {
                                self.error = MMP_PurchaseError.needApproval.rawValue
                            }
                            break
                        case .userCancelled:
                            // ^^^
                            break
                        @unknown default:
                            break
                        }
                    } catch {
                        await MainActor.run {
                            self.error = error.localizedDescription
                        }
                    }
                }
                await MainActor.run {
                    isPurchasing = false
                }
            }
        }
    }

    func resetError() {
        error = ""
    }

}
