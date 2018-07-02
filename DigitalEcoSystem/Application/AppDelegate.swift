//
//  AppDelegate.swift
//  DigitalEcoSystem
//
//  Created by Shafi Ahmed on 06/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit
import Localize_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // Present application root view controller
        AppDelegate.presentRootViewController()
        CoreDataManager.initializeCachingEngine()
        
       // Fabric.with([Crashlytics.self])
        
        setupLogger()

        // Register device for push notification
        self.registerRemoteNotification()
        
        print(ConfigurationManager.shared.applicationEnvironment())
        print(ConfigurationManager.shared.applicationEndPoint())

        return true
    }

    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

//MARK: helper methods
extension AppDelegate {

    class func delegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    // MARK: - Root View Controller
    class func presentRootViewController(_ animated: Bool = false) {
        if animated {
            let animation: CATransition = CATransition()
            animation.duration = CFTimeInterval(0.5)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = kCATransitionMoveIn
            animation.subtype = kCATransitionFromTop
            animation.fillMode = kCAFillModeForwards
            AppDelegate.delegate().window?.layer.add(animation, forKey: "animation")
            AppDelegate.delegate().window?.rootViewController = AppDelegate.appRootViewController()
        } else {
            AppDelegate.delegate().window?.rootViewController = AppDelegate.appRootViewController()
        }
    }

    fileprivate class func appRootViewController() -> UIViewController! {

        if UserManager.shared.isUserLoggedIn() {

            let lang = UserManager.shared.activeUser.langCode
            let userLang: [Language] = UserManager.shared.activeUser.language!.filter { $0.id == lang }
            if userLang.count > 0 {
                Localize.setCurrentLanguage((userLang.first?.code)!)
            }

            if UserManager.shared.isStoreManager {
                let storyBoard = UIStoryboard.storeManagerStoryboard()
                let storeTabBarController = storyBoard.instantiateViewController(withIdentifier: "StoreManagerTabbarViewController") as! StoreManagerTabbarViewController
                storeTabBarController.selectedIndex = 2
                return storeTabBarController
            } else {
                let storyBoard = UIStoryboard.mainStoryboard()
                let tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarViewController
                tabBarController.selectedIndex = 2
                return tabBarController
            }
        } else {
            // OnBoarding
            let storyBoard = UIStoryboard.mainStoryboard()
            let navController: UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
            return navController
        }
        
    }
    
    //MARK: - Setup log manager
    func setupLogger() {
        #if DEBUG
            LogManager.setup(logLevel: .debug)
        #else
            LogManager.setup(logLevel: .error)
        #endif
    }
}

