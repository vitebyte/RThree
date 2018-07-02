//
//  ModelMapper.swift
//
//  Created by Pawan Joshi on 31/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

public final class ModelMapper<N: Model> {
    // Add Properties
}

extension ModelMapper {

    // MARK: Functions that create  objects from JSON

    /**
     Maps a JSON object to a Mappable object if it is a JSON dictionary or NSString, or returns nil.

     - parameter JSON: Dictionary

     - returns: Modal Object
     */

    public func map(_ JSON: AnyObject?) -> N? {
        if let JSON = JSON as? [String: AnyObject] {
            return map(JSON as AnyObject?)
        }
        return nil
    }

    /**
     Maps a JSON dictionary to an object that conforms to Mappable

     - parameter JSON: Dictionary

     - returns: Modal Object
     */
    public class func map(_ JSONDictionary: [String: AnyObject]) -> N? {
        if let object: N? = N() {
            object?.fillObjectFromDictionary(JSONDictionary)
            return object
        }
        return nil
    }

    /**
     Maps a JSON object to an array of Mappable objects if it is an array of JSON dictionary, or returns nil.

     - parameter JSON: Dictionary

     - returns: Modal Object
     */
    public class func mapArray(_ JSON: AnyObject?) -> [N]? {
        if let JSONArray = JSON as? [[String: AnyObject]] {
            return mapArray(JSONArray)
        }

        return nil
    }

    /**
     Maps an array of JSON dictionary to an array of Mappable objects

     - parameter JSON: Array

     - returns: Array of Modal Objects
     */
    public class func mapArray(_ JSONArray: [[String: AnyObject]]) -> [N]? {
        // map every element in JSON array to type N
        let result = JSONArray.flatMap { (dict) -> N? in
            let tempUser = ModelMapper<N>.map(dict)
            return tempUser
        }
        return result
    }
}

extension ModelMapper {

    // MARK: Functions that create JSON from objects

    /**
     Maps an object that conforms to Mappable to a JSON dictionary <String : AnyObject>

     - parameter Object: Modal Object

     - returns: Json of Modal Object
     */
    public class func toJSON(_ object: N) -> [String: AnyObject] {
        return object.toDictionary() as! [String: AnyObject]
    }

    /**
     Maps an array of Objects to an array of JSON dictionaries [[String : AnyObject]]

     - parameter Array: Modal Objects

     - returns: Json Array of Modal Objects
     */
    public class func toJSONArray(_ array: [N]) -> [[String: AnyObject]] {
        return array.map {
            // convert every element in array to JSON dictionary equivalent
            self.toJSON($0)
        }
    }
}

/**
 *  Protocol for nested models.
 */
public protocol NestedModels {
    /**
     Define Keys of nested models.

     - returns: return [String]
     */
    func modelKeys() -> [String]?

    /**
     Used when Json to Object

     - parameter key: nested modal key
     - parameter val: Array or dictionary for nested modal
     */
    func mappingKey(_ key: String, AndValue val: AnyObject)

    /**
     Used when Json to Object

     - parameter key: nested modal key
     - parameter val: nested modal objet or array

     - returns: Json array
     */
    func mappingKey(_ key: String, AndObject val: AnyObject) -> NSArray?

    /**
     Map different keys for Model properties

     - returns: Mapped keys dictionary
     */
    func mappingKeysforProperties() -> [String: String]?
}

open class Model: NSObject, NestedModels {

    var mappingKeyDictionary: [String: String]?

    public required override init() {
        super.init()
        mappingKeyDictionary = mappingKeysforProperties()
    }

    open func mappingKeysforProperties() -> [String: String]? {
        return nil
    }

    /**
     Keys to modal properties

     - returns: all keys for modals
     */
    open func modelKeys() -> [String]? {
        return nil
    }

    /**
     Map dict keys if model has another modal

     - parameter key: key
     - parameter val: modal Dict
     */
    open func mappingKey(_: String, AndValue _: AnyObject) {
        // override in derived class
    }

    /**
     Map Model with dict key with array if model has another modal array

     - parameter key: key
     - parameter val: modal object

     - returns: array of modal dictionaries
     */
    open func mappingKey(_: String, AndObject _: AnyObject) -> NSArray? {
        return nil
    }

    /**
     Fetch all properties from class and put into a dictionary

     - parameter aClass:               class type
     - parameter propertiesDictionary: properties dictionary
     */
    func setPropertiesFromClass(_ aClass: AnyClass?, InDictionary propertiesDictionary: inout [String: AnyObject]) {

        var pCount: CUnsignedInt = 0
        let pInAClass: UnsafeMutablePointer<objc_property_t?> = class_copyPropertyList(aClass, &pCount)

        for i in 0 ..< Int(pCount) {

            let keyName: NSString? = NSString(cString: property_getName(pInAClass[i]), encoding: String.Encoding.utf8.rawValue)
            if let _ = keyName {
                let key = keyName as! String
                let value = self.value(forKey: key)
                if let temp = value, value is Model {
                    propertiesDictionary[key] = (temp as AnyObject).toDictionary()
                } else if let temp = value, value is [Model] {
                    let tempValue = mappingKey(key, AndObject: temp as AnyObject)
                    propertiesDictionary[key] = tempValue
                } else {
                    propertiesDictionary[key] = value as AnyObject?
                }
            }
        }
    }

    /**
     Get dictionary from modal object

     - returns: modal dictionary
     */
    func toDictionary() -> NSDictionary {

        let aClass: AnyClass? = type(of: self)
        var propertiesDictionary: [String: AnyObject] = Dictionary()
        var tempClass: AnyClass? = aClass

        while true {

            if (tempClass == Model.self) || (tempClass == nil) {
                break
            }
            setPropertiesFromClass(tempClass, InDictionary: &propertiesDictionary)
            tempClass = tempClass?.superclass()
        }
        return propertiesDictionary as NSDictionary
    }

    /**
     Fetch values from dictionary and store into class variables

     - parameter dict:   dictionary
     - parameter aClass: class type
     */
    func setValuesFromDictionary(_ dict: [String: AnyObject], InClass aClass: AnyClass) {

        var pCount: CUnsignedInt = 0
        let pInAClass: UnsafeMutablePointer<objc_property_t?> = class_copyPropertyList(aClass, &pCount)
        for i in 0 ..< Int(pCount) {

            let propertyName: NSString? = NSString(cString: property_getName(pInAClass[i]), encoding: String.Encoding.utf8.rawValue)
            let propertyType = property_copyAttributeValue(pInAClass[i], "T")
            let propertyTypeStr = String(cString: propertyType!, encoding: String.Encoding.utf8)
            if let _ = propertyName {
                let key = propertyName as! String
                let mappingKey = mappingKeyDictionary?[key]
                let value = mappingKey != nil ? dict[mappingKey!] : dict[key]

                if let temp = value, value is NSDictionary || value is NSArray {
                    if modelKeys()?.contains(key) != nil {
                        self.mappingKey(key, AndValue: temp)
                    } else {
                        setValue(value, forKey: key)
                    }
                } else {
                    if let _ = value, value is NSNull == false {

                        if (propertyTypeStr?.contains("String"))! && value is NSNumber {
                            setValue(value!.description, forKey: key)
                        } else {
                            setValue(value, forKey: key)
                        }
                    }
                }
            }
        }
    }

    /**
     Make object from dictionary

     - parameter dict: dictionary for object data

     - returns: Modal Object
     */
    func fillObjectFromDictionary(_ dict: [String: AnyObject]) -> Model {

        let aClass: AnyClass? = type(of: self)
        var tempClass: AnyClass? = aClass

        while true {

            if (tempClass == Model.self) || (tempClass == nil) {
                break
            }
            setValuesFromDictionary(dict, InClass: tempClass!)
            tempClass = tempClass?.superclass()
        }
        return self
    }
}
