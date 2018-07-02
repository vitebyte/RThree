//
//  User.swift
//
//  Created by Narender Kumar on 18/04/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK : - Enum for user role
enum UserRole: NSNumber {
    case Invalid = 0
    case Default = 1
    case Admin = 2
    case RegionalManager = 3
    case EcoSystemManager = 4
    case Director = 5
    case Associate = 6
    case StoreManager = 7
}

public class User: NSObject, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let langCode = "langCode"
        static let language = "language"
        static let roleId = "roleId"
        static let userId = "userId"
        static let userName = "userName"
        static let profileImg = "profileImg"
        static let sessionId = "sessionId"
        static let userEmailId = "userEmailId"
    }

    // MARK: Properties
    public var langCode: Int?
    public var language: [Language]?
    public var roleId: Int?
    public var userId: Int?
    public var userName: String?
    public var profileImg: String?
    public var sessionId: String?
    public var userEmailId: String?

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
        langCode = json[SerializationKeys.langCode].int
        if let items = json[SerializationKeys.language].array { language = items.map { Language(json: $0) } }
        roleId = json[SerializationKeys.roleId].int
        userId = json[SerializationKeys.userId].int
        userName = json[SerializationKeys.userName].string
        profileImg = json[SerializationKeys.profileImg].string
        sessionId = json[SerializationKeys.sessionId].string
        userEmailId = json[SerializationKeys.userEmailId].string
    }

    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = langCode { dictionary[SerializationKeys.langCode] = value }
        if let value = language { dictionary[SerializationKeys.language] = value.map { $0.dictionaryRepresentation() } }
        if let value = roleId { dictionary[SerializationKeys.roleId] = value }
        if let value = userId { dictionary[SerializationKeys.userId] = value }
        if let value = userName { dictionary[SerializationKeys.userName] = value }
        if let value = profileImg { dictionary[SerializationKeys.profileImg] = value }
        if let value = sessionId { dictionary[SerializationKeys.sessionId] = value }
        if let value = userEmailId { dictionary[SerializationKeys.userEmailId] = value }
        return dictionary
    }

    // MARK: NSCoding Protocol
    public required init(coder aDecoder: NSCoder) {
        langCode = aDecoder.decodeObject(forKey: SerializationKeys.langCode) as? Int
        language = aDecoder.decodeObject(forKey: SerializationKeys.language) as? [Language]
        roleId = aDecoder.decodeObject(forKey: SerializationKeys.roleId) as? Int
        userId = aDecoder.decodeObject(forKey: SerializationKeys.userId) as? Int
        userName = aDecoder.decodeObject(forKey: SerializationKeys.userName) as? String
        profileImg = aDecoder.decodeObject(forKey: SerializationKeys.profileImg) as? String
        sessionId = aDecoder.decodeObject(forKey: SerializationKeys.sessionId) as? String
        userEmailId = aDecoder.decodeObject(forKey: SerializationKeys.userEmailId) as? String
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(langCode, forKey: SerializationKeys.langCode)
        aCoder.encode(language, forKey: SerializationKeys.language)
        aCoder.encode(roleId, forKey: SerializationKeys.roleId)
        aCoder.encode(userId, forKey: SerializationKeys.userId)
        aCoder.encode(userName, forKey: SerializationKeys.userName)
        aCoder.encode(profileImg, forKey: SerializationKeys.profileImg)
        aCoder.encode(sessionId, forKey: SerializationKeys.sessionId)
        aCoder.encode(userEmailId, forKey: SerializationKeys.userEmailId)
    }
}
