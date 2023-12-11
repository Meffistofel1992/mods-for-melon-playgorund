//
//  Utilities.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import SwiftUI
import Resolver

final class Utilities_MMP {

    @Injected private var networkMonitoringManager: NetworkMonitoringManager_MMP
    
    static let shared = Utilities_MMP()
    private init() {}

    func retrowFunction_MMP(action: AsyncEmptyClosure_MMP) async {
        while true {
            do {
                try Task.checkCancellation()

                if await networkMonitoringManager.isReachable_MMP {
                    await action()
                  return
                }

                try Task.checkCancellation()
                try await Task.sleep_MMP(seconds: 3)
            } catch {
                Logger.error_MMP(error)
            }
        }
    }

    func retrowThrowsFunction_MMP(action: AsyncThrowEmptyClosure_MMP) async {
        while true {
            do {
                try Task.checkCancellation()

                if await networkMonitoringManager.isReachable_MMP {
                    try await action()
                  return
                }

                try Task.checkCancellation()
                try await Task.sleep_MMP(seconds: 2)
            } catch {
                Logger.error_MMP(error)
            }
        }
    }

    func safeArea_MMP() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }

        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }

        return safeArea
    }

    func aspectRatioForImage_MMP(aspectRatio: CGFloat) -> CGFloat {
        let width = UIApplication.viewBounds.width
        let height = UIApplication.viewBounds.width / aspectRatio
        return width/height
    }

    func widthWith_MMP(aspectRatio: CGFloat) -> CGFloat {
        return UIApplication.viewBounds.width * aspectRatio
    }

    func heightWith_MMP(aspectRatio: CGFloat) -> CGFloat {
        return UIApplication.viewBounds.height * aspectRatio
    }

    func widthAspectRatioDevice_MMP(width: CGFloat) -> CGFloat {
        if isIPad {
            return UIApplication.viewBounds.width * (width / 1024)
        } else {
            return UIApplication.viewBounds.width * (width / 390)
        }
    }

    func heightAspectRatioDevice_MMP(height: CGFloat) -> CGFloat {
        if isIPad {
            return UIApplication.viewBounds.height * (height / 1366)
        } else {
            return UIApplication.viewBounds.height * (height / 844)
        }
    }

    func widthWithOpt_MMP(aspectRatio: CGFloat?) -> CGFloat? {
        if let aspectRatio {
            return UIApplication.viewBounds.width * aspectRatio
        } else {
            return nil
        }
    }

    func heightWithOpt_MMP(aspectRatio: CGFloat?) -> CGFloat? {
        if let aspectRatio {
            return UIApplication.viewBounds.height * aspectRatio
        } else {
            return nil
        }
    }

    func presentActivitySheet_MMP(url: URL, rect: CGRect, onDismiss: (() -> Void)? = nil) {
        guard let vc = topViewController_MMP() else {
            return
        }
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        activityVC.popoverPresentationController?.sourceView = vc.view
        activityVC.popoverPresentationController?.sourceRect = rect

        activityVC.completionWithItemsHandler = { _, _, _, _ in
           onDismiss?()
        }

        vc.present(activityVC, animated: true, completion: nil)
    }

    func presentNoInternetConnectionAllert_MMP(action: @escaping ValueClosure_MMP<UIAlertAction>) -> UIAlertController {
        let alert = UIAlertController(title: "", message: "No Internet connection found", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: action))

        Task { @MainActor in
            self.topViewController_MMP()?.present(alert, animated: true, completion: nil)
        }

        return alert
    }

    func topViewController_MMP(controller: UIViewController? = nil) -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        let controller = controller ?? windowScene.windows.first?.rootViewController

        if let navigationController = controller as? UINavigationController {
            return topViewController_MMP(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController_MMP(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController_MMP(controller: presented)
        }
        return controller
    }
}

// MARK: - Image & PDFImage
extension Utilities_MMP {
    /// Initializes a SwiftUI `Image` from data.
    func getImage_MMP(data: Data) -> UIImage? {
        UIImage(data: data)
    }

    func getPDFImage_MMP(data: Data, size: CGSize, additionalYoffSet: CGFloat?) async -> UIImage? {
        guard
            let provider = CGDataProvider(data: data as CFData),
            let pdfDoc   = CGPDFDocument(provider),
            let pdfPage  = pdfDoc.page(at: 1)
        else { return nil }

        let pageRect = pdfPage.getBoxRect(.mediaBox)
        let scaleH = min(1, size.height / pageRect.height)
        let scaleW = min(1, size.width / pageRect.width)
        let scaleFactor = max(scaleW, scaleH)

        let scaledRect = pageRect.applying(.init(scaleX: scaleFactor, y: scaleFactor))
        let renderer = UIGraphicsImageRenderer(size: scaledRect.size)

        let img = renderer.image { ctx in
            UIColor.clear.set()
            ctx.fill(scaledRect)

            ctx.cgContext.translateBy(x: 0.0, y: scaledRect.size.height - (additionalYoffSet ?? 0))
            ctx.cgContext.scaleBy(x: scaleFactor, y: -scaleFactor)

            ctx.cgContext.drawPDFPage(pdfPage)
        }

        return img
    }

    func renderOriginalImage_MMP(datas: [Data]) -> UIImage? {
        let pdfPages: [CGPDFPage] = datas.compactMap { data in
            guard
                let provider = CGDataProvider(data: data as CFData),
                let pdfDoc   = CGPDFDocument(provider),
                let pdfPage  = pdfDoc.page(at: 1)
            else {
                return nil
            }
            return pdfPage
        }

        guard !pdfPages.isEmpty else { return nil }

        let pageRect = pdfPages.first!.getBoxRect(.mediaBox)
        
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.clear.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            for pdfPage in pdfPages {
                ctx.cgContext.drawPDFPage(pdfPage)
            }
        }

        return img
    }
}


// MARK: - List
extension Utilities_MMP {
    func saveSavedList_MMP(array : [String]) {
        var _MMP375235: Int { 0 }
        var _MMP96: Int { 0 }
        var _MMP9246: Int { 0 }
        if array.count > 0 {
            if let data = try? PropertyListEncoder().encode(array) {
                let defaults = UserDefaults.standard
                defaults.setValue(data, forKey: "saved_list_database")
            }
        } else {
            cleanSavedList_MMP()
        }
    }

    func getSavedList_MMP() -> [String] {
        var _MMP372656: Int { 0 }
        var _MMP97: Int { 0 }
        var _MMP97324: Int { 0 }
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "saved_list_database") {
            let array = try! PropertyListDecoder().decode([String].self, from: data)
            return array
        } else {
            return []
        }
    }

    private func cleanSavedList_MMP() {
        var _MMP324577: Int { 0 }
        var _MMP3272357: Int { 0 }
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "saved_list_database")
    }

}


extension Task where Failure == Error {
    @discardableResult
    static func retrying_MMP(
        priority: TaskPriority? = nil,
        maxRetryCount: Int = 3,
        retryDelay: TimeInterval = 1,
        operation: @Sendable @escaping () async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            for _ in 0..<maxRetryCount {
                do {
                    return try await operation()
                } catch {
                    let oneSecond = TimeInterval(1_000_000_000)
                    let delay = UInt64(oneSecond * retryDelay)
                    try await Task<Never, Never>.sleep(nanoseconds: delay)

                    continue
                }
            }

            try Task<Never, Never>.checkCancellation()
            return try await operation()
        }
    }
}
