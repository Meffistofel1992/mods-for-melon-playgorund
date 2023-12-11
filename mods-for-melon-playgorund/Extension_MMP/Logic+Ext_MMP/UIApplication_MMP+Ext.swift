//
//  UIApplication+Ext.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 08.11.2023.
//

import UIKit

typealias MMP_UIApplication = UIApplication

extension MMP_UIApplication {
    func addTapGestureRecognizer() {
        guard let window = UIApplication.shared.currentKeyWindow else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension MMP_UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}

extension MMP_UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension MMP_UIApplication {
    static func rootVC() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        guard let rootViewController = windowScene.windows.first?.rootViewController else {
            return nil
        }

        return rootViewController
    }

    static var viewBounds: CGSize {
        UIApplication.shared.currentKeyWindow?.screen.bounds.size ?? .zero
    }
}

extension MMP_UIApplication {
  var currentKeyWindow: UIWindow? {
    UIApplication.shared.connectedScenes
//      .filter { $0.activationState == .foregroundActive }
      .map { $0 as? UIWindowScene }
      .compactMap { $0 }
      .first?.windows
      .filter { $0.isKeyWindow }
      .first
  }

    var currentScene: UIWindowScene? {
        UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene
    }

    var rootViewController: UIViewController? {
        currentKeyWindow?.rootViewController
    }

    var keyWindowPresentedController: UIViewController? {
        var viewController = currentKeyWindow?.rootViewController
        if let presentedController = viewController as? UITabBarController {
            viewController = presentedController.selectedViewController
        }
        while let presentedController = viewController?.presentedViewController {
            if let presentedController = presentedController as? UITabBarController {
                viewController = presentedController.selectedViewController
            } else {
                viewController = presentedController
            }
        }
        return viewController
    }
}
