//
//  QuestionInfo+CoreDataProperties.swift
//
//
//  Created by Narender Kumar on 14/04/17.
//
//

import Foundation
import CoreData

extension QuestionInfo {

    //MARK : - fetch request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionInfo> {
        return NSFetchRequest<QuestionInfo>(entityName: "QuestionInfo")
    }

    //MARK : - Variables
    @NSManaged public var id: Int32
    @NSManaged public var info: String?
    @NSManaged public var selectedAnswer: Int32
    @NSManaged public var answersInfo: NSSet?
    @NSManaged public var feedInfo: FeedInfo?
    @NSManaged public var quizInfo: QuizInfo?
}

// MARK: Generated accessors for answersInfo
extension QuestionInfo {

    @objc(addAnswersInfoObject:)
    @NSManaged public func addToAnswersInfo(_ value: AnswerInfo)

    @objc(removeAnswersInfoObject:)
    @NSManaged public func removeFromAnswersInfo(_ value: AnswerInfo)

    @objc(addAnswersInfo:)
    @NSManaged public func addToAnswersInfo(_ values: NSSet)

    @objc(removeAnswersInfo:)
    @NSManaged public func removeFromAnswersInfo(_ values: NSSet)
}
