//
//  UIButton+Additions.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 05/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import Foundation

extension UIButton {
    //MARK : - set button title and subtitle
    func setTitleAndSubtitle(title: String, subTitle: String) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byWordWrapping

        let font1 = UIFont.gothamBook(14)
        let font2 = UIFont.gothamLight(12)

        let dict1: [String: Any] = [
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue, // NSUnderlineStyle.styleSingle.rawValue,
            NSFontAttributeName: font1,
            NSParagraphStyleAttributeName: style,
        ]

        let dict2: [String: Any] = [
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue,
            NSFontAttributeName: font2,
            NSParagraphStyleAttributeName: style,
        ]

        let attString = NSMutableAttributedString()
        attString.append(NSAttributedString(string: title + "\n", attributes: dict1))
        attString.append(NSAttributedString(string: subTitle, attributes: dict2))
        setAttributedTitle(attString, for: UIControlState.normal)
    }

    //set button backgroundcolor
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: forState)
    }

    // to set data
    //    button.setAttributedTitle(attString, for: .normal)
    //    button.titleLabel?.numberOfLines = 0
    //    button.titleLabel?.lineBreakMode = .byWordWrapping
}
