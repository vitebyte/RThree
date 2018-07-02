//
//  AppDelegate+Notification.swift
//  TemplateApp
//
//  Created by Shafi Ahmed on 17/05/16.
//  Copyright © 2016 Appster. All rights reserved.
//


// temp changes 

import Foundation

extension AppDelegate {

    struct Keys {
        static let deviceToken = "deviceToken"
    }

    // MARK: - UIApplicationDelegate Methods
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Prepare the Device Token for Registration (remove spaces and < >)
        if #available(iOS 10.0, *) {
            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
            print(deviceTokenString)
            UserDefaults.setObject(deviceTokenString as AnyObject?, forKey: Keys.deviceToken)
        } else {
            self.setDeviceToken(deviceToken)
            print("\(deviceToken.description)")
        }
    }

    func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

        print("receive : \(userInfo.debugDescription)")
    }

    // MARK: - Private Methods
    /**
     Register remote notification to send notifications
     */
    func registerRemoteNotification() {

        let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)

        // This is an asynchronous method to retrieve a Device Token
        UIApplication.shared.registerForRemoteNotifications()
    }

    /**
     Deregister remote notification
     */
    func deregisterRemoteNotification() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }

    func setDeviceToken(_ token: Data) {
        let deviceToken = token.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        UserDefaults.setObject(deviceToken as AnyObject?, forKey: Keys.deviceToken)
        
    }

    func deviceToken() -> String {
        var deviceToken: String? = UserDefaults.objectForKey("deviceToken") as? String

        if isObjectInitialized(deviceToken as AnyObject?) {
            return deviceToken!
        }

        if deviceToken == nil {
            deviceToken = String.randomString(length: 15) //randomString(length: 16)
        }
        return deviceToken!
    }

    /**
     Receive information from remote notification. Parse response.

     - parameter userInfo: Response from server
 
    func recievedRemoteNotification(_ userInfo: NSDictionary) {

    }
  */

}
