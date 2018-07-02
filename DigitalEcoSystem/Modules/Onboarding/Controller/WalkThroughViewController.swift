//
//  WalkThroughViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 16/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIViewController {

    // MARK: - Variables
    public var walkThroughArray: NSMutableArray? = NSMutableArray()
    public var isPresentingSelf = false

    /// MARK: - Constants
    public let keyHeader: String = "header"
    public let keyDesc: String = "description"
    public let keyImage: String = "image"
    public var isPageControlTapped: Bool = false

    // MARK: - Define bounds
    public var currentIndex: Int = 0
    private let maxLimit = 3
    private let minLimit = 0

    // MARK: - IBOutlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var walkThroughCollectionView: UICollectionView!

    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        doInitialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.isStatusBarHidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        handleLocalizeStrings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        UIApplication.shared.isStatusBarHidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - video player
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: - Helper Methods
    func doInitialSetup() {
        backButton.isHidden = true
        walkThroughArray = NSMutableArray()
        walkThroughArray?.add([
            self.keyHeader: LocalizedString.shared.headerTitle,
            self.keyDesc: LocalizedString.shared.descriptionText,
            self.keyImage: "Walkthrough_01",
        ])

        walkThroughArray?.add([
            self.keyHeader: LocalizedString.shared.headerTitle,
            self.keyDesc: LocalizedString.shared.descriptionText,
            self.keyImage: "Walkthrough_02",
        ])

        walkThroughArray?.add([
            self.keyHeader: LocalizedString.shared.headerTitle,
            self.keyDesc: LocalizedString.shared.descriptionText,
            self.keyImage: "Walkthrough_03",
        ])

        pageControl.numberOfPages = (walkThroughArray?.count)!
        walkThroughCollectionView.reloadData()
    }

    func handleLocalizeStrings() {
        if isPresentingSelf {
            nextButton.setTitle(LocalizedString.shared.buttonReturnTitle, for: .normal)
        } else {
            nextButton.setTitle(LocalizedString.shared.buttonNextTitle, for: .normal)
        }
    }

    // MARK: - Navigation
    func moveToChooseLanguageViewotroller() {
        let storyBoard: UIStoryboard = UIStoryboard.mainStoryboard()
        let chooseLanguageViewController = storyBoard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ChooseLanguageIdentifier) as! ChooseLanguageViewController
        navigationController?.pushViewController(chooseLanguageViewController, animated: true)
    }

    // MARK: - Button Actions
    @IBAction func nextButtonAction(_: Any) {
        isPageControlTapped = false
        if currentIndex == 2 {
            moveToChooseLanguageViewotroller()
        } else {
            currentIndex += 1
            if currentIndex > 2 {
                currentIndex = 2
            }
            walkThroughCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .right, animated: true)
        }
    }

    @IBAction func backButtonAction(_: Any) {
        isPageControlTapped = false
        _ = navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension WalkThroughViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: CollectionView DataSource Methods
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return walkThroughArray!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let strCellId: String = "walkthroughCell"

        let cell: WalkThroughCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: strCellId, for: indexPath) as! WalkThroughCollectionViewCell
        let dict: NSDictionary? = walkThroughArray?.object(at: indexPath.row) as? NSDictionary
        cell.titleLabel.text = dict![keyHeader] as? String
        cell.descriptionLabel.text = dict![keyDesc] as? String
        cell.titleLabel.attributedText = UILabel.addTextSpacing(textString: (dict![keyHeader] as? String)!, spaceValue: 0.5)
        cell.descriptionLabel.attributedText = UILabel.addTextSpacing(textString: (dict![keyDesc] as? String!)!, spaceValue: 0.5)
        cell.titleLabel.attributedText = UILabel.setTextWithLineSpacing(text: (dict![keyHeader] as? String)!, lineSpacing: 5)
        cell.titleLabel.textAlignment = .center
        cell.descriptionLabel.attributedText = UILabel.setTextWithLineSpacing(text: (dict![keyDesc] as? String!)!, lineSpacing: 5)
        cell.descriptionLabel.textAlignment = .center
        cell.descriptionLabel.numberOfLines = 0
        cell.contentView.frame = cell.bounds
        cell.descriptionLabel.sizeToFit()
        cell.walkthroughImage.image = UIImage(named: dict![keyImage] as! String)
        return cell
    }

    // MARK: CollectionView Delegate Methods

    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return walkThroughCollectionView.frame.size
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 0.0
    }

}

// MARK: ScrollView Delegate Methods
extension WalkThroughViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_: UIScrollView) {
        view.isUserInteractionEnabled = false
        let pageWidth = walkThroughCollectionView.frame.size.width
        currentIndex = Int(floor((walkThroughCollectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        if currentIndex < 0 {
            currentIndex = 0
        }
        if currentIndex > 2 {
            currentIndex = 2
        }
        pageControl.currentPage = currentIndex
        view.isUserInteractionEnabled = true
    }
}
