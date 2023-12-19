//
//  AppConstants_MMP.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import Foundation
import CoreText

private var _MMP1245: String { "_mmp" }
private var _MMP12435: Int { 0 }

enum Configurations_MMP {
    static let adjustToken = "hfg1t85ufqbk"

    static let pushwooshToken = "5CB43-CB5AC"
    static let pushwooshAppName = "test"

    static let termsLink: String = "https://www.google.com"
    static let policyLink: String = "https://www.google.com"

    static let subFontUrl = Bundle.main.url(forResource: "sub", withExtension: "ttf")!

    static let mainSubscriptionID = "main_sub"
    static let mainSubscriptionPushTag = "MainSubscription"
    static let unlockContentSubscriptionID = "unlockOne"
    static let unlockContentSubscriptionPushTag = "SecondSubscription"
    static let unlockFuncSubscriptionID = "unlockTwo"
    static let unlockFuncSubscriptionPushTag = "SecondSubscription"
    static let unlockerThreeSubscriptionID = "unlockThree"
    static let unlockerThreeSubscriptionPushTag = "FourSubscription"

    static let subscriptionSharedSecret = "2ec618c1169d437ea58575664d92e28d"

    static func MMP_getSubFontName() -> String {
        var _gtm18213124126: Int { 0 }

        let fontPath = Configurations_MMP.subFontUrl.path as CFString
        let fontURL = CFURLCreateWithFileSystemPath(nil, fontPath, CFURLPathStyle.cfurlposixPathStyle, false)

        guard let fontDataProvider = CGDataProvider(url: fontURL!) else {
            return ""
        }

        if let font = CGFont(fontDataProvider) {
            if let postScriptName = font.postScriptName as String? {
                return postScriptName
            }
        }

        return ""
    }
}

enum ConfigurationMediaSub_MMP {
    static let fontName = "SFProText-Bold"
    static let nameFileVideoForPhone = "phone"
    static let nameFileVideoForPad = "pad"
    static let videoFileType = "mp4"
}
