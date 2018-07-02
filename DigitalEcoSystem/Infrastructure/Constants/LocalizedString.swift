//
//  LocalizedString.shared.swift
//  Digital EcoSystem
//
//  Created by Ravi Ranjan on 18/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import Foundation
import Localize_Swift

class LocalizedString: NSObject {

    // MARK: - Singleton Instance
    private static var _sharedInstance = LocalizedString()

    open class var shared: LocalizedString {
        return _sharedInstance
    }

    open class func resetShared() {
        _sharedInstance = LocalizedString()
    }

    private override init() {
        super.init()
    }

    // MARK: - Localizable Strings
    var buttonPresentedTitle: String = "Save".localized()
    var startTitle: String = "Start".localized()
    var watchlater: String = "Watch later".localized()
    var skip: String = "Skip".localized()
    
    // MARK: - Message Button String
    var YES: String = "Yes".localized()
    var NO: String = "No".localized()

    // MARK: - Shared Strings
    var buttonNextTitle: String = "Next".localized()
    var buttonReturnTitle: String = "Return".localized()

    // MARK: - Logout Strings
    var buttonLogoutTitle: String = "Logout".localized()
    var logoutTitle: String = "Are you sure want to logout?".localized()
    var buttonConfirmTitle: String = "Ok".localized()
    var buttonCancelTitle: String = "Cancel".localized()

    // MARK: - TrainingVideo Strings
    var trainingCompleted: String = "You have already completed this training.".localized()

    // MARK: - No Camera Strings
    var buttonNoCameraTitle: String = "No Camera".localized()
    var cameraDesc: String = "Sorry, this device has no camera".localized()

    // MARK: - Onboarding View Controller Strings
    var buttonGetStartedTitle: String = "Get Started" // .localized()
    var getStartedTitle: String = "Get Started".localized()

    // MARK: - Profile Pic View Controller Strings
    var profilePicBannerText = "Looking good, ".localized()
    var profileTitleString: String = "Upload a profile photo".localized()
    var buttonFinishTitle: String = "Finish".localized()
    var buttonTakePhotoTitle: String = "Take Photo".localized()
    var buttonUseCameraTitle: String = "Use Camera Roll".localized()

    // MARK: - Choose Language View Controller Strings
    var languageTitleString: String = "Choose your language".localized()

    // MARK: - Sign In View Controller Strings
    var signInTitleString: String = "Sign In" // .localized()
    var signInHeaderTitle: String = "Sign In with your Dean & Deluca account details" // .localized()

    // MARK: - Text Field Place Holders Strings
    var emailPlaceHolders: String = "Email Address" // .localized()
    var passwordPlaceHolders: String = "Password" // .localized()
    var searchAssociatesString: String = "Search Associates".localized()

    // MARK: - Associate Training View Controller Strings
    // MARK: - Roster View Controller Strings
    var rosterTitleString: String = "Roster".localized()

    // MARK: - Store Manager Training View Controller Strings
    var trainingTitleString: String = "Training".localized()
    var yourTrainingTitleString: String = "Your Training".localized()
    var associatesString: String = "Associates".localized()
    var trainersString: String = "Trainers".localized()
    var trainerAssignedString: String = "Associate Trainer assigned".localized()

    // MARK: - Performance View Controller Strings
    var performanceTitleString: String = "Performance".localized()

    // MARK: - Notifications View Controller Strings
    var notificationTitleString: String = "Notification".localized()

    // MARK: - Select Modules View Controller Strings
    var selectModulesTitleString: String = "Select Modules".localized()

    // MARK: - Confirm Associate View Controller Strings
    var confirmTitleString: String = "Confirm".localized()

    // MARK: - Trainer View Controller Strings
    var trainerTitleString: String = "Assign a Trainer".localized()
    var trainerSubtitleString: String = "Choose an Associate".localized()
    var trainerString: String = "Trainers".localized()
    var associateString: String = "Associates".localized()
    var assignString: String = "Assign ".localized()
    var associateTrainerString: String = " as an Associate Trainer".localized()

    // MARK: - My Profile View Controller Strings
    var profileSubtitleString: String = "My DDXP".localized()
    var welcomeString: String = "Welcome".localized()
    var categoriesButtonString: String = "Most Recent".localized()
    var reviewResultsString: String = "Review trainees results".localized()

    // MARK: - Training Detail View Controller Strings
    var nextQuestionString: String = "Next Question".localized()
    var finishLaterString: String = "Finish Later".localized()
    var questionString: String = "Question".localized()
    var ofString: String = "of".localized()
    var noQuestionsString: String = "No questions are available for this training".localized()

    // MARK: - Training Result View Controller Strings
    var wellDoneString: String = "Well done!".localized()
    var doneString: String = "Done".localized()

    var headerTitle: String = "A Dope Title".localized()
    var descriptionText: String = "Some really really cool onboarding descriptions which should take up 3 lines maximum. Probably".localized()

    var correctQuestionString: String = "of questions answered correctly".localized()
    var attemptRemainingString: String = "attempt remaining.".localized()
    var tryAgainString: String = "Try Again?".localized()
    var completeString: String = "Complete!".localized()

    // MARK: - Assign View Controller Strings
    var buttonAssignTitle: String = "Assign ".localized()
    var confirmTitle: String = "Confirm".localized()
    var traineesTitle: String = "Trainees".localized()
    var trainingTitle: String = "Training".localized()

    // MARK: - Trainee  View Controller Strings
    // var traineeTitleString: String = "Assign a Trainee".localized()
    var traineeTitleString: String = "Assign Trainee(s)".localized()
    var traineeSubtitleString: String = "Choose Associate(s)".localized()

    var selectedTitleString: String = " selected".localized()
    var selectTitleString: String = "select".localized()

    // MARK: - Choose Modules  View Controller Strings
    var modulesTitleString: String = "Select Modules".localized()

    // MARK: - Feed View Controller Strings
    var feedTitleString: String = "Feed".localized()
    var cellMarkReadString: String = "Mark as Read".localized()
    var correctString: String = "CORRECT".localized()
    var incorrectString: String = "INCORRECT".localized()
    var confirmAnswerString: String = "Confirm Answer".localized()

    // MARK: - Choose Trainer View Controller Strings
    var chooseTrainerTitle: String = "Assign a Trainer".localized()
    var chooseTrainerSubtitle: String = "Choose an Associate".localized()
    var chooseTrainerDesignation: String = "Associate Trainer".localized()

    // MARK: - StoreManager Training View Controller Strings
    var emptyViewTitle: String = "No Associate Trainers".localized()
    var emptyViewDesc: String = "Assign an Associate as an Associate Trainer using the \"+\" found above.".localized()

    var signInHeaderString: String = "Sign In with your Dean & Deluca account details".localized()

    // MARK: - AlertTitles
    var ERROR_TITLE = "Error".localized()
    var SUCCESS_TITLE = "Success".localized()
    var FAILURE_TITLE = "Failure".localized()
    var INFORMATION_TITLE = "Information".localized()
    var NO_NETWORK_TITLE = "No network".localized()
    var CONFIRMATION_TITLE = "Please Confirm".localized()
    var LOGIN_FAILURE_DESC = "Unable to Login".localized()
    var IMAGE_FAILURE_DESC = "Unable to Upload Image".localized()
    var LANGUAGE_FAILURE_DESC = "Unable to Choose Language".localized()
    var VIDEO_FAILURE_DESC = "Unable to play video. Please try again".localized()

    //MARK: - Network Error
    var NETWORK_DISCONNECTED: String = "Unable to connect, check your network connection.".localized()
    var NETWORK_ERROR: String = "An error occurred while processing.".localized()
    var LOADING_ERROR: String = "Could not load page.".localized()
    var SESSION_EXPIRE_ERROR: String = "Your session has expired. Please login again".localized()
    var QUIZ_ERROR: String = "Unable to save quiz result. Please try again".localized()

    //MARK: - Validation Errors
    var EMPTY_PASSWORD: String = "Please fill password.".localized()
    var EMPTY_EMAIL: String = "Please fill email address.".localized()
    var INCORRECT_PASSWORD: String = "Incorrect password, please try again.".localized()
    var INCORRECT_EMAIL: String = "Incorrect email, please try again.".localized()
    var PASSWORD_MISMATCH: String = "New password and confirm password do not match.".localized()
    var EMPTY_CREDENTIALS: String = "Please fill email address and password.".localized()
    var INCORRECT_CREDENTIALS: String = "Incorrect email and password, please try again.".localized()
    var TRAINER_NOTSELECTED: String = "Select at least one module from the list".localized()
    var TRAINEE_NOTSELECTED: String = "Please select atleast one trainee for the training".localized()
    var TRAINING_NOTSELECTED: String = "Please select atleast one training".localized()

    var PROFILE_PIC_UNABLE_TO_UPDATE: String = "Unable to update profile photo. Please try after some time.".localized()
    var LANGUAGE_UNABLE_TO_UPDATE: String = "Unable to choose language. Please try after some time.".localized()
    var NO_ANSWER: String = "Please select any option.".localized()
    var NO_ATTEMPTS_LEFT: String = "No more attempts left. Please contact your manager".localized()

    var TRAINING_EXPIRED: String = "This training has been expired now".localized()

    // No Trainee
    var NO_TRAINEE: String = "Sorry, you have no trainee".localized()

    var NO_TRAINEE_REQUEST: String = "This trainee has no Approve/Reject training request".localized()
    var TRAINING_APPROVE: String = "Are you sure, want to proceed ?".localized()

    // "couldn't parse the response"

    //MARK: - Login Errors
    var LOGIN_FAILED: String = "Sorry, we can't log you in right now. Please try again".localized()

    //MARK: - Response Errors
    var RESPONSE_ERROR: String = "couldn't parse the response".localized()

    //MARK: - Filter
    var NO_FILTER: String = "Sorry, No filter found".localized()

    var NO_ASSOCIATE: String = "Sorry, No Associate found".localized()
}
