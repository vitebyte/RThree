//
//  RostersViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 05/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class RostersViewController: BaseViewController {

    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        super.navigationBarAppearanceBlack(navController: navigationController!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        navigationItem.title = LocalizedString.shared.rosterTitleString
    }
}
