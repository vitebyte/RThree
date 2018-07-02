//
//  NotificationsViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 05/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var logoutButton: UIButton!

    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        super.navigationBarAppearanceBlack(navController: navigationController!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)

        doInitialSetup()
        handleLocalizeStrings()
    }

    // MARK: - Helper Methods
    func doInitialSetup() {
        // super.addMoreLeftBarButton()
        super.addRightBarButton(withImageName: Constants.BarButtonItemImage.MoreWhiteColor)
    }

    func handleLocalizeStrings() {
        navigationItem.title = LocalizedString.shared.notificationTitleString
        logoutButton.setTitle(LocalizedString.shared.buttonLogoutTitle, for: .normal)
    }

    //MARK: - Actions
    @IBAction func logoutAction(_: UIButton) {
        let alertController = UIAlertController(title: nil, message: LocalizedString.shared.logoutTitle, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString(LocalizedString.shared.buttonConfirmTitle, comment: LocalizedString.shared.buttonConfirmTitle), style: UIAlertActionStyle.destructive, handler: { (_) -> Void in
            // Handle Logout
            self.userLogout()
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString(LocalizedString.shared.buttonCancelTitle, comment: LocalizedString.shared.buttonCancelTitle), style: UIAlertActionStyle.cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
}

//MARK: API Calls
extension NotificationsViewController {
    func userLogout() {
        UserManager.shared.activeUser.performLogout { (success, strMessage) -> Void in
            if success {
                CoreDataManager.flushCachedData()
                AppDelegate.presentRootViewController()
            } else {
                self.showAlertViewWithMessage(LocalizedString.shared.FAILURE_TITLE, message: strMessage!,true)
            }
        }
    }
}
