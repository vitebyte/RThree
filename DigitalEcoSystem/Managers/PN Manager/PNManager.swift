//
//  PNManager.swift
//  DigitalEcoSystem
//
//  Created by Shafi Ahmed on 08/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit
import UserNotifications
class PNManager: NSObject {

    // MARK: - Singleton Instance
    private static let _sharedManager = PNManager()
    var devicePushToken = String.randomString(length: 15)

    open class var shared: PNManager {
        return _sharedManager
    }

    private override init() {
        super.init()
    }

    /**
     * Register remote notification to send notifications
     */
    func registerRemoteNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, _ in
            // Parse errors and track state
            if granted == true {
                // save token OR push token to the server
            }
        }
    }

    /**
     * Receive information from remote notification. Parse response.
     *
     * parameter userInfo: Response from server
     */
    func recievedRemoteNotification(userInfo: NSDictionary) {
        let dictioaryUserInfo: NSDictionary = userInfo["aps"] as! NSDictionary

        if UIApplication.shared.applicationState == UIApplicationState.active {
            if let _ = dictioaryUserInfo["alert"] {

                let dictionaryData: NSDictionary? = dictioaryUserInfo["data"] as? NSDictionary
                if dictionaryData == nil {
                    return
                }

                if let userInfo = dictionaryData?["user_info"] {
                    print(userInfo)
                }
            }
        }
    }

    /**
     * Deregister remote notification
     */
    func deregisterRemoteNotification() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }

    /**
     * set device token
     */
    func setDeviceToken(token: NSData) {
        let deviceToken = token.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        devicePushToken = deviceToken
    }
}
