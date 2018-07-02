//
//  AnswerInfo+CoreDataProperties.swift
//
//
//  Created by Narender Kumar on 14/04/17.
//
//

import Foundation
import CoreData

extension AnswerInfo {

    //MARK : - fetch request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnswerInfo> {
        return NSFetchRequest<AnswerInfo>(entityName: "AnswerInfo")
    }

    //MARK : - Variables
    @NSManaged public var id: Int32
    @NSManaged public var info: String?
    @NSManaged public var isCorrect: Bool
    @NSManaged public var questionInfo: QuestionInfo?
}
