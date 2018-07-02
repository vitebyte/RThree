//
//  OnboardingViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 15/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var viewOnboardingImageView: UIImageView!

    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animation: Bool) {
        super.viewWillAppear(animation)

        doInitialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Helper Methods
    func doInitialSetup() {
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
        navigationController?.setNavigationBarHidden(true, animated: false)
        getStartedButton.setTitle(LocalizedString.shared.buttonGetStartedTitle, for: .normal)
    }

    // MARK: - status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
