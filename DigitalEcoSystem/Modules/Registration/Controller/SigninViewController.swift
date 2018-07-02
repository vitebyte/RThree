//
//  DESigninViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 15/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit
import Localize_Swift // 1

class SigninViewController: BaseViewController, UIGestureRecognizerDelegate {

    // MARK: - Variables
    private let spacing: CGFloat = 16

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var incorrectPasswordLabel: UILabel!
    @IBOutlet weak var viewButtonBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var headingLabel: UILabel!

    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.text = "uttam.chauhan@appster.in" // Store Manager
        // emailTextField.text = "narender.kumar@appster.in" // A
        // emailTextField.text = "arvind.singh@appster.in" //
        passwordTextField.text = "qwerty"
        // emailTextField.text = "ravi.ranjan6@appster.in"
        // passwordTextField.text = "swatiranjan"

        navigationController?.setNavigationBarHidden(false, animated: false)
        super.navigationBarAppearanceWhite(navController: navigationController!)
        // super.addBlackBackBarButton()
        super.addLeftBarButton(withImageName: Constants.BarButtonItemImage.BackArrowBlackColor)
        doInitialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTap(_:)))
        tap.delegate = self
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        self.handleLocalizeStrings()
    }

    override func leftButtonPressed(_: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Helper Methods
    func doInitialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        incorrectPasswordLabel.isHidden = true
        headingLabel.attributedText = UILabel.setTextWithLineSpacing(text: headingLabel.text!, lineSpacing: spacing)
        headingLabel.attributedText = UILabel.addTextSpacing(textString: headingLabel.text!, spaceValue: 0.5)
    }

    func handleLocalizeStrings() {
        navigationItem.title = LocalizedString.shared.signInTitleString
        headingLabel.text = LocalizedString.shared.signInHeaderTitle
        emailTextField.placeholder = LocalizedString.shared.emailPlaceHolders
        passwordTextField.placeholder = LocalizedString.shared.passwordPlaceHolders
        nextButton.setTitle("Next", for: .normal) // Intentionally hard coding title - LocalizedString.shared.buttonNextTitle
    }

    func validateCredentials() -> Bool {
        if (emailTextField.text?.isEmpty)! && (passwordTextField.text?.isEmpty)! {
            emailTextField.text = ""
            passwordTextField.text = ""
            incorrectPasswordLabel.isHidden = false
            passwordTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.shared.passwordPlaceHolders,
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.red])
            emailTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.shared.emailPlaceHolders,
                                                                      attributes: [NSForegroundColorAttributeName: UIColor.red])
            incorrectPasswordLabel.text = LocalizedString.shared.EMPTY_CREDENTIALS
            passwordTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            return false
        } else if !((emailTextField.text?.isValidEmail())!) && !((passwordTextField.text?.isValidPassword())!) {
            emailTextField.text = ""
            passwordTextField.text = ""
            incorrectPasswordLabel.isHidden = false
            passwordTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.shared.passwordPlaceHolders,
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.red])
            emailTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.shared.emailPlaceHolders,
                                                                      attributes: [NSForegroundColorAttributeName: UIColor.red])
            incorrectPasswordLabel.text = LocalizedString.shared.INCORRECT_CREDENTIALS
            passwordTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            return false

        } else if emailTextField.text?.isEmpty ?? true {
            emailTextField.text = ""
            incorrectPasswordLabel.isHidden = false
            emailTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.shared.emailPlaceHolders,
                                                                      attributes: [NSForegroundColorAttributeName: UIColor.red])
            incorrectPasswordLabel.text = LocalizedString.shared.EMPTY_EMAIL
            passwordTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            return false
        } else if !((emailTextField.text?.isValidEmail())!) {
            emailTextField.text = ""
            passwordTextField.text = ""
            incorrectPasswordLabel.isHidden = false
            passwordTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.shared.passwordPlaceHolders,
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.red])
            emailTextField.attributedPlaceholder = NSAttributedString(string: Constants.TextfieldPlaceholders.EMAIL,
                                                                      attributes: [NSForegroundColorAttributeName: UIColor.red])
            incorrectPasswordLabel.text = LocalizedString.shared.INCORRECT_CREDENTIALS
            passwordTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            passwordTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
            return false
        } else if passwordTextField.text?.isEmpty ?? true {

            incorrectPasswordLabel.isHidden = false
            passwordTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.shared.passwordPlaceHolders,
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.red])
            incorrectPasswordLabel.text = LocalizedString.shared.EMPTY_PASSWORD
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            return false
        } else if !((passwordTextField.text?.isValidPassword())!) {
            passwordTextField.text = ""
            incorrectPasswordLabel.isHidden = false
            passwordTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.shared.passwordPlaceHolders,
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.red])
            incorrectPasswordLabel.text = LocalizedString.shared.INCORRECT_PASSWORD
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            return false
        } else {
            return true
        }
    }

    // MARK: - Handling Keyoard Actions
    func backgroundTap(_: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }

    override func keyboardWillShow(_ sender: Notification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            viewButtonBottomConstant.constant = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    override func keyboardWillHide(_ sender: Notification) {
        if ((sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            viewButtonBottomConstant.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    // MARK: - Button Actions
    @IBAction func btnNextAction(_: Any) {
        if validateCredentials() {
            backgroundTap()
            performLogin()
        }
    }
}

 // MARK: - TextField Delegate
extension SigninViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        return true
    }

    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString _: String) -> Bool {
        if (passwordTextField.text?.characters.count)! > 0 {
            incorrectPasswordLabel.isHidden = true
            passwordTextField.attributedPlaceholder = NSAttributedString(string: Constants.TextfieldPlaceholders.PASSWORD,
                                                                         attributes: [NSForegroundColorAttributeName: UIColor.init(hexColorCode: Constants.ColorHexCodes.ironGrayColor)])
        }
        if (emailTextField.text?.characters.count)! > 0 {
            incorrectPasswordLabel.isHidden = true
            emailTextField.attributedPlaceholder = NSAttributedString(string: Constants.TextfieldPlaceholders.EMAIL,
                                                                      attributes: [NSForegroundColorAttributeName: UIColor.init(hexColorCode: Constants.ColorHexCodes.ironGrayColor)])
        }
        return true
    }

    func textFieldShouldClear(_: UITextField) -> Bool {
        return true
    }
}

// MARK: - Services
extension SigninViewController {
    func performLogin() {
        Helper.showLoader()
        User.performLoginWithEmail(email: emailTextField.text!, password: passwordTextField.text!, completionHandler: { (success, strMessage) -> Void in
            Helper.hideLoader()
            if success {
                let storyBoard: UIStoryboard = UIStoryboard.mainStoryboard()

                let orientationVideoViewController = storyBoard.instantiateViewController(withIdentifier: "OrientationVideoViewController") as! OrientationVideoViewController
                self.navigationController?.pushViewController(orientationVideoViewController, animated: true)
            } else {
                self.showAlertViewWithMessageAndActionHandler(LocalizedString.shared.LOGIN_FAILURE_DESC, message: strMessage!, actionHandler: {
                    // Blank block
                })
            }
        })
    }
}
