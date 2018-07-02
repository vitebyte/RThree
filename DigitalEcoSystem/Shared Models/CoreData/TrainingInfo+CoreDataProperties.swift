//
//  TrainingInfo+CoreDataProperties.swift
//
//
//  Created by Shafi Ahmed on 20/04/17.
//
//

import Foundation
import CoreData

extension TrainingInfo {

    //MARK : - fetch request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingInfo> {
        return NSFetchRequest<TrainingInfo>(entityName: "TrainingInfo")
    }

    //MARK : - variables
    @NSManaged public var category: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: Int32
    @NSManaged public var imageUrl: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var percentCompleted: Double
    @NSManaged public var playbackInterval: Double
    @NSManaged public var remainingAttempts: Int16
    @NSManaged public var status: Int16
    @NSManaged public var subcategory: String?
    @NSManaged public var title: String?
    @NSManaged public var userId: Int32
    @NSManaged public var videoUrl: String?
    @NSManaged public var quizInfo: QuizInfo?
}

//MARK : - methods
extension TrainingInfo {

    @objc(addQuizsInfoObject:)
    @NSManaged public func addToQuizsInfo(_ value: QuizInfo)

    @objc(removeQuizsInfoObject:)
    @NSManaged public func removeFromQuizInfo(_ value: QuizInfo)
}
