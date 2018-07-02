//
//  Trainee.swift
//
//  Created by Narender Kumar on 08/05/17
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Trainee: NSObject, NSCoding {

    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let trainingDate = "trainingDate"
        static let trainingStatus = "trainingStatus"
        static let trainingId = "trainingId"
        static let trainingTitle = "trainingTitle"
        static let traineeName = "traineeName"
        static let imageUrl = "imageUrl"
        static let traineeId = "traineeId"
    }

    // MARK: Properties
    public var trainingDate: String?
    public var trainingStatus: Int?
    public var trainingId: Int?
    public var trainingTitle: String?
    public var traineeName: String?
    public var imageUrl: String?
    public var traineeId: Int?

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
        trainingDate = json[SerializationKeys.trainingDate].string
        trainingStatus = json[SerializationKeys.trainingStatus].int
        trainingId = json[SerializationKeys.trainingId].int
        trainingTitle = json[SerializationKeys.trainingTitle].string
        traineeName = json[SerializationKeys.traineeName].string
        imageUrl = json[SerializationKeys.imageUrl].string
        traineeId = json[SerializationKeys.traineeId].int
    }

    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = trainingDate { dictionary[SerializationKeys.trainingDate] = value }
        if let value = trainingStatus { dictionary[SerializationKeys.trainingStatus] = value }
        if let value = trainingId { dictionary[SerializationKeys.trainingId] = value }
        if let value = trainingTitle { dictionary[SerializationKeys.trainingTitle] = value }
        if let value = traineeName { dictionary[SerializationKeys.traineeName] = value }
        if let value = imageUrl { dictionary[SerializationKeys.imageUrl] = value }
        if let value = traineeId { dictionary[SerializationKeys.traineeId] = value }
        return dictionary
    }

    // MARK: NSCoding Protocol
    public required init(coder aDecoder: NSCoder) {
        trainingDate = aDecoder.decodeObject(forKey: SerializationKeys.trainingDate) as? String
        trainingStatus = aDecoder.decodeObject(forKey: SerializationKeys.trainingStatus) as? Int
        trainingId = aDecoder.decodeObject(forKey: SerializationKeys.trainingId) as? Int
        trainingTitle = aDecoder.decodeObject(forKey: SerializationKeys.trainingTitle) as? String
        traineeName = aDecoder.decodeObject(forKey: SerializationKeys.traineeName) as? String
        imageUrl = aDecoder.decodeObject(forKey: SerializationKeys.imageUrl) as? String
        traineeId = aDecoder.decodeObject(forKey: SerializationKeys.traineeId) as? Int
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(trainingDate, forKey: SerializationKeys.trainingDate)
        aCoder.encode(trainingStatus, forKey: SerializationKeys.trainingStatus)
        aCoder.encode(trainingId, forKey: SerializationKeys.trainingId)
        aCoder.encode(trainingTitle, forKey: SerializationKeys.trainingTitle)
        aCoder.encode(traineeName, forKey: SerializationKeys.traineeName)
        aCoder.encode(imageUrl, forKey: SerializationKeys.imageUrl)
        aCoder.encode(traineeId, forKey: SerializationKeys.traineeId)
    }
}
