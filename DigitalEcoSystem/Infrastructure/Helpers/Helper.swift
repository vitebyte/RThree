//
//  Helper.swift
//  DigitalEcoSystem
//
//  Created by Shafi Ahmed on 08/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit
import SVProgressHUD
import CTVideoPlayerView


/**
 Global function to check if the input object is initialized or not.
 
 - parameter value: value to verify for initialization
 
 - returns: true if initialized
 */
public func isObjectInitialized(_ value: AnyObject?) -> Bool {
    guard let _ = value else {
        return false
    }
    return true
}

class Helper: NSObject {
    
    // MARK: - No Network Alert
    class func noInternetConnection() -> NSError {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: [NSLocalizedFailureReasonErrorKey: LocalizedString.shared.NETWORK_DISCONNECTED])
        debugPrint(LocalizedString.shared.NETWORK_DISCONNECTED)
        
        LogManager.logError("\(LocalizedString.shared.NETWORK_DISCONNECTED)")
        
        return error
    }

    // MARK: - Web Service Helpers
    static var defaultServiceHeaders: [String: String] {
        var headers: [String: String] = [String: String]()
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        headers[ACTIVE_USER_TOKEN] = UserManager.shared.userToken
        //headers[ACTIVE_USER_TOKEN] = AppDelegate.delegate().deviceToken()
        if UserManager.shared.isUserLoggedIn() {
            headers[ACTIVE_USER_ID] = String(UserManager.shared.activeUser.userId!)
            headers[ACTIVE_USER_LANGUAGE] = String(UserManager.shared.activeUser.langCode!)
            headers[ACTIVE_USER_ROLE] = String(UserManager.shared.activeUser.roleId!)
        }
        return headers
    }

    //MARK : - Device token
    static var defaultServiceParameters: [String: Any] {
        var parameters: [String: Any] = [String: Any]()
        parameters["deviceType"] = "1"
        parameters["deviceToken"] = AppDelegate.delegate().deviceToken()
        return parameters
    }

    // MARK: - Loader
    class func showLoader() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        SVProgressHUD.appearance().accessibilityIdentifier = "Loader"
        SVProgressHUD.show()
    }

    class func hideLoader() {
        UIApplication.shared.endIgnoringInteractionEvents()
        SVProgressHUD.dismiss()
    }

    // MARK: - Training Status
    class func statusForTraining(status: Int) -> String {
        switch status {
        case TrainingStatus.New.hashValue:
            return Constants.TrainingStatus.New
        case TrainingStatus.Completed.hashValue:
            return Constants.TrainingStatus.Completed
        case TrainingStatus.Expired.hashValue:
            return Constants.TrainingStatus.Expired
        default: // In Progress
            return Constants.TrainingStatus.InProgress
        }
    }

    //MARK: - Download video in background mode
    class func downloadVideo(_: URL) {
        // CTVideoManager.sharedInstance().startDownloadTask(with: downloadUrl)
    }

    // MARK: - Quiz result appreciation
    class func appreciationString(result persentage: Float) -> String {
        var appreciation = "Well done!"

        switch persentage {
        case 0.0 ... 40.0:
            appreciation = "Work hard"
        case 40.1 ... 60.0:
            appreciation = "Good"
        case 60.1 ... 80.0:
            appreciation = "Very Good"
        default:
            appreciation = "Well Done!"
        }

        return appreciation
    }
    
    //MARK: - date to string
    class func stringFrom(date: Date, format dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = dateFormat
        let strDate = dateFormatter.string(from: date as Date)
        return strDate
    }
    
    //MARK: - string to date
    class func dateFrom(strDate _: String, format _: String) -> Date? {
        return Date()
        /*
         let dateFormatter = DateFormatter()
         dateFormatter.locale = Locale(identifier: "en")
         dateFormatter.dateFormat = dateFormat
         let date = dateFormatter.date(from: strDate)
         return date*/
    }
}
