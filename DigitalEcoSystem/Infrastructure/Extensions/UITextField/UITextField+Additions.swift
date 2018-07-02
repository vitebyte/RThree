//
//  UITextField+Additions.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 23/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import Foundation

extension UISearchBar {

    //MARK : - get elements of search bar
    private func getViewElement<T>(type _: T.Type) -> T? {

        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }

    //MARK : - get searchbar text
    func getSearchBarTextField() -> UITextField? {

        return getViewElement(type: UITextField.self)
    }

    //MARK : - set text color of searchbar
    func setTextColor(color: UIColor) {

        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }

    //MARK : - set text field coloe
    func setTextFieldColor(color: UIColor) {

        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6

            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }

    //MARK : - set placeholer color
    func setPlaceholderTextColor(color: UIColor) {

        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSForegroundColorAttributeName: color])
        }
    }

    /*   func setTextFieldClearButtonColor(color: UIColor) {

     if let textField = getSearchBarTextField() {

     let button = textField.value(forKey: "clearButton") as! UIButton
     if let image = button.imageView?.image {
     button.setImage(image.transform(withNewColor: color), for: .normal)
     }
     }
     }

     func setSearchImageColor(color: UIColor) {

     if let imageView = getSearchBarTextField()?.leftView as? UIImageView {
     imageView.image = imageView.image?.transform(withNewColor: color)
     }
     }
     */
}
