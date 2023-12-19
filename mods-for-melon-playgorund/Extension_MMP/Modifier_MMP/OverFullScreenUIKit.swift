//
//  OverFullScreenUIKit.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 14.12.2023.
//

import SwiftUI

fileprivate final class PresentedHostingController<Content>:
    UIHostingController<Content> where Content: View
{
    /*dummy*/
}

extension View {
    func presentModelWithUIKit<ContentView>(
        element: Binding<Bool>,
        presentationStyle: UIModalPresentationStyle = .pageSheet,
        transitionStyle: UIModalTransitionStyle? = nil,
        backgroundColor: UIColor? = nil,
        content: BuilderClosure_MMP<ContentView>
    ) -> some View where ContentView: View {
        let presentingController = Utilities_MMP.shared.topViewController_MMP() as? PresentedHostingController<ContentView>

        if element.wrappedValue {
            let isViewControllerAlreadyPresented = presentingController != nil
            if isViewControllerAlreadyPresented {
                // this prevent from presenting one more instance of controller
                // when SwiftUI View redraw body during presentation of this controller
                return self
            }

            let presentableContent = PresentedHostingController<ContentView>(
                rootView: content()
            )
            presentableContent.modalPresentationStyle = presentationStyle
            if let transitionStyle {
                presentableContent.modalTransitionStyle = transitionStyle
            }
            if let backgroundColor {
                presentableContent.view.backgroundColor = backgroundColor
            }

            Utilities_MMP.shared.rootVC()?.present(presentableContent, animated: true)
        } else {
            if let controller = presentingController {
                controller.dismiss(animated: true)
            }
        }

        return self
    }
}
