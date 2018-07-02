//
//  FeedInfo+CoreDataProperties.swift
//
//
//  Created by Narender Kumar on 14/04/17.
//
//

import Foundation
import CoreData

extension FeedInfo {

    //MARK: - variables
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedInfo> {
        return NSFetchRequest<FeedInfo>(entityName: "FeedInfo")
    }

    @NSManaged public var dateTime: Date?
    @NSManaged public var desc: String?
    @NSManaged public var id: Int32
    @NSManaged public var imageUrl: String?
    @NSManaged public var videoUrl: String?
    @NSManaged public var isMarkedRead: Bool
    @NSManaged public var questionFlag: Bool
    @NSManaged public var sender: String?
    @NSManaged public var title: String?
    @NSManaged public var userId: Int32
    @NSManaged public var interval: Int32
    @NSManaged public var questionsInfo: NSSet?
}

// MARK: Generated accessors for questionsInfo
extension FeedInfo {

    @objc(addQuestionsInfoObject:)
    @NSManaged public func addToQuestionsInfo(_ value: QuestionInfo)

    @objc(removeQuestionsInfoObject:)
    @NSManaged public func removeFromQuestionsInfo(_ value: QuestionInfo)

    @objc(addQuestionsInfo:)
    @NSManaged public func addToQuestionsInfo(_ values: NSSet)

    @objc(removeQuestionsInfo:)
    @NSManaged public func removeFromQuestionsInfo(_ values: NSSet)
}
