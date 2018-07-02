//
//  ChooseLanguageViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 16/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit
import Localize_Swift

class ChooseLanguageViewController: BaseViewController {

    // MARK: - Variables
    private let availableLanguages = Localize.availableLanguages()
    private var languageCode = UserManager.shared.userLanguageCode
    public var selectedLanguage: Language = UserManager.shared.userLanguage()!
    public var isPresentingSelf = false

    // MARK: IBOutlet
    @IBOutlet weak var tickEspanolImageView: UIImageView!
    @IBOutlet weak var tickEnglishImageView: UIImageView!
    @IBOutlet weak var englishChosenButton: UIButton!
    @IBOutlet weak var espanolChosenButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UserManager.shared.activeUser.langCode! == 1 {
            englishChosenAction(englishChosenButton)
        } else {
            espanolChosenAction(espanolChosenButton)
        }

        if isPresentingSelf {
            // super.addCloseOnNavBar()
            super.addLeftBarButton(withImageName: Constants.BarButtonItemImage.closeBlackColor)
        } else {
            // super.addBlackBackBarButton()
            super.addLeftBarButton(withImageName: Constants.BarButtonItemImage.BackArrowBlackColor)
        }
        handleLocalizeStrings()
    }

    // MARK: - Helper Methods
    func doInitialSetup() {
        setButtonStates()
        setButtonApperence(englishChosenButton)
        setButtonApperence(espanolChosenButton)
    }

    func setButtonApperence(_ button: UIButton) {
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.shadowRadius = 12.0
        button.layer.shadowColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
    }

    func handleLocalizeStrings() {
        if isPresentingSelf {
            nextButton.setTitle(LocalizedString.shared.buttonPresentedTitle, for: .normal)
        } else {
            nextButton.setTitle(LocalizedString.shared.buttonNextTitle, for: .normal)
        }
        //        super.setNavBarTitle(LocalizedString.shared.languageTitleString)
        navigationItem.title = LocalizedString.shared.languageTitleString
    }

    func setButtonStates() {
        englishChosenButton.titleLabel!.font = UIFont.gothamMedium(17)
        espanolChosenButton.titleLabel!.font = UIFont.gothamLight(17)
        tickEspanolImageView.isHidden = true
        tickEnglishImageView.isHidden = false
    }

    func moveToProfilePicVC() {
        let storyBoard: UIStoryboard = UIStoryboard.mainStoryboard()
        let profilePicViewController = storyBoard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ProfilePicIdentifier) as! ProfilePicViewController
        navigationController?.pushViewController(profilePicViewController, animated: true)
    }

    // MARK: - Button Action
    override func leftButtonPressed(_: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func englishChosenAction(_: Any) {
        englishChosenButton.titleLabel!.font = UIFont.gothamMedium(17)
        espanolChosenButton.titleLabel!.font = UIFont.gothamLight(17)
        tickEspanolImageView.isHidden = true
        tickEnglishImageView.isHidden = false

        selectedLanguage.id = 1
        selectedLanguage.name = "English"
        selectedLanguage.code = "en"
    }

    @IBAction func espanolChosenAction(_: Any) {
        englishChosenButton.titleLabel!.font = UIFont.gothamLight(17)
        espanolChosenButton.titleLabel!.font = UIFont.gothamMedium(17)
        tickEspanolImageView.isHidden = false
        tickEnglishImageView.isHidden = true

        selectedLanguage.id = 2
        selectedLanguage.name = "Spanish"
        selectedLanguage.code = "es"
    }

    @IBAction func nextClickedAction(_: Any) {
        if isPresentingSelf {
            dismiss(animated: true, completion: nil)
        } else {
            setLanguage(language: selectedLanguage.id!)
        }
    }
}

// MARK: - API Calls
extension ChooseLanguageViewController {
    // MARK: - Services
    func setLanguage(language: Int) {
        Helper.showLoader()
        UserManager.shared.activeUser.performUploadLanguageSelectedByUser(language: language, completionHandler: { (success, _) -> Void in
            Helper.hideLoader()
            if success {

                // update current lang
                Localize.setCurrentLanguage(self.selectedLanguage.code!)

                // reset shared instance to have new localized values
                LocalizedString.resetShared()

                self.moveToProfilePicVC()
            } else {
                super.showAlertViewWithMessage(LocalizedString.shared.LANGUAGE_FAILURE_DESC, message: LocalizedString.shared.LANGUAGE_UNABLE_TO_UPDATE,true)
            }
        })
    }
}
