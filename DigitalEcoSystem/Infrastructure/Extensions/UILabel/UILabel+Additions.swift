//
//  UILabel+Additions.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 28/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import Foundation

extension UILabel {

    //MARK : - convert to label from html string
    func from(htmlString: String) {
        let html = "<div style='font-size:15px; font-family:Gotham-Light; text-align:center' >\(htmlString)</div>"
        if let htmlData = html.data(using: String.Encoding.unicode) {
            do {
                attributedText = try NSAttributedString(data: htmlData,
                                                        options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                        documentAttributes: nil)
            } catch let e as NSError {
            }
        }
    }

    //MARK : - add spacing between text
    class func addTextSpacing(textString: String, spaceValue: CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: textString)
        attributedString.addAttribute(NSKernAttributeName, value: spaceValue, range: NSRange(location: 0, length: textString.characters.count))
        return attributedString
    }

    // Usage: setTextWithLineSpacing(text:"Hello",lineSpacing:19)
    class func setTextWithLineSpacing(text: String, lineSpacing: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attrString.length))

        return attrString
    }
    
    
    
    class func addImage(imageName: String, textString: String) -> NSMutableAttributedString
    {
        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        
        let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
        let myString:NSMutableAttributedString = NSMutableAttributedString(string: textString)
        myString.append(attachmentString)
        
       return myString
    }
}
