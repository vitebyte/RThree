//
//  UIViewController+UIImagePickerController.swift
//
//  Created by Shafi Ahmed on 19/05/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import MobileCoreServices

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /**
     An IBAction which opens UIImagePickerController. You just need to connect it to a UIButton in your User Interface. all the hassel will be handled on by its own. you can also call this function programatically of course

     - parameter sender: UIButton in user interface which will fire this action
     */
    @IBAction func openImagePickerController(_ sender: UIButton) {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == AVAuthorizationStatus.denied {
            let alertController = UIAlertController(title: NSLocalizedString("You do not have permissions enabled for this.", comment: "You do not have permissions enabled for this."), message: NSLocalizedString("Would you like to change them in settings?", comment: "Would you like to change them in settings?"), preferredStyle: .alert)
            let okAction = UIAlertAction(title: LocalizedString.shared.buttonConfirmTitle, style: .default, handler: { (_) -> Void in
                guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
                UIApplication.shared.openURL(url)
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)

            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            presentAlert(alertController)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("Where would you like to get photos from?", comment: "Where would you like to get photos from?"), message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            alertController.popoverPresentationController?.sourceRect = sender.bounds
            alertController.popoverPresentationController?.sourceView = sender
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
            presentAlert(alertController)

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = [kUTTypeImage as String]
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = UIModalPresentationStyle.popover
            imagePickerController.popoverPresentationController?.sourceView = sender
            imagePickerController.popoverPresentationController?.sourceRect = sender.bounds

            let camera = UIAlertAction(title: NSLocalizedString("Take a Photo", comment: "Take a Photo"), style: .default) { (_) -> Void in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }

            let photoLibrary = UIAlertAction(title: NSLocalizedString("Choose from Library", comment: "Choose from Library"), style: .default) { (_) -> Void in

                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }

            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                alertController.addAction(camera)
            }
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                alertController.addAction(photoLibrary)
            }
            alertController.addAction(cancelAction)
        }
    }

    //MARK : - Alert present
    fileprivate func presentAlert(_ sender: UIAlertController) {
        present(sender, animated: true, completion: nil)
    }

    //MARK : - Cancel action
    public func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
