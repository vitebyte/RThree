//
//  ProfilePicViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 16/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit
import MobileCoreServices

class ProfilePicViewController: BaseViewController {

    // MARK: File Handling
    private let profileImagePicker = UIImagePickerController()
    private let KUserImageNameInDocumentDirectory = "userImage.png"
    public var isPresentingSelf = false

    // MARK: IBOutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var useCameraButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!

    var profilePicUpdateBannerTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if isPresentingSelf {
            // super.addCloseOnNavBar()
            super.addLeftBarButton(withImageName: Constants.BarButtonItemImage.closeBlackColor)
        } else {
            // super.addBlackBackBarButton()
            super.addLeftBarButton(withImageName: Constants.BarButtonItemImage.BackArrowBlackColor)
        }

        // setup view
        doInitialSetup()

        // set localized titles
        profilePicUpdateBannerTitle = LocalizedString.shared.profilePicBannerText + "\(UserManager.shared.activeUser.userName!)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleLocalizeStrings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }

    override func leftButtonPressed(_: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    // MARK: - Helper Methods
    func doInitialSetup() {
        profileImagePicker.delegate = self
        showCircularProfileImageView()
        setButtonApperence(useCameraButton)
        setButtonApperence(takePhotoButton)

        if let imageUrl = UserManager.shared.activeUser.profileImg {
            let imageProfileUrl: String = Constants.ImageUrl.SmallImage + imageUrl
            profileImageView.sd_setShowActivityIndicatorView(true)
            profileImageView.sd_setIndicatorStyle(.gray)
            profileImageView.sd_setImage(with: URL(string: imageProfileUrl), placeholderImage: UIImage(named: "defaultPic"), options: .retryFailed, completed: { _, _, _, _ in
                self.profileImageView.sd_setShowActivityIndicatorView(false)
            })
        }
    }

    func setButtonApperence(_ button: UIButton) {
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.shadowRadius = 12.0
        button.layer.shadowColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
    }

    func handleLocalizeStrings() {
        takePhotoButton.setTitle(LocalizedString.shared.buttonTakePhotoTitle, for: .normal)
        useCameraButton.setTitle(LocalizedString.shared.buttonUseCameraTitle, for: .normal)

        if isPresentingSelf {
            finishButton.setTitle(LocalizedString.shared.buttonPresentedTitle, for: .normal)
        } else {
            finishButton.setTitle(LocalizedString.shared.doneString, for: .normal)
        }
        navigationItem.title = LocalizedString.shared.profileTitleString
    }

    func showCircularProfileImageView() {
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
    }

    func noCamera() {
        let alertVC = UIAlertController(title: LocalizedString.shared.buttonNoCameraTitle,
                                        message: LocalizedString.shared.cameraDesc,
                                        preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizedString.shared.buttonConfirmTitle,
                                     style: .default,
                                     handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }

    func moveToTabBar() {
        AppDelegate.presentRootViewController()
    }

    // MARK: - Showing Banner
    func showBanner(_ titelString: String) {
        let banner = Banner(title: titelString, subtitle: "", image: UIImage(named: "check"), backgroundColor: UIColor.colorWithRedValue(21.0, greenValue: 160.0, blueValue: 94.0, alpha: 1.0))
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }

    // MARK: - Button Actions
    @IBAction func finishButtonAction(_: Any) {
        if isPresentingSelf {
            dismiss(animated: true, completion: nil)
        } else {
            moveToTabBar()
        }
    }

    @IBAction func takePhotoAction(_: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            profileImagePicker.allowsEditing = false
            profileImagePicker.sourceType = UIImagePickerControllerSourceType.camera
            profileImagePicker.cameraCaptureMode = .photo
            profileImagePicker.cameraDevice = .front
            profileImagePicker.modalPresentationStyle = .fullScreen
            present(profileImagePicker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }

    @IBAction func useCameraRollAction(_: Any) {
        profileImagePicker.allowsEditing = false
        profileImagePicker.sourceType = .photoLibrary
        profileImagePicker.modalPresentationStyle = .popover
        profileImagePicker.mediaTypes = [kUTTypeImage as String]
        present(profileImagePicker, animated: true, completion: nil)
    }
}

// MARK: - ImagePicker Delegate
extension ProfilePicViewController {
  
    func imagePickerController(_: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        let chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.image = chosenImage
        dismiss(animated: true, completion: nil)

        self.uploadProfilePic(profileImageView.image)
    }

    override func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Data Service

    func uploadProfilePic(_ image: UIImage?) {
        if let profilePic: UIImage = image {
            UserManager.shared.activeUser.performUploadProfilePictureWithImage(image: profilePic, completionHandler: { (success, _) -> Void in
                if success {
                    self.showBanner(self.profilePicUpdateBannerTitle)

                } else {
                    super.showAlertViewWithMessage(LocalizedString.shared.IMAGE_FAILURE_DESC, message: LocalizedString.shared.PROFILE_PIC_UNABLE_TO_UPDATE,true)
                }
            })
        }
    }
}
