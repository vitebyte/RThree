//
//  NetworkManager.swift
//  DigitalEcoSystem
//
//  Created by Shafi Ahmed on 06/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkManager: NSObject {

    // MARK: - REACHABILITY
    class func isNetworkReachable() -> Bool {
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        return manager?.isReachable ?? false
    }

    // MARK: - GET
    /// GET Request
    ///
    /// - parameter strURL:  URL for the request
    /// - parameter headers: Headers information required for the api call
    /// - parameter success: Completion block for success with response json info
    /// - parameter failure: Completion block for failure with error info
    class func requestGETURL(_ strURL: String, headers: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (NSError) -> Void) {
        Alamofire.request(strURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error: Error = responseObject.result.error!
                failure(error as NSError)
            }
        }
    }

    // MARK: - POST
    /// POST request
    ///
    /// - parameter strURL:  URL for the request
    /// - parameter params:  Parameters required for the api
    /// - parameter headers: Headers information required for the api call
    /// - parameter success: Completion block for success with response json info
    /// - parameter failure: Completion block for failure with error info
    class func requestPOSTURL(_ strURL: String, params: [String: AnyObject]?, headers: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (NSError) -> Void) {
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error: Error = responseObject.result.error!
                failure(error as NSError)
            }
        }
    }

    // MARK: - PUT
    /// PUT request
    ///
    /// - parameter strURL:  URL for the request
    /// - parameter params:  Parameters required for the api
    /// - parameter headers: Headers information required for the api call
    /// - parameter success: Completion block for success with response json info
    /// - parameter failure: Completion block for failure with error info
    class func requestPUTURL(_ strURL: String, params: [String: AnyObject]?, headers: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (NSError) -> Void) {
        Alamofire.request(strURL, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error: Error = responseObject.result.error!
                failure(error as NSError)
            }
        }
    }

    // MARK: - DELETE
    /// DELETE request
    ///
    /// - parameter strURL:  URL for the request
    /// - parameter params:  Parameters required for the api
    /// - parameter headers: Headers information required for the api call
    /// - parameter success: Completion block for success with response json info
    /// - parameter failure: Completion block for failure with error info
    class func requestDELETEURL(_ strURL: String, params: [String: AnyObject]?, headers: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (NSError) -> Void) {
        Alamofire.request(strURL, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error: Error = responseObject.result.error!
                failure(error as NSError)
            }
        }
    }

    // MARK: - MULTIPART
    /// Multipart request to upload image
    ///
    /// - parameter strURL:  URL for the request
    /// - parameter params:  Parameters required for the api
    /// - parameter headers: Headers information required for the api call
    /// - parameter success: Completion block for success with response json info
    /// - parameter failure: Completion block for failure with error info
    class func uploadImageWithMultipartFormData(_ strURL: String, params: [String: AnyObject]?, headers: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (NSError) -> Void) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in params! {
                if value is Data {
                    // multipartFormData.append(value as! Data, withName: key)
                    multipartFormData.append(value as! Data, withName: key, fileName: "user.jpg", mimeType: "image/jpg")
                } else {
                    let valueSTR = value as! String
                    multipartFormData.append(valueSTR.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: strURL, headers: headers) { encodingResult in

            switch encodingResult {
            case let .success(upload, _, _):
                upload.responseJSON { (responseObject) -> Void in
                    if responseObject.result.isSuccess {
                        let resJson = JSON(responseObject.result.value!)
                        success(resJson)
                    }
                    if responseObject.result.isFailure {
                        let error: Error = responseObject.result.error!
                        failure(error as NSError)
                    }
                }
            case let .failure(encodingError):
                failure(encodingError as NSError)
            }
        }
    }
}
