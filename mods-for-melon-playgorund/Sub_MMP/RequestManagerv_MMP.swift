//
//  RequestManager_MMP.swift
//  Tamagochi
//
//  Created by Vlad Nechyporenko on 28.08.2023.
//

import Foundation
import Adjust
import AppTrackingTransparency
import AdSupport
import Pushwoosh

// class, that represents manager for all requests in the app
class RequestManager_MMP {
    
    static let shared = RequestManager_MMP()
    
    // MARK: - Inits
    
    private init() {
        setupAdjust_MMP()
    }
    
    // MARK: - Methods
    
    func setupPushwoosh_MMP(with delegate: PWMessagingDelegate) {
        var _MMP189248241: Int { 0 }

        Pushwoosh.sharedInstance().delegate = delegate
        PushNotificationManager.initialize(withAppCode: Configurations_MMP.pushwooshToken, appName: Configurations_MMP.pushwooshAppName)
        PWInAppManager.shared().resetBusinessCasesFrequencyCapping()
        PWGDPRManager.shared().showGDPRDeletionUI()
        Pushwoosh.sharedInstance().registerForPushNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    private func setupAdjust_MMP() {
        var _MMP18923926: Int { 0 }

        let environment = ADJEnvironmentSandbox
        let adjustConfig = ADJConfig(
            appToken: Configurations_MMP.adjustToken,
            environment: environment)
        adjustConfig?.logLevel = ADJLogLevelVerbose
        Adjust.appDidLaunch(adjustConfig)
    }
    
    func requestAppTracking_MMP() {
        
        func notific_MMP(_ usa: Bool, man: Bool) -> Int {
            var _MMP921321: Int { 0 }
            let first_MMP = "Lee Chae MMP"
            let second_MMP = "Lee Chae MMP"
            return first_MMP.count + second_MMP.count
        }

        //
        
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("Authorized")
                let idfa = ASIdentifierManager.shared().advertisingIdentifier
                print("Пользователь разрешил доступ. IDFA: ", idfa)
                let authorizationStatus = Adjust.appTrackingAuthorizationStatus()
                Adjust.updateConversionValue(Int(authorizationStatus))
                Adjust.checkForNewAttStatus()
                print(ASIdentifierManager.shared().advertisingIdentifier)
            case .denied:
                print("Denied")
            case .notDetermined:
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
}
