//
//  ConfigurationManager.swift
//
//  Created by Shafi Ahmed on 07/04/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

final class ConfigurationManager: NSObject {

    /*
     Open your Project Build Settings and search for “Swift Compiler – Custom Flags” … “Other Swift Flags”.
     Add “-DDEVELOPMENT” to the Debug section
     Add “-DQA” to the QA section
     Add “-DSTAGING” to the Staging section
     Add “-DPRODUCTION” to the Release section
     */

    fileprivate var http: String = "http://"
    fileprivate var https: String = "https://"

    fileprivate enum AppEnvironment: String {
        case Development
        case QA
        case Staging
        case Production
    }

    fileprivate struct AppConfiguration {
        var apiEndPoint: String
        var environment: AppEnvironment
    }

    fileprivate struct Flags {
        var loggingEnabled: Bool
        var trackingEnabled: Bool
    }

    fileprivate struct Tokens {
        static let analyticsKey: String! = "" // add analytics key here
        static let facebookAppKey: String! = "" // add facebook key here
    }

    fileprivate var activeConfiguration: AppConfiguration!

    // MARK: - Singleton Instance
    private static let _sharedManager = ConfigurationManager()

    open class var shared: ConfigurationManager {
        return _sharedManager
    }

    private override init() {
        super.init()

        // Load application selected environment and its configuration
        if let environment = self.currentEnvironment() {

            activeConfiguration = configuration(environment: environment)

            if activeConfiguration == nil {
                assertionFailure(NSLocalizedString("Unable to load application configuration", comment: "Unable to load application configuration"))
            }
        } else {
            assertionFailure(NSLocalizedString("Unable to load application flags", comment: "Unable to load application flags"))
        }
    }

    private func currentEnvironment() -> AppEnvironment? {

        #if QA
            return AppEnvironment.QA
        #elseif STAGING
            return AppEnvironment.Staging
        #elseif PRODUCTION
            return AppEnvironment.Production
        #else // Default configuration DEVELOPMENT
            return AppEnvironment.Development
        #endif

        /* let environment = Bundle.main.infoDictionary?["ActiveConfiguration"] as? String
         return environment */
    }

    /**
     Returns application active configuration

     - parameter environment: An application selected environment

     - returns: An application configuration structure based on selected environment
     */
    private func configuration(environment: AppEnvironment) -> AppConfiguration {

        switch environment {
        case .Development:
            return debugConfiguration()
        case .QA:
            return qaConfiguration()
        case .Staging:
            return stagingConfiguration()
        case .Production:
            return productionConfiguration()
        }
    }

    private func debugConfiguration() -> AppConfiguration {
        return AppConfiguration(apiEndPoint: http + "34.205.47.58:8080/ddpx/api/v1",
                                environment: .Development)
    }

    private func qaConfiguration() -> AppConfiguration {
        return AppConfiguration(apiEndPoint: http + "34.198.169.166:8080/ddpx/api/v1",
                                environment: .QA)
    }

    private func stagingConfiguration() -> AppConfiguration {
        return AppConfiguration(apiEndPoint: http + "54.85.234.225:8080/ddpx/api/v1",
                                environment: .Staging)
    }

    private func productionConfiguration() -> AppConfiguration {
        return AppConfiguration(apiEndPoint: https + "deandelucaxp.com/api/v1",
                                environment: .Production)
    }
}

extension ConfigurationManager {

    // MARK: - Configuration

    func applicationEnvironment() -> String {
        return activeConfiguration.environment.rawValue
    }

    func applicationEndPoint() -> String {
        return activeConfiguration.apiEndPoint
    }

    func applicationImageEndPoint() -> String {
        return https + "s3.amazonaws.com/"
    }

    // MARK: - Flags
    /*
     func loggingEnabled() -> Bool {
     return self.activeConfiguration.log
     }

     func trackingEnabled() -> Bool {
     return self.activeConfiguration.trackingEnabled
     }*/

    // MARK: - Tokens
    func analyticsKey() -> String {
        return ConfigurationManager.Tokens.analyticsKey
    }

    func facebookAppId() -> String {
        return ConfigurationManager.Tokens.facebookAppKey
    }
}
