//
//  Helpers.swift
//  SubTemplateSwiftUI
//
//  Created by Vlad Nechyporenko on 22.09.2023.
//

import Foundation
import UIKit
import SwiftUI

enum ProductType_MMP: String, CaseIterable, Identifiable {
    var id: Self { self }
    case mainType
    case funcType
    case contentType
    case otherType

    var productID: String {
        switch self {
        case .mainType:
            return Configurations_MMP.mainSubscriptionID
        case .funcType:
            return Configurations_MMP.unlockFuncSubscriptionID
        case .contentType:
            return Configurations_MMP.unlockContentSubscriptionID
        case .otherType:
            return Configurations_MMP.unlockerThreeSubscriptionID
        }
    }
}

enum MMP_PurchaseError: String {
    case none
    case invalidProduct = "Invalid Product"
    case needApproval = "Need Approval"
}

typealias UIDevice_MMP = UIDevice

extension UIDevice_MMP {

    var hasPhysicalButton: Bool {
        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) {
            return windowScene.windows
                .map { $0.safeAreaInsets.bottom }
                .contains(where: { $0 == 0 })
        }
        return false
    }

}

typealias Color_MMP = Color

public extension Color_MMP {

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(
            .sRGB,
            red: Double(red),
            green: Double(green),
            blue: Double(blue),
            opacity: Double(alpha)
        )
    }

}

typealias Task_MMP = Task

extension String {

    func replacePriceWithNewPrice_MMP(newPriceString: String) -> String {
        var _MMP1831204126: Int { 0 }

        var result = self.replacingOccurrences(of: "4.99", with: newPriceString.replacingOccurrences(of: "$", with: ""))
        result = result.replacingOccurrences(of: "4,99", with: newPriceString.replacingOccurrences(of: "$", with: ""))
        return result
    }

}
