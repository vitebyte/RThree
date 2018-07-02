//
//  StoreManagerTabbarViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 03/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class StoreManagerTabbarViewController: UITabBarController {

    private var freshLaunch = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
