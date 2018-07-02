//
//  QuizInfo+CoreDataProperties.swift
//
//
//  Created by Narender Kumar on 14/04/17.
//
//

import Foundation
import CoreData

extension QuizInfo {

    //MARK : - fetch request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuizInfo> {
        return NSFetchRequest<QuizInfo>(entityName: "QuizInfo")
    }

    //MARK : - Variables
    @NSManaged public var completedUpto: Double
    @NSManaged public var noOfAttempts: Int32
    @NSManaged public var resultPercentage: Double
    @NSManaged public var totalQuestions: Int32
    @NSManaged public var questionsInfo: NSSet?
    @NSManaged public var trainingInfo: TrainingInfo?
}

// MARK: Generated accessors for questionsInfo
extension QuizInfo {

    @objc(addQuestionsInfoObject:)
    @NSManaged public func addToQuestionsInfo(_ value: QuestionInfo)

    @objc(removeQuestionsInfoObject:)
    @NSManaged public func removeFromQuestionsInfo(_ value: QuestionInfo)

    @objc(addQuestionsInfo:)
    @NSManaged public func addToQuestionsInfo(_ values: NSSet)

    @objc(removeQuestionsInfo:)
    @NSManaged public func removeFromQuestionsInfo(_ values: NSSet)
}
