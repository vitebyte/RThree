//
//  QuizInfo+CoreDataClass.swift
//
//
//  Created by Narender Kumar on 14/04/17.
//
//

import Foundation
import CoreData

public class QuizInfo: NSManagedObject {

    //MARK : - convert quiz to info
    func convertQuizToInfo(quiz: Quiz) {
        noOfAttempts = (quiz.noOfAttempts?.int32Value)!
    }
}
