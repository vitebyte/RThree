//
//  Constants.swift
//  DigitalEcoSystem
//
//  Created by Shafi Ahmed on 06/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

struct Constants {

    //MARK: - EMAIL PHONE , PASSWORD
    static let CONTACT_US_EMAIL: String = "ddxp@pacedev.com"
    static let CONTACT_US_PHONE: String = "888-888-888"
    static let PASSWORD_REGEX: String = "^[a-zA-Z_0-9\\-#!$@]{6,15}$"

    //MARK: - BarButton item image
    struct BarButtonItemImage {
        static let BackArrowBlackColor: String = "backArrow.png"
        static let BackArrowWhiteColor: String = "backWhiteArrow.png"
        static let AddWhiteColor: String = "icAdd.png"
        static let MoreWhiteColor: String = "icMore.png"
        static let closeBlackColor: String = "icClose.png"
        static let closeWhiteColor: String = "isCloseWhite.png"
    }

    //MARK: - Conditional messages
    struct ConditionalMessages {
        static let EMPTY_APPAREL_COLLECTION: String = "Please add some images"
        static let EMPTY_WARDROBE_COLLECTION: String = "There is nothing in your wardrobe yet. Please add some apparels first."
        static let EMPTY_LOOKBOOK_COLLECTION: String = "There is nothing in your lookbook yet. Please create some looks first."
        static let LOGOUT_PROMPT: String = "Are you sure, you want to log out?"
        static let PROFILE_PIC_UNABLE_TO_UPDATE: String = "Unable to update profile photo. Please try after some time."
        static let LANGUAGE_UNABLE_TO_UPDATE: String = "Unable to choose language. Please try after some time."
        static let NO_ANSWER: String = "Please select any option."
    }

    //MARK: - notification constants
    struct NotificationConstants {
        static let PROFILE_UPDATED = "PROFILE_UPDATED"
        static let REFRESH_TRAININGS: String = "RefreshTrainingList"
    }

    //MARK: - color code
    struct ColorHexCodes {
        static let THEME_COLOR = "5345df"
        static let dustyGrayColor = "#979797"
        static let ironGrayColor = "#DDDDE0"
        static let gallerySolidGray = "#EFEFEF"
        static let CellWhiteColor = "#ffffff"
    }

    //MARK: - result key
    struct RESULTKEY {
        static let QUESTIONID: String = "questionId"
        static let ANSWERID: String = "answerId"
    }

    //MARK: - training status
    struct TrainingStatus {
        static let New = "New".localized()
        static let InProgress = "In-Progress".localized()
        static let Completed = "Completed".localized()
        static let Expired = "Expired".localized()
    }

    //MARK: - training weightage
    struct TrainingWeightage {
        static let VideoPercent = 50
        static let QuizPercent = 50
    }

    //MARK: - base url
    static let BASE_URL = ConfigurationManager.shared.applicationEndPoint()

    static let Image_Base_Url: String = ConfigurationManager.shared.applicationImageEndPoint()
    struct ImageUrl {
        static let LargeImage = Image_Base_Url + "ddxp-resized/large/"
        static let SmallImage = Image_Base_Url + "ddxp-resized/small/"
        static let OriginalImage = Image_Base_Url + "ddxp/"
        static let Video = Image_Base_Url + "ddxp/"
    }

    //MARK: - ViewController Identifiers
    struct ViewControllerIdentifiers {
        static let SigninIdentifier: String = "SigninViewController"
        static let ProfilePicIdentifier: String = "ProfilePicViewController"
        static let ChooseLanguageIdentifier: String = "ChooseLanguageViewController"
        static let OnboardingViewIdentifier: String = "OnboardingViewController"
        static let WalkThroughIdentifier: String = "WalkThroughViewController"
        static let BaseViewIdentifier: String = "BaseViewController"
        static let TabBarIdentifier: String = "TabBarViewController"
        static let TrainingFeedIdentifier: String = "TrainingFeedViewController"
        static let TrainingDetailViewController: String = "TrainingDetailViewController"
        static let TrainingVideoIdentifier: String = "TrainingVideoViewController"
        static let SettingsViewControllerIdentifier: String = "SettingsViewController"
        static let TrainingQuestionsIdentifier: String = "TrainingQuestionsViewController"
        static let ChooseTrainerIdentifier: String = "ChooseTrainerViewController"
        static let ChooseTraineeIdentifier: String = "ChooseTraineeViewController"
        static let ChooseCategoryIdentifier: String = "ChooseCategoryViewController"
        static let TrainingResultIdentifier: String = "TrainingResultViewController"
        static let SelectModulesIdentifier: String = "SelectModulesViewController"
        static let ConfirmAssigneeIdentifier: String = "ConfirmAssigneeViewController"
        static let StoreManagerIdentifier: String = "StoreManagerTrainingViewController"
        static let associateOverviewIdentifier: String = "AssociateOverviewViewController"
        static let ReviewTraineeIdentifier = "ReviewTraineeViewController"
        static let ReviewTraineeListIdentifier = "ReviewTraineeListViewController"
        static let filterIdentifier = "FilterViewController"
    }

    //MARK: - Textfield Placeholders
    struct TextfieldPlaceholders {
        static let EMAIL: String = LocalizedString.shared.emailPlaceHolders
        static let PASSWORD: String = LocalizedString.shared.passwordPlaceHolders
    }

    //MARK: - NavigationBar Titles
    struct NavigationBarTitles {
        static let SIGNIN_TITLE: String = "Sign In"
        static let PROFILEPIC_TITLE: String = "Upload a profile photo"
        static let CHOOSELANUAGE_TITLE: String = "Choose your language"
        static let TARINING_TITLE: String = "Your Training"
        static let FEEDS_TITLE: String = "Feed"
    }

    //MARK: - NavigationBar Titles
    struct CellIdentifiers {
        static let WALKTROUGH_CELLIDENTIFIER: String = "walkthroughCell"
    }

    //MARK: - API keys
    struct APIKEYS {
        static let EMAIL: String = "email"
        static let PASSWORD: String = "password"
        static let DEVICE_TYPE: String = "deviceType"
        static let DEVICE_TOKEN: String = "deviceToken"

        static let SUCCESS: String = "success"
        static let MESSAGE: String = "message"
        static let DATA: String = "data"
        static let TOTAL_PAGES: String = "totalPages"
        static let NUMBER_OF_RESULTS: String = "numberOfResults"
        static let SESSION_ID: String = "sessionId"
        static let USER_ID: String = "userId"
        static let CONTENTLIST: String = "contentList"

        static let DELETE_TRAINING_IDS: String = "delTrainingIds"
        static let ALL_TRAINING: String = "allTrainings"
        static let VALID_TRAINING_IDS: String = "validIds"

        static let TRAINEE_IDS: String = "traineeIds"
        static let TRANING_IDS: String = "traningIds"
        static let TRAINER_ID: String = "trainerId"
        static let STORE_ID: String = "storeId"

        static let USER_ANSWERS: String = "userAnswers"
        static let TRAINING_ID: String = "trianingId"

        static let TRAINEE_ID: String = "trianingId"
        static let STATUS: String = "status"
    }

    //MARK: - api service methods
    struct APIServiceMethods {
        static func apiURL(_ methodName: String) -> String {
            return Constants.BASE_URL + "/" + methodName
        }

        // Api Page Size(result come in a request)
        static let pageSize = "20"

        // Registration
        static let loginAPI = Constants.APIServiceMethods.apiURL("user/auth/signIn")
        static let saveProfilePicAPI = Constants.APIServiceMethods.apiURL("app/saveProfilePic")
        static let logoutAPI = Constants.APIServiceMethods.apiURL("user/auth/logout")
        static let languageAPI = Constants.APIServiceMethods.apiURL("app/updateLang?langCode=%@&userId=%@")

        static let termAndConditionAPI = Constants.APIServiceMethods.apiURL("terms-and-conditions")
        static let privacyPolicyAPI = Constants.APIServiceMethods.apiURL("privacy")

        // Trainings   listCats?page=1&size=10
        // app/listTrainings?page=1&size=10&catId=0&subCatId=0
        static let traningListAPI = Constants.APIServiceMethods.apiURL("app/listTrainings?catId=%@&subCatId=%@&page=%@&size=\(pageSize)")
        static let assignTrainingsAPI = Constants.APIServiceMethods.apiURL("app/assignTrainings")
        static let trainingQuiz = Constants.APIServiceMethods.apiURL("app/getQuizs?trainingId=%@")
        static let syncTrainingResult = Constants.APIServiceMethods.apiURL("app/syncQuizResult")

        // Trining video time sync on server
        static let syncTrainingVideo = Constants.APIServiceMethods.apiURL("app/updateVideo?trainingId=%@&time=%@")
        // Trining question time sync on server
        static let syncTrainingQuestion = Constants.APIServiceMethods.apiURL("app/updateQuiz?trainingId=%@&questionId=%@")

        // Get Store Manager Filter 1.
        static let categoriesAPI = Constants.APIServiceMethods.apiURL("app/listPagedCategories?page=%@&size=\(pageSize)")
        // Get Filter Associate 2.
        static let associteByFilterAPI = Constants.APIServiceMethods.apiURL("store/listTraineesByCategory?catId=%@&subCatId=%@&page=%@&size=\(pageSize)")
        // Get Training by associate 3.
        static let associateTrainingListAPI = Constants.APIServiceMethods.apiURL("app/getTrainingsByAssociate?associateId=%@&page=%@&size=\(pageSize)")
        // Get New filter for training accourding to Associate training 4.
        static let categoryForTrainingListAPI = Constants.APIServiceMethods.apiURL("app/listCategoriesAssociateTraining?userId=%@&page=%@&size=500")
        // Get new training by filte 5.
        static let trainingByFilterAPI = Constants.APIServiceMethods.apiURL("app/getAssociateTrainingsByCatSubCat?associateId=%@&catId=%@&subCatId=%@&page=%@&size=\(pageSize)")

        // Trainee
        static let traineesListAPI = Constants.APIServiceMethods.apiURL("app/getAllTrainee?page=%@&size=\(pageSize)")
        static let resetTraineesTrainingAPI = Constants.APIServiceMethods.apiURL("app/resetAttempt?traineeId=%@&trainingId=%@")

        // GET /api/v1/app/getAssociateTrainListByTrainer
        static let associateTrainingListByTrainerAPI = Constants.APIServiceMethods.apiURL("app/getAssociateTrainListByTrainer?traineeId=%@&page=%@&size=\(pageSize)")
        static let approveAndRejectTrainingAPI = Constants.APIServiceMethods.apiURL("app/appRejTraining?traineeId=%@&trainingId=%@&action=%@")

        // Feeds
        static let feedsListAPI = Constants.APIServiceMethods.apiURL("app/feed/listFeeds?page=%@&size=\(pageSize)")
        static let markAsReadAPI = Constants.APIServiceMethods.apiURL("app/feed/markAsRead?notId=%@")

        // Rosters

        // Notifications

        // Performance

        // Store Manage                                                app/listAssociates?storeId=1&page=1&size=10
        static let associatesListAPI = Constants.APIServiceMethods.apiURL("app/listAssociates?storeId=%@&page=%@&size=\(pageSize)")
        // api/v1/app/listTrainers?page=1&size=10
        static let trainersListAPI = Constants.APIServiceMethods.apiURL("app/listTrainers?page=%@&size=\(pageSize)")
    }
}
