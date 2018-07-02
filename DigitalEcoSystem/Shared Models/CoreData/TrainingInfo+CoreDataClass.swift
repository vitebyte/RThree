//
//  TrainingInfo+CoreDataClass.swift
//
//
//  Created by Shafi Ahmed on 20/04/17.
//
//

import Foundation
import CoreData

public class TrainingInfo: NSManagedObject {

    //MARK : - create
    func createTrainingInfo(training: Training) {
        /*
         let trainingInfo = transaction.create(Into<TrainingInfo>())
         trainingInfo.category = "Wines"
         trainingInfo.playbackInterval = 60
         trainingInfo.desc = "A old aged wine"
         trainingInfo.id = 123
         trainingInfo.imageUrl = "image url goes here"
         trainingInfo.isCompleted = false
         trainingInfo.subcategory = "No Name"
         trainingInfo.title = "Learn about wines"
         trainingInfo.userId = 3
         trainingInfo.videoUrl = "Video url goes here"
         trainingInfo.percentCompleted = Double(18.0)
         trainingInfo.status = 1
         trainingInfo.remainingAttempts = 2
         */
        convertTrainingToInfo(training: training)
    }

    //MARK : - update
    func updateTrainingInfo(training: Training) {
        convertTrainingToInfo(training: training)
    }

    //MARK : - convert training to info 
    fileprivate func convertTrainingToInfo(training: Training) {
        id = Int32(training.trainingId!)
        userId = Int32(UserManager.shared.activeUser.userId!)
        title = training.trainingTitle
        desc = training.trainingContent
        imageUrl = training.imageUrl
        videoUrl = training.videoUrl
        category = training.categoryName
        subcategory = training.categoryName

        remainingAttempts = Int16(training.attemptLeft!)

        // only update below attributes only if we don't have any existing value locally.
        if percentCompleted == 0 {
            percentCompleted = Double(training.completedPer!)
            status = Int16(training.status!)
            // remainingAttempts = Int16(training.attemptLeft!)
            playbackInterval = training.playbackInterval
            isCompleted = training.completedFlag!
        } else {
            training.completedPer = Int(percentCompleted)
            training.status = Int(status)
            //training.attemptLeft = Int(remainingAttempts)
            training.playbackInterval = playbackInterval
            training.completedFlag = isCompleted
        }
        quizInfo?.resultPercentage = Double(training.quizResult!)
    }
}
