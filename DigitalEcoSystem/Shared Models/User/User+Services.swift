//
//  User+Services.swift
//  DigitalEcoSystem
//
//  Created by Shafi Ahmed on 08/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import ObjectMapper

extension User {

    //MARK : - login eith email
    class func performLoginWithEmail(email: String, password: String, completionHandler: @escaping (_ success: Bool, _ message: String?) -> Void) {

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, Helper.noInternetConnection().localizedFailureReason)
            return
        }

        var params = Helper.defaultServiceParameters
        params[Constants.APIKEYS.EMAIL] = email
        params[Constants.APIKEYS.PASSWORD] = password
        params[Constants.APIKEYS.DEVICE_TYPE] = "1" // iOS(1) ,Android(2)

        let headers = Helper.defaultServiceHeaders
        NetworkManager.requestPOSTURL(Constants.APIServiceMethods.loginAPI, params: params as [String: AnyObject]?, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {
                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String
                if isSuccess {
                    if let resultData = responseDictionary?[Constants.APIKEYS.DATA] as? [String: Any] {
                        let loggedInUser = User(object: resultData)
                        UserManager.shared.activeUser = loggedInUser
                        completionHandler(true, message)
                        return
                    }
                    completionHandler(false, message)
                    LogManager.logError("Error while login from email \(message)")
                } else {
                    completionHandler(false, message)
                     LogManager.logError("Error while login from email \(message)")
                }
            } else {
                completionHandler(false, LocalizedString.shared.RESPONSE_ERROR)
                LogManager.logError("Error whole login from email \(LocalizedString.shared.RESPONSE_ERROR)")
            }

        }) { error in
            Helper.hideLoader()
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription)
        }
    }

    //MARK : - logout
    func performLogout(completionHandler: @escaping (_ success: Bool, _ message: String?) -> Void) {

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, Helper.noInternetConnection().localizedFailureReason)
            return
        }

        let headers = Helper.defaultServiceHeaders
        let params = Helper.defaultServiceParameters

        Helper.showLoader()
        NetworkManager.requestPOSTURL(Constants.APIServiceMethods.logoutAPI, params: params as [String: AnyObject]?, headers: headers, success: {
            responseJSON in
            Helper.hideLoader()
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {
                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String
                UserManager.shared.logoutUser()

                if isSuccess {
                    completionHandler(true, message)
                    LogManager.logError("Error while logging out \(message)")
                } else {
                    completionHandler(false, message)
                    LogManager.logError("Error while logging out \(message)")
                }
            } else {
                completionHandler(false, LocalizedString.shared.RESPONSE_ERROR)
                LogManager.logError("Error while logging out \(LocalizedString.shared.RESPONSE_ERROR)")
            }

        }, failure: { error in
            Helper.hideLoader()
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription)
        })
    }

    //MARK : - update profile picture with image
    func performUploadProfilePictureWithImage(image: UIImage, completionHandler: @escaping (_ success: Bool, _ message: String?) -> Void) {
        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, Helper.noInternetConnection().localizedFailureReason)
            return
        }

        let headers = Helper.defaultServiceHeaders
        var params = Helper.defaultServiceParameters
        params["profilePic"] = UIImageJPEGRepresentation(image, 0.5)

        Helper.showLoader()
        NetworkManager.uploadImageWithMultipartFormData(Constants.APIServiceMethods.saveProfilePicAPI, params: params as [String: AnyObject]?, headers: headers, success: { responseJSON in
            Helper.hideLoader()
            if let responseDictionary = responseJSON.dictionaryObject {
                let isSuccess = responseDictionary[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary[Constants.APIKEYS.MESSAGE] as! String
                if isSuccess {
                    if let imageURL = responseDictionary[Constants.APIKEYS.DATA] as! String? {
                        let user = UserManager.shared.activeUser
                        user?.profileImg = imageURL
                        UserManager.shared.saveActiveUser()
                        // UserManager.shared.activeUser.imageUrl = imageURL
                        completionHandler(true, message)
                    }
                } else {
                    completionHandler(false, message)
                    LogManager.logError("Error while uploading profile image \(message)")
                    
                }
            }
        }, failure: { error in
            Helper.hideLoader()
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription)
        })
    }

    //MARK : - update language selected by user
    func performUploadLanguageSelectedByUser(language: Int, completionHandler: @escaping (_ success: Bool, _ message: String?) -> Void) {
        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, Helper.noInternetConnection().localizedFailureReason)
            return
        }

        let headers = Helper.defaultServiceHeaders
        var params = Helper.defaultServiceParameters
        params["langCode"] = language

        let userIdInt = Int(UserManager.shared.activeUser.userId!)
        let langurl = Constants.APIServiceMethods.languageAPI
        let urlString: String = NSString(format: langurl as NSString, "\(language)", "\(userIdInt)") as String
        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            if let responseDictionary = responseJSON.dictionaryObject {
                let isSuccess = responseDictionary[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary[Constants.APIKEYS.MESSAGE] as! String
                if isSuccess {
                    let user = UserManager.shared.activeUser
                    user?.langCode = language
                    UserManager.shared.saveActiveUser()
                    completionHandler(true, message)
                } else {
                    completionHandler(false, message)
                    LogManager.logError("Error while uploading language selected by user \(message)")
                }
            }
        }, failure: { error in
            Helper.hideLoader()
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription)
        })
    }

    // MARK: - Get Associates List
    func getAssociatesList(_ storeId: Int, pageNumber: Int, completionHandler: @escaping (_ success: Bool, _ message: String?, _ resultArray: [User]?, _ resultCount: Int, _ pageCount: Int) -> Void) {

        let DEFAULT_VALUE: Int = 1

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, Helper.noInternetConnection().localizedFailureReason, nil, 0, 0)
            return
        }

        let headers = Helper.defaultServiceHeaders
        let urlString: String = NSString(format: Constants.APIServiceMethods.associatesListAPI as NSString, "\(storeId)", "\(pageNumber)") as String
        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {
                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String
                if isSuccess {
                    var resultCount: Int = DEFAULT_VALUE
                    var pageCount: Int = DEFAULT_VALUE
                    let resultDictionary = responseDictionary?[Constants.APIKEYS.DATA] as! NSDictionary
                    if let userArray: NSArray = resultDictionary.value(forKey: Constants.APIKEYS.CONTENTLIST) as? NSArray {
                        var associateList: [User]? = [User]()
                        for associate in userArray {
                            let associateUser = User(object: associate)
                            associateUser.userName = associateUser.userName?.capitalizingFirstLetter()
                            associateList?.append(associateUser)
                        }

                        if let resultCountVal: Int = resultDictionary[Constants.APIKEYS.NUMBER_OF_RESULTS] as? Int {
                            resultCount = resultCountVal
                        }
                        if let pageCountValue: Int = resultDictionary[Constants.APIKEYS.TOTAL_PAGES] as? Int {
                            pageCount = pageCountValue
                        }
                        completionHandler(true, message, associateList, resultCount, pageCount)
                    } else {
                        completionHandler(true, message, nil, DEFAULT_VALUE, DEFAULT_VALUE)
                    }
                } else {
                    completionHandler(false, message, nil, DEFAULT_VALUE, DEFAULT_VALUE)
                    LogManager.logError("Error while getting associate list \(message)")
                }
            } else {
                completionHandler(false, "couldn't parse the response", nil, DEFAULT_VALUE, DEFAULT_VALUE)
                LogManager.logError("Error while parsing received associate list")
                
            }
        }) { error in
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription, nil, DEFAULT_VALUE, DEFAULT_VALUE)
        }
    }

    // MARK: - Get Trainers List
    func getTrainersList(_ pageNumber: Int, completionHandler: @escaping (_ success: Bool, _ message: String?, _ resultArray: [User]?, _ resultCount: Int, _ pageCount: Int) -> Void) {

        let DEFAULT_VALUE: Int = 1

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, Helper.noInternetConnection().localizedFailureReason, nil, 0, 0)
            return
        }

        let headers = Helper.defaultServiceHeaders
        let urlString: String = NSString(format: Constants.APIServiceMethods.trainersListAPI as NSString, "\(pageNumber)", "\(pageNumber)") as String
        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {
                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String
                if isSuccess {
                    var resultCount: Int = DEFAULT_VALUE
                    var pageCount: Int = DEFAULT_VALUE
                    let resultDictionary = responseDictionary?[Constants.APIKEYS.DATA] as! NSDictionary
                    if let userArray: NSArray = resultDictionary.value(forKey: Constants.APIKEYS.CONTENTLIST) as? NSArray {
                        var associateList: [User]? = [User]()
                        for associate in userArray {
                            let associateUser = User(object: associate)
                            associateUser.userName = associateUser.userName?.capitalizingFirstLetter()
                            associateList?.append(associateUser)
                        }

                        if let resultCountVal: Int = resultDictionary[Constants.APIKEYS.NUMBER_OF_RESULTS] as? Int {
                            resultCount = resultCountVal
                        }
                        if let pageCountValue: Int = resultDictionary[Constants.APIKEYS.TOTAL_PAGES] as? Int {
                            pageCount = pageCountValue
                        }
                        completionHandler(true, message, associateList, resultCount, pageCount)
                    } else {
                        completionHandler(true, message, nil, DEFAULT_VALUE, DEFAULT_VALUE)
                    }
                } else {
                    completionHandler(false, message, nil, DEFAULT_VALUE, DEFAULT_VALUE)
                    LogManager.logError("Error while getting trainers list \(message)")
                    
                }
            } else {
                completionHandler(false, "couldn't parse the response", nil, DEFAULT_VALUE, DEFAULT_VALUE)
                LogManager.logError("Error while parsing of getting trainers list ")
            }
        }) { error in
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription, nil, DEFAULT_VALUE, DEFAULT_VALUE)
        }
    }

    // MARK: - Get Trainees List
    // As a associate I m trainer also, I can view my 'Trainee(s)'
    func getTraineesList(_ pageNumber: Int, completionHandler: @escaping (_ success: Bool, _ message: String?, _ resultArray: [User]?, _ resultCount: Int, _ pageCount: Int) -> Void) {

        let DEFAULT_VALUE: Int = 1

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, Helper.noInternetConnection().localizedFailureReason, nil, 0, 0)
            return
        }

        let headers = Helper.defaultServiceHeaders
        let urlString: String = NSString(format: Constants.APIServiceMethods.traineesListAPI as NSString, "\(pageNumber)") as String
        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {
                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String
                if isSuccess {
                    var resultCount: Int = DEFAULT_VALUE
                    var pageCount: Int = DEFAULT_VALUE
                    let resultDictionary = responseDictionary?[Constants.APIKEYS.DATA] as! NSDictionary
                    if let userArray: NSArray = resultDictionary.value(forKey: Constants.APIKEYS.CONTENTLIST) as? NSArray {
                        var associateList: [User]? = [User]()
                        for associate in userArray {
                            let associateUser = User(object: associate)
                            associateUser.userName = associateUser.userName?.capitalizingFirstLetter()
                            associateList?.append(associateUser)
                        }

                        if let resultCountVal: Int = resultDictionary[Constants.APIKEYS.NUMBER_OF_RESULTS] as? Int {
                            resultCount = resultCountVal
                        }
                        if let pageCountValue: Int = resultDictionary[Constants.APIKEYS.TOTAL_PAGES] as? Int {
                            pageCount = pageCountValue
                        }
                        completionHandler(true, message, associateList, resultCount, pageCount)
                    } else {
                        completionHandler(true, message, nil, DEFAULT_VALUE, DEFAULT_VALUE)
                    }
                } else {
                    completionHandler(false, message, nil, DEFAULT_VALUE, DEFAULT_VALUE)
                    LogManager.logError("Error while getting trainee list \(message)")
                }
            } else {
                completionHandler(false, "couldn't parse the response", nil, DEFAULT_VALUE, DEFAULT_VALUE)
                LogManager.logError("Error while parsing received trainee list")
            }
        }) { error in
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription, nil, DEFAULT_VALUE, DEFAULT_VALUE)
        }
    }

    // TODO: future versions
    // MARK: - Get Trainees Training
    // As a associate I m trainer also, I can view my 'Trainee(s)' and his training
    func getTraineeTrainingList(_: Int, _: Int, completionHandler: @escaping (_ success: Bool, _ message: String?, _ resultArray: [Training]?, _ resultCount: Int, _ pageCount: Int) -> Void) {

        let DEFAULT_VALUE: Int = 1

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, Helper.noInternetConnection().localizedFailureReason, nil, 0, 0)
            return
        }

        let headers = Helper.defaultServiceHeaders
        // let urlString: String = NSString(format: Constants.APIServiceMethods.traineesTrainingList as NSString, "\(pageNumber)") as String
        let urlString: String = ""
        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {
                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String
                if isSuccess {
                    var resultCount: Int = DEFAULT_VALUE
                    var pageCount: Int = DEFAULT_VALUE
                    let resultDictionary = responseDictionary?[Constants.APIKEYS.DATA] as! NSDictionary
                    if let trainingArray: NSArray = resultDictionary.value(forKey: Constants.APIKEYS.CONTENTLIST) as? NSArray {
                        var trainingList: [Training]? = [Training]()
                        for tempTraining in trainingArray {
                            let trainingObj = Training(object: tempTraining)
                            trainingList?.append(trainingObj)
                        }

                        if let resultCountVal: Int = resultDictionary[Constants.APIKEYS.NUMBER_OF_RESULTS] as? Int {
                            resultCount = resultCountVal
                        }
                        if let pageCountValue: Int = resultDictionary[Constants.APIKEYS.TOTAL_PAGES] as? Int {
                            pageCount = pageCountValue
                        }
                        completionHandler(true, message, trainingList, resultCount, pageCount)
                    } else {
                        completionHandler(true, message, nil, DEFAULT_VALUE, DEFAULT_VALUE)
                    }
                } else {
                    completionHandler(false, message, nil, DEFAULT_VALUE, DEFAULT_VALUE)
                    LogManager.logError("Error while getting trainee training list \(message)")
                }
            } else {
                completionHandler(false, "couldn't parse the response", nil, DEFAULT_VALUE, DEFAULT_VALUE)
                LogManager.logError("Error while parsing trainee training list")
            }
        }) { error in
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription, nil, DEFAULT_VALUE, DEFAULT_VALUE)
        }
    }
}
