//
//  NSUserDefaults+Additions.swift
//  DigitalEcoSystem
//
//  Created by Shafi Ahmed on 08/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import Foundation

extension UserDefaults {

    //MARK : - set object
    class func setObject(_ value: AnyObject?, forKey defaultName: String) {
        UserDefaults.standard.set(value, forKey: defaultName)
        UserDefaults.standard.synchronize()
    }

    //MARK: object for key
    class func objectForKey(_ defaultName: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: defaultName) as AnyObject?
    }

    //MARK : - remove object for key
    class func removeObjectForKey(_ defaultName: String) {
        UserDefaults.standard.removeObject(forKey: defaultName)
        UserDefaults.standard.synchronize()
    }
}
