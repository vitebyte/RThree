//
//  UserManager.swift
//  DigitalEcoSystem
//
//  Created by Shafi Ahmed on 08/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

let ACTIVE_USER_KEY = "activeUser"
let ACTIVE_USER_TOKEN = "userToken"
let ACTIVE_USER_ID = "userId"
let LOGGED_USER_EMAIL_KEY = "userEmail"
let ACTIVE_USER_ROLE = "roleId"
let ACTIVE_USER_LANGUAGE = "langCode"

class UserManager: NSObject {
    fileprivate var _userId: String = ""
    fileprivate var _activeUser: User?
    fileprivate var _userToken: String = ""
    private static let _sharedManager = UserManager()

    open class var shared: UserManager {
        return _sharedManager
    }

    fileprivate override init() {
        super.init()
        /**
         * Initiate any queues / arrays / filepaths etc.
         */

        if isUserLoggedIn() { // Load last logged user data if exists
            loadActiveUser()
        }
    }

    // MARK: - Current User Selected Language Code
    var userLanguageCode: String {
        let languageArray: [Language] = UserManager.shared.activeUser.language!
        let langArray = languageArray.filter { $0.id == UserManager.shared.activeUser.langCode }
        if langArray.count > 0 {
            let lang: Language = langArray.first!
            return lang.code!
        } else {
            return "en"
        }
    }

    // MARK: - Current User
    var isStoreManager: Bool {
        if activeUser.roleId == UserRole.StoreManager.hashValue {
            return true
        }
        return false
    }

    /**
     * returns reference to active i.e. logged in user
     */
    var activeUser: User! {
        get {
            return _activeUser
        }
        set {
            if newValue != nil {
                _activeUser = newValue
                userToken = (_activeUser?.sessionId)!
                userId = String(describing: _activeUser?.userId!)

                if let _ = _activeUser {
                    saveActiveUser()
                }
            }
        }
    }

    /**
     * Gets logged in user token
     */
    var userToken: String {
        set(newValue) {
            _userToken = newValue
            let defaults = UserDefaults.standard
            defaults.set(_userToken, forKey: ACTIVE_USER_TOKEN)
            defaults.synchronize()
        }
        get {
            let defaults = UserDefaults.standard
            guard let _uToken = defaults.value(forKey: ACTIVE_USER_TOKEN) else {
                _userToken = ""
                return _userToken
            }
            _userToken = _uToken as! String
            return _userToken
        }
    }

    /**
     * Gets logged in user Id
     */
    var userId: String {
        set(newValue) {
            _userId = newValue
            let defaults = UserDefaults.standard
            defaults.set(_userId, forKey: ACTIVE_USER_ID)
            defaults.synchronize()
        }
        get {
            let defaults = UserDefaults.standard
            guard let _uId = defaults.value(forKey: ACTIVE_USER_ID) else {
                _userId = ""
                return _userId
            }
            _userId = _uId as! String
            return _userId
        }
    }

    /**
     * MARK: - Get Current User Role
     */
    /*
     func activeUserRole(_ role: NSNumber) ->UserRole {
     if let _ = UserRole(rawValue: role) {
     return UserRole(rawValue: role)!
     } else {
     return UserRole.Invalid
     }
     } */

    /**
     * Check if user is logged in or not
     */
    func isUserLoggedIn() -> Bool {
        guard let _ = UserDefaults.objectForKey(ACTIVE_USER_KEY) else {
            return false
        }

        loadActiveUser()
        return true
    }

    /**
     * Perform logout
     */
    func logoutUser() {
        deleteActiveUser()
        UserManager.shared.userToken = ""
    }

    // MARK: - KeyChain / User Defaults / Flat file / XML

    /**
     * Load last logged user data, if any
     */
    func loadActiveUser() {
        guard let decodedUser = UserDefaults.objectForKey(ACTIVE_USER_KEY) as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: decodedUser) as? User
        else {
            return
        }
        self.activeUser = user
    }

    func lastLoggedUserEmail() -> String? {
        return UserDefaults.objectForKey(LOGGED_USER_EMAIL_KEY) as? String
    }

    /**
     * Save current user data
     */
    func saveActiveUser() {
        UserDefaults.setObject(NSKeyedArchiver.archivedData(withRootObject: self.activeUser) as AnyObject?, forKey: ACTIVE_USER_KEY)
        if let email = self.activeUser.userEmailId {
            UserDefaults.setObject(email as AnyObject?, forKey: LOGGED_USER_EMAIL_KEY)
        }
    }

    /**
     * Delete current user data
     */
    func deleteActiveUser() {
        UserDefaults.removeObjectForKey(ACTIVE_USER_KEY)

        // free user object memory
        self.activeUser = nil
    }

    /**
     * Current User Selected Language
     */
    func userLanguage() -> Language? {
        let languageArray: [Language] = UserManager.shared.activeUser.language!
        let langArray = languageArray.filter { $0.id == UserManager.shared.activeUser.langCode }
        if langArray.count > 0 {
            return langArray.first!
        } else {
            return nil
        }
    }
}
