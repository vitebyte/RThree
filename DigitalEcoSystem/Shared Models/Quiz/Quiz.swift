//
//  Quiz.swift
//  DigitalEcoSystem
//
//  Created by Narender Kumar on 15/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import Foundation

class Quiz: Model, NSCoding {

    //MARK : - Variables
    var completedUpto: NSNumber?
    var noOfAttempts: NSNumber?
    var resultPercentage: NSNumber?
    var totalQuestions: NSNumber?
    var questions: [Question]?
    var training: Training?

    //MARK : - initializer
    required init() {
        super.init()
    }

    // MARK: - NSCoding protocol methods
    required init?(coder aDecoder: NSCoder) {
        super.init()

        completedUpto = (aDecoder.decodeObject(forKey: "completedUpto") as? NSNumber)
        noOfAttempts = (aDecoder.decodeObject(forKey: "noOfAttempts") as? NSNumber)
        resultPercentage = (aDecoder.decodeObject(forKey: "resultPercentage") as? NSNumber)
        totalQuestions = (aDecoder.decodeObject(forKey: "totalQuestions") as? NSNumber)
        questions = (aDecoder.decodeObject(forKey: "questions") as? [Question])
        training = (aDecoder.decodeObject(forKey: "training") as? Training)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(completedUpto, forKey: "completedUpto")
        aCoder.encode(noOfAttempts, forKey: "noOfAttempts")
        aCoder.encode(resultPercentage, forKey: "resultPercentage")
        aCoder.encode(totalQuestions, forKey: "totalQuestions")
        aCoder.encode(questions, forKey: "questions")
        aCoder.encode(training, forKey: "training")
    }
}
