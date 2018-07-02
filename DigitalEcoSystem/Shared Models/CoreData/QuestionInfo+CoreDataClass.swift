//
//  QuestionInfo+CoreDataClass.swift
//
//
//  Created by Narender Kumar on 14/04/17.
//
//

import Foundation
import CoreData

public class QuestionInfo: NSManagedObject {

    //MARK : - convert question to info
    func convertQuestionToInfo(question: Question) {
        id = Int32(question.questionId!)
        info = question.question
    }

    //MARK : - update
    func updateQuestionInfo(question: Question) {
        convertQuestionToInfo(question: question)
    }
}
