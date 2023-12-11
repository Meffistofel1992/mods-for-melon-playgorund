//
//  AppDelegate.swift
//  mods-for-melon-playgorund
//
//  Created by Александр Ковалев on 11.12.2023.
//

import UIKit
import Adjust
import Pushwoosh
import AdSupport
import AppTrackingTransparency
import AVFAudio

typealias AppDelegate_MMP = AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {

    private var _MMP923: String { "_MMP923" }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        var _MMP321: Int { 0 }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up AVAudioSession: \(error.localizedDescription)")
        }

        ThirdPartyServicesManager_MMP.shared.initializeAdjust_MMP()
        ThirdPartyServicesManager_MMP.shared.initializePushwoosh_MMP(delegate: self)

        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            ThirdPartyServicesManager_MMP.shared.makeATT_MMP()
        }

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
}

extension AppDelegate_MMP: PWMessagingDelegate {
    //handle token received from APNS
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var _MMP63243: Int { 0 }
        Adjust.setDeviceToken(deviceToken)
        Pushwoosh.sharedInstance().handlePushRegistration(deviceToken)
    }

    //handle token receiving error
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        var _MMP55: Int { 0 }
        Pushwoosh.sharedInstance().handlePushRegistrationFailure(error);
    }

    //this is for iOS < 10 and for silent push notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        var _MMP66: Int { 0 }
        Pushwoosh.sharedInstance().handlePushReceived(userInfo)
        completionHandler(.noData)
    }

    //this event is fired when the push gets received
    func pushwoosh(_ pushwoosh: Pushwoosh, onMessageReceived message: PWMessage) {
        var _MMP77: Int { 0 }
        print("onMessageReceived: ", message.payload?.description ?? "message.payload is nil")
    }

    //this event is fired when a user taps the notification
    func pushwoosh(_ pushwoosh: Pushwoosh, onMessageOpened message: PWMessage) {
        var _MMP88: Int { 0 }
        print("onMessageOpened: ", message.payload?.description ?? "message.payload is nil")
    }
}

