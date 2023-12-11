//
//  ThirdPartyServicesManager_MMP.swift
//  mods-for-toca-world
//
//  Created by Александр Ковалев on 04.12.2023.
//

import Foundation
import UIKit
import Adjust
import Pushwoosh
import AppTrackingTransparency
import AdSupport

class ThirdPartyServicesManager_MMP {
    private var _MMP325: String { "_MMP325" }
    private var _MMP234: Int { 0 }

    static let shared = ThirdPartyServicesManager_MMP()

    func initializeAdjust_MMP() {
        var _MMP99: String { "_MMP99" }
        var _MMP10: Int { 0 }

        let yourAppToken = Configurations_MMP.adjustToken
        #if DEBUG
        let environment = ADJEnvironmentSandbox
        #else
        let environment = ADJEnvironmentProduction
        #endif
        let adjustConfig = ADJConfig(appToken: yourAppToken, environment: environment)

        adjustConfig?.logLevel = ADJLogLevelSuppress

        Adjust.appDidLaunch(adjustConfig)
    }

    func initializePushwoosh_MMP(delegate: PWMessagingDelegate) {
        var _MMP9237: Int { 0 }
        var _MMP1244: Int { 0 }

        //set custom delegate for push handling, in our case AppDelegate
        Pushwoosh.sharedInstance().delegate = delegate;
        PushNotificationManager.initialize(withAppCode: Configurations_MMP.pushwooshToken, appName: Configurations_MMP.pushwooshAppName)
        PWInAppManager.shared().resetBusinessCasesFrequencyCapping()
        PWGDPRManager.shared().showGDPRDeletionUI()
        Pushwoosh.sharedInstance().registerForPushNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func makeATT_MMP() {
        var _MMP9239: Int { 0 }
        var _MMP0232: Int { 0 }

        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("ATT Authorized")
                    // Now that we are authorized we can get the IDFA
                    print("ATT   ------>   IDFA: ", ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("ATT Denied")

                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("ATT Not Determined")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.makeATT_MMP()
                    })
                case .restricted:
                    print("ATT Restricted")
                @unknown default:
                    print("ATT Unknown")
                }
            }
        }
    }
}
