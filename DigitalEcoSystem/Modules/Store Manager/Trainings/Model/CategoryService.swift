//
//  CategoryService.swift
//  DigitalEcoSystem
//
//  Created by Narender Kumar on 08/05/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class CategoryService: NSObject {

    //MARK : - get category and subsub category
    class func getCategoryAndSubSubcategory(_ pageNumber: Int, completionHandler: @escaping (_ success: Bool, _ message: String?, _ resultArray: [Category]?, _ pageCount: Int) -> Void) {

        var DEFAULT_VALUE: Int = 1

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, nil, nil, 0)
            return
        }

        // Set default header
        let headers = Helper.defaultServiceHeaders

        let urlString: String = NSString(format: Constants.APIServiceMethods.categoriesAPI as NSString, "\(pageNumber)") as String

        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {

                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String

                if isSuccess {
                    var pageCount: Int = DEFAULT_VALUE
                    let resultDictionary = responseDictionary?[Constants.APIKEYS.DATA] as! NSDictionary
                    if let categoryArray: NSArray = resultDictionary.value(forKey: Constants.APIKEYS.CONTENTLIST) as? NSArray {

                        // Create Category Array
                        var catList: [Category]? = [Category]()
                        for tempCategory in categoryArray {
                            let categoryObj = Category(object: tempCategory)
                            catList?.append(categoryObj)
                        }

                        // Set total number of pages
                        if let resultCountVal: Int = resultDictionary[Constants.APIKEYS.NUMBER_OF_RESULTS] as? Int {
                            DEFAULT_VALUE = resultCountVal
                        }
                        if let pageCountValue: Int = resultDictionary[Constants.APIKEYS.TOTAL_PAGES] as? Int {
                            pageCount = pageCountValue
                        }
                        completionHandler(true, message, catList, pageCount)
                    } else {
                        completionHandler(true, message, nil, pageCount)
                    }
                } else {
                    completionHandler(false, message, nil, DEFAULT_VALUE)
                    LogManager.logError("Error occurred while getting category and sub cateogry \(message)")
                }
            } else {
                // TODO: add static string in localized string
                completionHandler(false, "couldn't parse the response", nil, DEFAULT_VALUE)
                LogManager.logError("Error occurred while parsing of data received for ctegory and subcategory")
            }
        }) { error in
            Helper.hideLoader()
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription, nil, DEFAULT_VALUE)
        }
    }

   //MARK : - Associte By (Filter) CategoryAPI
    class func getAssociateByCategory(_ categoryId: Int, subCategoryId: Int, pageNumber: Int, completionHandler: @escaping (_ success: Bool, _ message: String?, _ resultArray: [Trainee]?, _ pageCount: Int) -> Void) {

        var DEFAULT_VALUE: Int = 1

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, nil, nil, 0)
            return
        }

        // Set default header
        let headers = Helper.defaultServiceHeaders

        let urlString: String = NSString(format: Constants.APIServiceMethods.associteByFilterAPI as NSString, "\(categoryId)", "\(subCategoryId)", "\(pageNumber)") as String

        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {

                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String

                if isSuccess {
                    var pageCount: Int = DEFAULT_VALUE
                    let resultDictionary = responseDictionary?[Constants.APIKEYS.DATA] as! NSDictionary
                    if let associteArray: NSArray = resultDictionary.value(forKey: Constants.APIKEYS.CONTENTLIST) as? NSArray {

                        // Create AssociateTrainee Array
                        var associteList: [Trainee]? = [Trainee]()
                        for tempAssocite in associteArray {
                            let associateObject = Trainee(object: tempAssocite)
                            associteList?.append(associateObject)
                        }

                        // Set total number of pages
                        if let resultCountValue: Int = resultDictionary[Constants.APIKEYS.NUMBER_OF_RESULTS] as? Int {
                            DEFAULT_VALUE = resultCountValue
                        }
                        if let pageCountValue: Int = resultDictionary[Constants.APIKEYS.TOTAL_PAGES] as? Int {
                            pageCount = pageCountValue
                        }
                        completionHandler(true, message, associteList, pageCount)
                    } else {
                        completionHandler(true, message, nil, pageCount)
                    }
                } else {
                    completionHandler(false, message, nil, DEFAULT_VALUE)
                    LogManager.logError("Error occurred while getting associate by category\(message)")
                }
            } else {
                // TODO: add static string in localized string
                completionHandler(false, "couldn't parse the response", nil, DEFAULT_VALUE)
                LogManager.logError("Error occurred while parsing of data received for associate by category")
            }
        }) { error in
            Helper.hideLoader()
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription, nil, DEFAULT_VALUE)
        }
    }

    //MARK : - Training by Associates
    class func associatesTrainingByCategory(_associateId: Int, pageNumber: Int, completionHandler: @escaping (_ success: Bool, _ message: String?, _ resultArray: [Training]?, _ pageCount: Int) -> Void) {

        var DEFAULT_VALUE: Int = 1

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, nil, nil, 0)
            return
        }

        // Set default header
        let headers = Helper.defaultServiceHeaders

        let urlString: String = NSString(format: Constants.APIServiceMethods.associateTrainingListAPI as NSString, "\(_associateId)", "\(pageNumber)") as String

        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {

                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String

                if isSuccess {
                    var pageCount: Int = DEFAULT_VALUE
                    let resultDictionary = responseDictionary?[Constants.APIKEYS.DATA] as! NSDictionary
                    if let trainingArray: NSArray = resultDictionary.value(forKey: Constants.APIKEYS.CONTENTLIST) as? NSArray {

                        // Create Trainee Array
                        var trainingList: [Training]? = [Training]()
                        for tempTraining in trainingArray {
                            let trainingObj = Training(object: tempTraining)
                            trainingList?.append(trainingObj)
                        }

                        // Set total number of pages
                        if let resultCountVal: Int = resultDictionary[Constants.APIKEYS.NUMBER_OF_RESULTS] as? Int {
                            DEFAULT_VALUE = resultCountVal
                        }
                        if let pageCountValue: Int = resultDictionary[Constants.APIKEYS.TOTAL_PAGES] as? Int {
                            pageCount = pageCountValue
                        }
                        completionHandler(true, message, trainingList, pageCount)
                    } else {
                        completionHandler(true, message, nil, pageCount)
                    }
                } else {
                    completionHandler(false, message, nil, DEFAULT_VALUE)
                    LogManager.logError("Error occurred while  associates training by category\(message)")
                }
            } else {
                // TODO: add static string in localized string
                completionHandler(false, "couldn't parse the response", nil, DEFAULT_VALUE)
                LogManager.logError("Error occurred while assoicates training by category")
            }
        }) { error in
            Helper.hideLoader()
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription, nil, DEFAULT_VALUE)
        }
    }

    //MARK : - Training by Filter
    class func getTrainingByFilter(_ associateId: Int, _ categoryId: Int, subCategoryId: Int, pageNumber: Int, completionHandler: @escaping (_ success: Bool, _ message: String?, _ resultArray: [Training]?, _ pageCount: Int) -> Void) {

        var DEFAULT_VALUE: Int = 1

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, nil, nil, 0)
            return
        }

        // Set default header
        let headers = Helper.defaultServiceHeaders

        let urlString: String = NSString(format: Constants.APIServiceMethods.trainingByFilterAPI as NSString, "\(associateId)", "\(categoryId)", "\(subCategoryId)", "\(pageNumber)") as String

        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {

                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String

                if isSuccess {
                    var pageCount: Int = DEFAULT_VALUE
                    let resultDictionary = responseDictionary?[Constants.APIKEYS.DATA] as! NSDictionary
                    if let associteTrainingArray: NSArray = resultDictionary.value(forKey: Constants.APIKEYS.CONTENTLIST) as? NSArray {

                        // Create AssociateTrainee Array
                        var associteTraining: [Training]? = [Training]()
                        for tempAssociteTraining in associteTrainingArray {
                            let associateTrainingObj = Training(object: tempAssociteTraining)
                            associteTraining?.append(associateTrainingObj)
                        }

                        // Set total number of pages
                        if let resultCountVal: Int = resultDictionary[Constants.APIKEYS.NUMBER_OF_RESULTS] as? Int {
                            DEFAULT_VALUE = resultCountVal
                        }
                        if let pageCountValue: Int = resultDictionary[Constants.APIKEYS.TOTAL_PAGES] as? Int {
                            pageCount = pageCountValue
                        }
                        completionHandler(true, message, associteTraining, pageCount)
                    } else {
                        completionHandler(true, message, nil, pageCount)
                    }
                } else {
                    completionHandler(false, message, nil, DEFAULT_VALUE)
                    LogManager.logError("Error occurred while getting training by filter\(message)")
                }
            } else {
                // TODO: add static string in localized string
                completionHandler(false, "couldn't parse the response", nil, DEFAULT_VALUE)
                LogManager.logError("Error occurred while parsing data received for getting training bty filter")
            }
        }) { error in
            Helper.hideLoader()
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription, nil, DEFAULT_VALUE)
        }
    }

    // MARK: - Reset Associates Training
    // As a manager, I can reset Associates training
    class func resetTraineeTraining(_ traineeId: Int, _ trainingId: Int, completionHandler: @escaping (_ success: Bool, _ message: String?) -> Void) {

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, Helper.noInternetConnection().localizedFailureReason)
            return
        }

        let headers = Helper.defaultServiceHeaders
        let urlString: String = NSString(format: Constants.APIServiceMethods.resetTraineesTrainingAPI as NSString, "\(traineeId)", "\(trainingId)") as String
        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {
                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String
                if isSuccess {
                    completionHandler(true, message)
                } else {
                    completionHandler(false, message)
                    LogManager.logError("Error occurred while resetting trainee training \(message)")
                }
            } else {
                completionHandler(false, "couldn't parse the response")
                LogManager.logError("Error occurred while parsing for resetting trainee training")
            }
        }) { error in
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription)
        }
    }

    //MARK : - Associates Trainee Training
    class func getAssociatesTraineeTraining(_ traineeId: Int, pageNumber: Int, completionHandler: @escaping (_ success: Bool, _ message: String?, _ resultArray: [Training]?, _ pageCount: Int) -> Void) {

        var DEFAULT_VALUE: Int = 1

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, nil, nil, 0)
            return
        }

        // Set default header
        let headers = Helper.defaultServiceHeaders

        let urlString: String = NSString(format: Constants.APIServiceMethods.associateTrainingListByTrainerAPI as NSString, "\(traineeId)", "\(pageNumber)") as String

        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {

                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String

                if isSuccess {
                    var pageCount: Int = DEFAULT_VALUE
                    let resultDictionary = responseDictionary?[Constants.APIKEYS.DATA] as! NSDictionary
                    if let trainingArray: NSArray = resultDictionary.value(forKey: Constants.APIKEYS.CONTENTLIST) as? NSArray {

                        // Create Training Array
                        var trainingList: [Training]? = [Training]()
                        for tempTraining in trainingArray {
                            let trainingObj = Training(object: tempTraining)
                            trainingList?.append(trainingObj)
                        }

                        // Set total number of pages
                        if let resultCountVal: Int = resultDictionary[Constants.APIKEYS.NUMBER_OF_RESULTS] as? Int {
                            DEFAULT_VALUE = resultCountVal
                        }
                        if let pageCountValue: Int = resultDictionary[Constants.APIKEYS.TOTAL_PAGES] as? Int {
                            pageCount = pageCountValue
                        }
                        completionHandler(true, message, trainingList, pageCount)
                    } else {
                        completionHandler(true, message, nil, pageCount)
                    }
                } else {
                    completionHandler(false, message, nil, DEFAULT_VALUE)
                    LogManager.logError("Error occurred while getting associates trineee training \(message)")
                }
            } else {
                // TODO: add static string in localized string
                completionHandler(false, "couldn't parse the response", nil, DEFAULT_VALUE)
                LogManager.logError("Error occurred while parsing of data for getting ssociates traineee training")
            }
        }) { error in
            Helper.hideLoader()
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription, nil, DEFAULT_VALUE)
        }
    }

    //MARK : - New Filter for training
    class func getCategoryForTraining(_ userId: Int, pageNumber: Int, completionHandler: @escaping (_ success: Bool, _ message: String?, _ resultArray: [Category]?, _ pageCount: Int) -> Void) {

        var DEFAULT_VALUE: Int = 1

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, nil, nil, 0)
            return
        }

        // Set default header
        let headers = Helper.defaultServiceHeaders

        let urlString: String = NSString(format: Constants.APIServiceMethods.categoryForTrainingListAPI as NSString, "\(userId)", "\(pageNumber)") as String

        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {

                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String

                if isSuccess {
                    var pageCount: Int = DEFAULT_VALUE
                    let resultDictionary = responseDictionary?[Constants.APIKEYS.DATA] as! NSDictionary
                    if let categoryArray: NSArray = resultDictionary.value(forKey: Constants.APIKEYS.CONTENTLIST) as? NSArray {

                        // Create AssociateTrainee Array
                        var categoryList: [Category]? = [Category]()
                        for tempCategory in categoryArray {
                            let categoryObj = Category(object: tempCategory)
                            categoryList?.append(categoryObj)
                        }

                        // Set total number of pages
                        if let resultCountVal: Int = resultDictionary[Constants.APIKEYS.NUMBER_OF_RESULTS] as? Int {
                            DEFAULT_VALUE = resultCountVal
                        }
                        if let pageCountValue: Int = resultDictionary[Constants.APIKEYS.TOTAL_PAGES] as? Int {
                            pageCount = pageCountValue
                        }
                        completionHandler(true, message, categoryList, pageCount)
                    } else {
                        completionHandler(true, message, nil, pageCount)
                    }
                } else {
                    completionHandler(false, message, nil, DEFAULT_VALUE)
                    LogManager.logError("Error occurred while get category of training \(message)")
                }
            } else {
                // TODO: add static string in localized string
                completionHandler(false, "couldn't parse the response", nil, DEFAULT_VALUE)
                LogManager.logError("Error occurred while parsing of get category of training")
            }
        }) { error in
            Helper.hideLoader()
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription, nil, DEFAULT_VALUE)
        }
    }

    //MARK : - trainee training approve or reject
    class func traineeTrainingApproveReject(_ traineeId: Int, _ trainingId: Int, _ action: Bool, completionHandler: @escaping (_ success: Bool, _ message: String?) -> Void) {

        guard NetworkManager.isNetworkReachable() else {
            completionHandler(false, Helper.noInternetConnection().localizedFailureReason)
            return
        }

        let headers = Helper.defaultServiceHeaders

        let urlString: String = NSString(format: Constants.APIServiceMethods.approveAndRejectTrainingAPI as NSString, "\(traineeId)", "\(trainingId)", "\(action)") as String
        NetworkManager.requestGETURL(urlString, headers: headers, success: { responseJSON in
            let responseDictionary = responseJSON.dictionaryObject
            if responseDictionary != nil {
                let isSuccess = responseDictionary?[Constants.APIKEYS.SUCCESS] as! Bool
                let message = responseDictionary?[Constants.APIKEYS.MESSAGE] as! String
                if isSuccess {
                    completionHandler(true, message)
                } else {
                    completionHandler(false, message)
                    LogManager.logError("Error occurred while trainee training approve reject\(message)")
                }
            } else {
                completionHandler(false, "couldn't parse the response")
                LogManager.logError("Error occurred while parsing of trainee training approve reject")
            }
        }) { error in
            ErrorManager.handleError(error)
            completionHandler(false, error.localizedDescription)
        }
    }
}
