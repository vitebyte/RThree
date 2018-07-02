//
//  UITextView+Additions.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 29/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import Foundation

extension UITextView {

    //MARK : - convert to textview data from html string
    func from(htmlString: String) {
        let html = "<div style='font-size:15px; font-family:Gotham-Light; text-align:center' >\(htmlString)</div>"
        if let htmlData = html.data(using: String.Encoding.unicode, allowLossyConversion: true) {
            do {
                attributedText = try NSAttributedString(data: htmlData,
                                                        options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                        documentAttributes: nil)
            } catch _ as NSError {
                 LogManager.logError(" Error in UITextView from(htmlString: String)")
            }
        }
    }
}
