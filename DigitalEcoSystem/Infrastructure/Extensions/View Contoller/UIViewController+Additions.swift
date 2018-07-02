//
//  UIViewController+Additions.swift
//
//  Created by Pawan Joshi on 12/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

// MARK: - UIViewController Extension
extension UIViewController {

    /**
     Shows a simple alert view for no internet condition

     - parameter title:   title for alerview
     - parameter message: message to be shown
     */
    func showNoNetworkAlertViewWithMessage(_ title: String = LocalizedString.shared.NO_NETWORK_TITLE, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: LocalizedString.shared.buttonConfirmTitle, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    /**
     Shows a simple alert view with a title and dismiss button

     - parameter title:   title for alerview
     - parameter message: message to be shown
     */
    func showAlertViewWithMessage(_ title: String, message: String, _ isError: Bool = false) {
        if isError {
            LogManager.logError("Error title: \(title) Message \(message)")
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: LocalizedString.shared.buttonConfirmTitle, style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    /**
     Shows a simple alert view with a title, dismiss button and action handler for dismiss button

     - parameter title:         title for alerview
     - parameter message:       message description
     - parameter actionHandler: actionHandler code/closer/block
     */
    func showAlertViewWithMessageAndActionHandler(_ title: String, message: String, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alAction = UIAlertAction(title: LocalizedString.shared.buttonConfirmTitle, style: .default) { _ in
            if let _ = actionHandler {
                actionHandler!()
            }
        }
        alertController.addAction(alAction)
        present(alertController, animated: true, completion: nil)
    }

    /**
     Shows a simple alert view with a title, message and dicision handler

     - parameter title:              title for alerview
     - parameter message:            message description
     - parameter trueButtonText:     title to show on Dicision true button
     - parameter falseButtonText:    title to show on Dicision false button
     - parameter trueActionHandler:  True dicision handler
     - parameter falseActionHandler: False dicision handler
     */
    func showAlertViewWithMessageAndDicisionHandler(_ title: String, message: String, trueButtonText: String, falseButtonText: String, trueActionHandler: (() -> Void)?, falseActionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alActionTrue = UIAlertAction(title: NSLocalizedString(trueButtonText, comment: trueButtonText), style: .default) { _ in

            if let _ = trueActionHandler {
                trueActionHandler!()
            }
        }

        let alActionFalse = UIAlertAction(title: NSLocalizedString(falseButtonText, comment: falseButtonText), style: .cancel) { _ in

            if let _ = falseActionHandler {
                falseActionHandler!()
            }
        }
        alertController.addAction(alActionTrue)
        alertController.addAction(alActionFalse)
        present(alertController, animated: true, completion: nil)
    }

    /**
     Shows a simple alert view with a simple text field

     - parameter title:                title description
     - parameter message:              message description
     - parameter textFieldPlaceholder: placeholder text for text field in alert view
     - parameter submitActionHandler:  submitActionHandler block/closer/code
     */
    func showAlertViewWithTextField(_ title: String, message: String, textFieldPlaceholder: String, submitActionHandler: @escaping (_ textFromTextField: String?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in

            textField.placeholder = textFieldPlaceholder
            textField.borderStyle = UITextBorderStyle.none
        }

        let submitAction = UIAlertAction(title: NSLocalizedString("Submit", comment: "Submit"), style: .default) { (_: UIAlertAction!) in

            let answerTF = alertController.textFields![0]
            let text = answerTF.text
            submitActionHandler(text)
        }
        alertController.addAction(submitAction)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) { (_: UIAlertAction!) in
            // we don't want to perform any action on cancel
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    /**
     Shows a simple alert view with a secure text field

     - parameter title:                title description
     - parameter message:              message description
     - parameter textFieldPlaceholder: placeholder text for text field in alert view
     - parameter submitActionHandler:  submitActionHandler block/closer/code
     */
    func showAlertViewWithSecureTextField(_ title: String, message: String, textFieldPlaceholder: String, submitActionHandler: @escaping (_ textFromTextField: String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in

            textField.placeholder = textFieldPlaceholder
            textField.isSecureTextEntry = true
        }

        let submitAction = UIAlertAction(title: NSLocalizedString("Submit", comment: "Submit"), style: .default) { (_: UIAlertAction!) in

            let answer = alertController.textFields![0]
            submitActionHandler(answer.text!)
        }
        alertController.addAction(submitAction)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) { (_: UIAlertAction!) in
            // we don't want to perform any action on cancel
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    /**
     Shows a simple action sheet with actions provided

     - parameter actions:            action for action sheet
     */
    func showActionSheet(_ actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        for action in actions {
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }

    func showErrorFromAPI(_ message: String? = "An error occurred") {
        let alertController = UIAlertController(title: LocalizedString.shared.ERROR_TITLE, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: LocalizedString.shared.buttonConfirmTitle, style: .cancel) { (_: UIAlertAction!) in

            if message == LocalizedString.shared.SESSION_EXPIRE_ERROR {
                // let storyboard = UIStoryboard.loginStoryboard
                // AppDelegate.delegate().window?.rootViewController = storyboard.initialViewController
                // AppDelegate.presentRootViewController()
            }
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
        LogManager.logError("Error from API \(LocalizedString.shared.ERROR_TITLE): \(message)")
    }

    /**
     Dismiss Or Pop ViewController according to availablity

     - parameter animated:     animated
     */
    func dismissOrPopViewController(_ animated: Bool) {
        if navigationController != nil {
            _ = navigationController?.popViewController(animated: animated)
        } else {
            dismiss(animated: animated, completion: nil)
        }
    }

    /**
     Dismiss Or Pop ViewController according to availablity

     - parameter animated:     animated
     */
    func dismissOrPopToRootViewController(_ animated: Bool) {
        if navigationController != nil {
            _ = navigationController?.popToRootViewController(animated: animated)
        } else {
            dismiss(animated: animated, completion: nil)
        }
    }

    /**
     Present Or Push ViewController according to availablity

     - parameter animated:     animated
     */
    func presentOrPushViewController(_ animated: Bool, _ viewController: UIViewController) {
        if navigationController != nil {
            _ = navigationController?.pushViewController(viewController, animated: animated)
        } else {
            present(viewController, animated: animated, completion: nil)
        }
    }
}

extension UIViewController {
    /**
     shows activity controller with supplied items. at least one type of item must be supplied

     - parameter image:      image to be shared
     - parameter text:       text to be shared
     - parameter url:        url to be shared
     - parameter activities: array of UIActivity which you want to show in controller. nil value will show every available active by default
     */
    func showActivityController(_ image: UIImage?, text: String?, url: String?, activities: [UIActivity]? = nil) {
        var array = [AnyObject]()
        if image != nil {
            array.append(image!)
        }
        if text != nil {
            array.append(text! as AnyObject)
        }
        if url != nil {
            array.append(URL(string: url!)! as AnyObject)
        }

        assert(array.count != 0, "Please specify atleast one element to share among image, text or url")
        let activityController = UIActivityViewController(activityItems: array, applicationActivities: activities)
        present(activityController, animated: true, completion: nil)
    }
}

extension UIViewController {
    /**
     status-bar color
     */
    func setStatusBarLightColor(_ isLight: Bool) {

        if isLight {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    }
}
