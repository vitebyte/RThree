//
//  SubCatList.swift
//
//  Created by Narender Kumar on 08/05/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class SubCatList: NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let catId = "catId"
        static let created = "created"
        static let subCatId = "subCatId"
        static let completed = "completed"
        static let subCatName = "subCatName"
    }

    // MARK: Properties
    public var catId: Int?
    public var created: Bool? = false
    public var subCatId: Int?
    public var completed: Bool? = false
    public var subCatName: String?

    // MARK: SwiftyJSON Initializers
    /// Initiates the instance based on the object.
    ///
    /// - parameter object: The object of either Dictionary or Array kind that was passed.
    /// - returns: An initialized instance of the class.
    public convenience init(object: Any) {
        self.init(json: JSON(object))
    }

    /// Initiates the instance based on the JSON that was passed.
    ///
    /// - parameter json: JSON object from SwiftyJSON.
    public required init(json: JSON) {
        catId = json[SerializationKeys.catId].int
        created = json[SerializationKeys.created].boolValue
        subCatId = json[SerializationKeys.subCatId].int
        completed = json[SerializationKeys.completed].boolValue
        subCatName = json[SerializationKeys.subCatName].string
    }

    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = catId { dictionary[SerializationKeys.catId] = value }
        dictionary[SerializationKeys.created] = created
        if let value = subCatId { dictionary[SerializationKeys.subCatId] = value }
        dictionary[SerializationKeys.completed] = completed
        if let value = subCatName { dictionary[SerializationKeys.subCatName] = value }
        return dictionary
    }

    // MARK: NSCoding Protocol
    public required init(coder aDecoder: NSCoder) {
        catId = aDecoder.decodeObject(forKey: SerializationKeys.catId) as? Int
        created = aDecoder.decodeBool(forKey: SerializationKeys.created)
        subCatId = aDecoder.decodeObject(forKey: SerializationKeys.subCatId) as? Int
        completed = aDecoder.decodeBool(forKey: SerializationKeys.completed)
        subCatName = aDecoder.decodeObject(forKey: SerializationKeys.subCatName) as? String
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(catId, forKey: SerializationKeys.catId)
        aCoder.encode(created, forKey: SerializationKeys.created)
        aCoder.encode(subCatId, forKey: SerializationKeys.subCatId)
        aCoder.encode(completed, forKey: SerializationKeys.completed)
        aCoder.encode(subCatName, forKey: SerializationKeys.subCatName)
    }
}
