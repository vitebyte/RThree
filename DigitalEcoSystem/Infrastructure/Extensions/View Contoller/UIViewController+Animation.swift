//
//  UIViewController+Animation.swift
//
//  Created by Shafi Ahmed on 16/06/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    // MARK: Flip
    func flipHorizontalViewContorller(_ viewController: UIViewController!, back: @escaping () -> Void) {
        showViewController(viewController, modalTransitionStyle: UIModalTransitionStyle.flipHorizontal, back: back)
    }

    //MARK: Cover vertical
    func coverVerticalViewContorller(_ viewController: UIViewController!, back: @escaping () -> Void) {
        showViewController(viewController, modalTransitionStyle: UIModalTransitionStyle.coverVertical, back: back)
    }

    //MARK : - Cross dissolve
    func crossDissolveViewContorller(_ viewController: UIViewController!, back: @escaping () -> Void) {
        showViewController(viewController, modalTransitionStyle: UIModalTransitionStyle.crossDissolve, back: back)
    }

    //MARK : - Partial curl
    func partialCurlViewContorller(_ viewController: UIViewController!, back: @escaping () -> Void) {
        showViewController(viewController, modalTransitionStyle: UIModalTransitionStyle.partialCurl, back: back)
    }

    //MARK : - Model transition
    func showViewController(_ viewController: UIViewController!, modalTransitionStyle: UIModalTransitionStyle, back: @escaping () -> Void) {
        viewController.modalTransitionStyle = modalTransitionStyle
        present(viewController, animated: true, completion: back)
    }
}
