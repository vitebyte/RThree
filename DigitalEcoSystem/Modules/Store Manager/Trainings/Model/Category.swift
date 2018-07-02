//
//  Category.swift
//
//  Created by Narender Kumar on 08/05/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Category: NSObject, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let catId = "catId"
        static let catName = "catName"
        static let subCatList = "subCatList"
    }

    // MARK: Properties
    public var catId: Int?
    public var catName: String?
    public var subCatList: [SubCatList]?

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
        catName = json[SerializationKeys.catName].string
        if let items = json[SerializationKeys.subCatList].array { subCatList = items.map { SubCatList(json: $0) } }
    }

    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = catId { dictionary[SerializationKeys.catId] = value }
        if let value = catName { dictionary[SerializationKeys.catName] = value }
        if let value = subCatList { dictionary[SerializationKeys.subCatList] = value.map { $0.dictionaryRepresentation() } }
        return dictionary
    }

    // MARK: NSCoding Protocol
    public required init(coder aDecoder: NSCoder) {
        catId = aDecoder.decodeObject(forKey: SerializationKeys.catId) as? Int
        catName = aDecoder.decodeObject(forKey: SerializationKeys.catName) as? String
        subCatList = aDecoder.decodeObject(forKey: SerializationKeys.subCatList) as? [SubCatList]
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(catId, forKey: SerializationKeys.catId)
        aCoder.encode(catName, forKey: SerializationKeys.catName)
        aCoder.encode(subCatList, forKey: SerializationKeys.subCatList)
    }
}
