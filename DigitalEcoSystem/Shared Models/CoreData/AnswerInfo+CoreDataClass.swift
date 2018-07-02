//
//  AnswerInfo+CoreDataClass.swift
//
//
//  Created by Narender Kumar on 14/04/17.
//
//

import Foundation
import CoreData

public class AnswerInfo: NSManagedObject {

    //MARK : - Convert answer to info
    func convertAnswerToInfo(answer: Options) {
        info = answer.answer
        id = Int32(answer.answerId!)
        isCorrect = answer.answerFlag!
    }

    //MARK : - update
    func updateAnswerInfo(answer: Options) {
        convertAnswerToInfo(answer: answer)
    }
}
