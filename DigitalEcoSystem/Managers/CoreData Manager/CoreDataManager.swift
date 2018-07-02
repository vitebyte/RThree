//
//  CoreDataManager.swift
//  DigitalEcoSystem
//
//  Created by Narender Kumar on 14/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import Foundation
import CoreData
import CoreStore

class CoreDataManager: NSObject {

    // MARK: - Setup
    class func initializeCachingEngine() {
        do {
            try CoreStore.addStorageAndWait()
        } catch {
        }
    }

    // MARK: - Trainings
    class func cacheTrainings(availableTrainings: [Training], completionHandler: @escaping (_ success: Bool) -> Void) {
        for training in availableTrainings {
            CoreStore.beginAsynchronous { (transaction) -> Void in
                print("cacheTrainings start")
                if let trainInfo = transaction.fetchOne(
                    From<TrainingInfo>(),
                    Where("id", isEqualTo: training.trainingId)) {

                    // update existing training
                    trainInfo.updateTrainingInfo(training: training)

                    // save changes
                    _ = transaction.commit()
                } else {
                    let trainingInfo = transaction.create(Into<TrainingInfo>())
                    trainingInfo.createTrainingInfo(training: training)

                    // assign an empty quiz
                    trainingInfo.quizInfo = transaction.create(Into<QuizInfo>())

                    // save changes
                    _ = transaction.commit()
                }
            }
            
            if training == availableTrainings.last {
                
                completionHandler(true)
            }
        }
    }

    //MARK: - load trainings
    class func loadTrainings() -> [Training] {
        var trainings = [Training]()

        if let allTrainings = CoreStore.fetchAll(
            From<TrainingInfo>(),
            Where("userId", isEqualTo: UserManager.shared.activeUser.userId)) {
            for training: TrainingInfo in allTrainings {
                trainings.append(Training(info: training))
            }
        }
        return trainings
    }

    //MARK: - update trainings
    class func updateTraining(_ training: Training, withProgress progress: Double, playback interval: Double) {
        CoreStore.beginAsynchronous { (transaction) -> Void in
            if let trainingInfo = transaction.fetchOne(
                From<TrainingInfo>(),
                Where("id", isEqualTo: training.trainingId)) {
                trainingInfo.playbackInterval = interval

                // check for overall training completion
                if training.status == TrainingStatus.Completed.hashValue {
                    // do nothing
                    print("training is already completed")
                } else if training.completedPer == Constants.TrainingWeightage.VideoPercent.hashValue {
                    // do nothing
                    print("video is already completed")
                } else {
                    trainingInfo.percentCompleted = progress
                }

                transaction.commit()
            }
        }
    }

    // Update training status
    // 0-New,1-In progress, 2- Completed, 3-Expired
    class func updateTrainingStatus(_ training: Training, to status: Int) {
        CoreStore.beginAsynchronous { (transaction) -> Void in
            if let trainingInfo = transaction.fetchOne(
                From<TrainingInfo>(),
                Where("id", isEqualTo: training.trainingId)) {
                trainingInfo.status = Int16(status)
                transaction.commit()
            }
        }
    }

    // MARK: - Quiz : Questions & Answers
    class func loadQuiz(forTraining trainingId: Int) -> [Question] {
        var questions = [Question]()

        if let training = CoreStore.fetchOne(
            From<TrainingInfo>(),
            Where("id", isEqualTo: Int32(trainingId))) {

            let quiz = training.quizInfo
            if let questionsInfo: [QuestionInfo] = quiz?.questionsInfo?.allObjects as! [QuestionInfo]? {
                for info: QuestionInfo in questionsInfo {
                    questions.append(Question(quesinfo: info))
                }
            }
        }
        return questions
    }

    // MARK: - Get QuestionsInfo for result
    class func loadQuestionInfo(forTraining trainingId: Int) -> [QuestionInfo] {
        var questionsInfo = [QuestionInfo]()

        if let training = CoreStore.fetchOne(
            From<TrainingInfo>(),
            Where("id", isEqualTo: Int32(trainingId))) {
            let quiz = training.quizInfo
            questionsInfo = quiz?.questionsInfo?.allObjects as! [QuestionInfo]
        }
        return questionsInfo
    }

    //MARK: - cache quiz
    class func cacheQuiz(questions: [Question], for training: Training) {
        /* for quiz in availableQuiz {} */
        CoreStore.beginAsynchronous { (transaction) -> Void in

            // TrainingInfo
            if let trainingInfo = transaction.fetchOne(
                From<TrainingInfo>(),
                Where("id", isEqualTo: training.trainingId)) {

                // QuizInfo
                let quizInfo: QuizInfo! = trainingInfo.quizInfo
                // quizInfo.completedUpto = Double(0.0)
                // quizInfo.noOfAttempts = Int32(training.attemptLeft!)
                quizInfo.resultPercentage = Double(training.quizResult!)
                quizInfo.totalQuestions = Int32(questions.count)

                // [Questions]
                for question in questions {

                    if let questionInfo = transaction.fetchOne(
                        From<QuestionInfo>(),
                        Where("id", isEqualTo: question.questionId)) {

                        // update question
                        questionInfo.updateQuestionInfo(question: question)

                        // update [Answers]
                        if let answers = question.options {
                            for answer: Options in answers {

                                if let answerInfo = transaction.fetchOne(
                                    From<AnswerInfo>(),
                                    Where("id", isEqualTo: answer.answerId)) {

                                    // update existing answer
                                    answerInfo.updateAnswerInfo(answer: answer)
                                } else {
                                    let answerInfo = transaction.create(Into<AnswerInfo>())
                                    answerInfo.convertAnswerToInfo(answer: answer)

                                    questionInfo.addToAnswersInfo(answerInfo) // assign answers to questionInfo relationship
                                }
                            }
                        }

                    } else {

                        // create question
                        let questionInfo = transaction.create(Into<QuestionInfo>())
                        questionInfo.convertQuestionToInfo(question: question)

                        // create [Answers]
                        if let answers = question.options {
                            for answer in answers {
                                let answerInfo = transaction.create(Into<AnswerInfo>())
                                answerInfo.convertAnswerToInfo(answer: answer)

                                questionInfo.addToAnswersInfo(answerInfo) // assign answers to questionInfo relationship
                            }
                        }
                        // assign question to quiz relationship
                        quizInfo.addToQuestionsInfo(questionInfo)
                    }
                }

                transaction.commit()
            }
        }
    }

    //MARK: - save answer
    class func saveAnswer(_ answerId: Int, for question: Question) {
        CoreStore.beginAsynchronous { (transaction) -> Void in
            if let questionInfo = transaction.fetchOne(
                From<QuestionInfo>(),
                Where("id", isEqualTo: question.questionId)) {

                questionInfo.selectedAnswer = Int32(answerId)

                let quizInfo: QuizInfo? = questionInfo.quizInfo
                if let upto: Double = quizInfo?.completedUpto {
                    if (quizInfo?.completedUpto)! < Double((quizInfo?.totalQuestions)!) {
                        quizInfo?.completedUpto = upto + 1
                    }
                }

                // training progress
                let training: TrainingInfo! = quizInfo?.trainingInfo
                let trainingProgress = Double(Constants.TrainingWeightage.VideoPercent)
                let quizProgress = (Double(Double((quizInfo?.completedUpto)!) / Double((quizInfo?.totalQuestions)!)) * Double(Constants.TrainingWeightage.QuizPercent))
                let overallProgress = trainingProgress + quizProgress

                training.percentCompleted = overallProgress

                transaction.commit()
            }
        }
    }

    // MARK: - Number of attempts question
    class func questionsCompletedUpto(forTraining trainingId: Int) -> Int32 {
        var attempts: Int32 = 0
        if let training = CoreStore.fetchOne(
            From<TrainingInfo>(),
            Where("id", isEqualTo: Int32(trainingId))) {

            attempts = Int32((training.quizInfo?.completedUpto)!)
        }
        return attempts
    }

    //MARK: - finish quiz
    class func finishQuiz(for training: Training) {
        CoreStore.beginAsynchronous { (transaction) -> Void in
            if let trainingInfo = transaction.fetchOne(
                From<TrainingInfo>(),
                Where("id", isEqualTo: training.trainingId)) {

                let quizInfo = trainingInfo.quizInfo

                let attempts: Int16 = trainingInfo.remainingAttempts
                
                trainingInfo.playbackInterval = 0

                if attempts > 0 {
                    // quizInfo?.noOfAttempts = attempts - 1
                    quizInfo?.completedUpto = 0
                    trainingInfo.remainingAttempts = Int16((attempts - 1))
                    //training.status = TrainingStatus.Completed.hashValue
                }
                transaction.commit()
            }
        }
    }
    
    //MARK: - reattempt quiz
    class func reattemptQuiz(for training: Training) {
        CoreStore.beginAsynchronous { (transaction) -> Void in
            if let trainingInfo = transaction.fetchOne(
                From<TrainingInfo>(),
                Where("id", isEqualTo: training.trainingId)) {
                
                if trainingInfo.remainingAttempts > 0 {
                    trainingInfo.percentCompleted = 0.1
                    training.status = TrainingStatus.InProgress.hashValue
                    trainingInfo.playbackInterval = 0.0
                    
                    transaction.commit()
                }
            }
        }
    }

    // MARK: - Get Training Video Playback Time
    class func getTrainingPlaybackTime(forTraining trainingId: Int) -> Double {
        var playBack: Double = 0.0
        if let tempTrainingInfo = CoreStore.fetchOne(
            From<TrainingInfo>(),
            Where("id", isEqualTo: Int32(trainingId))) {
            playBack = tempTrainingInfo.playbackInterval
        }
        return playBack
    }

    // MARK: - Remaining attempts
    class func trainingAttemptsLeft(forTraining trainingId: Int) -> Int32 {
        var attempts: Int32 = 0
        if let training = CoreStore.fetchOne(
            From<TrainingInfo>(),
            Where("id", isEqualTo: Int32(trainingId))) {

            attempts = Int32((training.remainingAttempts))
        }
        return attempts
    }

    //MARK: - cache questions
    fileprivate class func cacheQuestions(questions: [Question], for quizInfo: QuizInfo) {
        for question in questions {
            CoreStore.beginAsynchronous { (transaction) -> Void in
                // QuestionInfo
                let questionInfo = transaction.create(Into<QuestionInfo>())
                questionInfo.convertQuestionToInfo(question: question)

                // [Answers]
                if let answers = question.options {
                    let answersSet: NSSet = NSSet()
                    for answer in answers {
                        let answerInfo = transaction.create(Into<AnswerInfo>())
                        answerInfo.convertAnswerToInfo(answer: answer)
                        answersSet.adding(answerInfo)
                    }

                    // assign answers to questionInfo relationship
                    questionInfo.addToAnswersInfo(answersSet)
                }

                // assign question to quiz relationship
                quizInfo.addToQuestionsInfo(questionInfo)

                transaction.commit()
            }
        }
    }
    
    //MARK: - Match and delete unvalid trainings
    class func findInvalidTrainings(validTrainings: NSArray) {
        var removeTrainingsIds:[Int] = [Int]()
        let loadTrainingArray: [Training] = self.loadTrainings()
        if loadTrainingArray.count > 0 {
            let trainingIds:[Int] = loadTrainingArray.map { $0.trainingId! }
            print("DB TrainingsId : \(trainingIds)")
            print("Valid TrainingsId : \(validTrainings)")
            
            for validId in trainingIds {
                if !validTrainings.contains(validId) {
                    removeTrainingsIds.append(validId)
                }
            }
            
            print("remove TrainingsId : \(removeTrainingsIds)")
            
            self.deleteInvalidTrainings(invalidTrainings: removeTrainingsIds)
        }
    }
    
    //MARK: - delete invalid trainings
    class func deleteInvalidTrainings(invalidTrainings: [Int]) {

        for trainingId in invalidTrainings {
            
            CoreStore.beginAsynchronous { (transaction) -> Void in
                print("start search training")
                if let trainInfo = transaction.fetchOne(
                    From<TrainingInfo>(),
                    Where("id", isEqualTo: trainingId)) {
                    
                    // Delete object
                    transaction.delete(trainInfo)
                    
                    // save changes
                    _ = transaction.commit()
                    
                    print("Training delete......")
                }
            }
        }
    }
    
    // MARK: - Feeds
    class func cacheFeeds(availableFeeds: [Feed], completionHandler: @escaping (_ success: Bool) -> Void) {
        for feed in availableFeeds {
            CoreStore.beginAsynchronous { (transaction) -> Void in
                print("cacheFeeds start")
                if let feedInfo = transaction.fetchOne(
                    From<FeedInfo>(),
                    Where("id", isEqualTo: feed.feedsId)) {
                    
                    // update existing feed
                    feedInfo.updateFeedInfo(feed: feed)
                    
                    // save changes
                    _ = transaction.commit()
                } else {
                    let feedInfo = transaction.create(Into<FeedInfo>())
                    feedInfo.createFeedInfo(feed: feed)
                    
                    // [Questions]
                    if let feedQuestions = feed.questions { // some feeds might not have questions
                        for question in feedQuestions {
                            
                            if let questionInfo = transaction.fetchOne(
                                From<QuestionInfo>(),
                                Where("id", isEqualTo: question.questionId)) {
                                
                                // update question
                                questionInfo.updateQuestionInfo(question: question)
                                
                                // update [Answers]
                                if let answers = question.options {
                                    for answer: Options in answers {
                                        
                                        if let answerInfo = transaction.fetchOne(
                                            From<AnswerInfo>(),
                                            Where("id", isEqualTo: answer.answerId)) {
                                            
                                            // update existing answer
                                            answerInfo.updateAnswerInfo(answer: answer)
                                        } else {
                                            let answerInfo = transaction.create(Into<AnswerInfo>())
                                            answerInfo.convertAnswerToInfo(answer: answer)
                                            
                                            questionInfo.addToAnswersInfo(answerInfo) // assign answers to questionInfo relationship
                                        }
                                    }
                                }
                                
                            } else {
                                
                                // create question
                                let questionInfo = transaction.create(Into<QuestionInfo>())
                                questionInfo.convertQuestionToInfo(question: question)
                                
                                // create [Answers]
                                if let answers = question.options {
                                    for answer in answers {
                                        let answerInfo = transaction.create(Into<AnswerInfo>())
                                        answerInfo.convertAnswerToInfo(answer: answer)
                                        
                                        questionInfo.addToAnswersInfo(answerInfo) // assign answers to questionInfo relationship
                                    }
                                }
                                // assign question to quiz relationship
                                feedInfo.addToQuestionsInfo(questionInfo)
                            }
                        }
                    }

                    // save changes
                    _ = transaction.commit()
                }
            }
        }
    }
    
    //MARK: - load feeds
    class func loadFeeds() -> [Feed] {
        var feeds = [Feed]()
        
        if let allFeeds = CoreStore.fetchAll(
            From<FeedInfo>(),
            Where("userId", isEqualTo: UserManager.shared.activeUser.userId)) {
            for feed: FeedInfo in allFeeds {
                feeds.append(Feed(info: feed))
            }
        }
        return feeds
    }

    
    // MARK: - Clear Database
    class func flushCachedData() {
        CoreStore.beginAsynchronous { (transaction) -> Void in
            transaction.deleteAll(
                From<TrainingInfo>(),
                Where("userId", isEqualTo: UserManager.shared.activeUser.userId))
            transaction.commit()
        }
    }
}
