//
//  ChooseTrainerViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 06/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

let chooseTrainerTableViewAccessibilityID = "trainerTableView"
let associatesSearchBarID = "associatesSearchBar"

class ChooseTrainerViewController: BaseViewController {

    // MARK: - Variables
    public var chosenIndexPath: IndexPath?
    public var selectedTrainer: User?
    public var userArray: [User] = [User]()
    public var userMainArray: [User] = [User]()
    public var userDict = [String: [User]]()
    public var userSectionTitles = [String]()
    private var trainerSearchResults: [User] = [User]()
    private var filteredArray = [String]()
    private var shouldShowSearchResults = false
    public var sectionIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
    // Paging
    fileprivate var currentPageNumber: Int = 1
    fileprivate var totalPages: Int = 1
    fileprivate var isInProgress: Bool = false
    fileprivate var indicatorFooter = UIView()

    // MARK: - IBOutlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var trainerDesignationLabel: UILabel!
    @IBOutlet weak var trainerNameLabel: UILabel!
    @IBOutlet weak var trainerImageView: UIImageView!
    @IBOutlet weak var associatesSearchBar: UISearchBar!
    @IBOutlet weak var trainerTableView: UITableView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var navSubtitleLabel: UILabel!

    
    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        trainerTableView.accessibilityIdentifier = chooseTrainerTableViewAccessibilityID
        associatesSearchBar.accessibilityIdentifier = associatesSearchBarID
        doInitialSetup()
        // Paging
        getAssociatesList(currentPageNumber, isShowLoader: true)
        loadMorePages()
        associatesSearchBar.setPlaceholderTextColor(color: UIColor.black)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)

        handleLocalizeStrings()
    }

    override func leftButtonPressed(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: Navigation Bar View With Subtitle
    func setTitle(title: String, subtitle: String) -> UIView {
        navTitleLabel.attributedText = UILabel.addTextSpacing(textString: title, spaceValue: -0.2)
        navSubtitleLabel.attributedText = UILabel.addTextSpacing(textString: subtitle, spaceValue: 0.1)
        navTitleLabel.text = title
        navSubtitleLabel.text = subtitle
        return navigationView
    }

    func handleLocalizeStrings() {
        navigationItem.titleView = setTitle(title: LocalizedString.shared.chooseTrainerTitle, subtitle: LocalizedString.shared.chooseTrainerSubtitle)
        nextButton.setTitle(LocalizedString.shared.buttonNextTitle, for: .normal)
        associatesSearchBar.placeholder = LocalizedString.shared.searchAssociatesString
    }

    func dismissCurrentViewController(_: Bool) {
        _ = dismiss(animated: true, completion: nil)
    }

    func doInitialSetup() {
        // super.addWhiteBackBarButton()
        super.addLeftBarButton(withImageName: Constants.BarButtonItemImage.BackArrowWhiteColor)

        navigationItem.titleView = setTitle(title: LocalizedString.shared.trainerTitleString, subtitle: LocalizedString.shared.trainerSubtitleString)
        // self.associatesSearchBar.setTextFieldColor(color: UIColor.init(red: 234.0 / 255.0, green: 235.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0))

        createProfileDict()
        showCircularTrainerImageView()
        trainerTableView.tableFooterView = UIView()
    }

    func createProfileDict() {
        for userProfile in userArray {
            let userKey = userProfile.userName?.substring(to: (userProfile.userName?.index((userProfile.userName?.startIndex)!, offsetBy: 1))!)
            if var userValues = userDict[userKey!] {
                userValues.append(userProfile)
                userDict[userKey!] = userValues
            } else {
                userDict[userKey!] = [userProfile]
            }
        }
        userSectionTitles = [String](userDict.keys)
        userSectionTitles.sort()
    }

    func showCircularTrainerImageView() {
        trainerImageView.layoutIfNeeded()
        trainerImageView.layer.cornerRadius = trainerImageView.frame.size.width / 2
        trainerImageView.layer.masksToBounds = true
        trainerImageView.contentMode = .scaleAspectFill
    }

    // MARK: - Buttton Actions
    @IBAction func nextButtonAction(_: Any) {
        if selectedTrainer == nil {
            showAlertViewWithMessage(LocalizedString.shared.ERROR_TITLE, message: LocalizedString.shared.TRAINER_NOTSELECTED,true)
            return
        }

        let storyboard = UIStoryboard.associateTrainingStoryboard()
        let chooseTraineeViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ChooseTraineeIdentifier) as! ChooseTraineeViewController
        chooseTraineeViewController.selectedTrainer = selectedTrainer
        navigationController?.pushViewController(chooseTraineeViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChooseTrainerViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source

    func numberOfSections(in _: UITableView) -> Int {
        return userSectionTitles.count
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userSectionTitles[section]
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userKey = userSectionTitles[section]
        if let userVables = self.userDict[userKey] {
            return userVables.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainersCell", for: indexPath) as! TrainersCell

        cell.accessibilityIdentifier = "TrainersCell\(indexPath.row)"
        let userKey = userSectionTitles[indexPath.section]
        if let userValues: [User] = userDict[userKey] {
            let userEmp: User = userValues[indexPath.row]
            cell.trainerLabel.text = userEmp.userName
            let imagUrl: String = Constants.ImageUrl.SmallImage + userEmp.profileImg!
            cell.trainerImageView?.sd_setImage(with: URL(string: imagUrl), placeholderImage: UIImage(named: "defaultPic.png"))
        }
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = trainerTableView.cellForRow(at: indexPath) as! TrainersCell
        cell.trainerLabel.font = UIFont.gothamMedium(15)
        chosenIndexPath = indexPath
        let userKey = userSectionTitles[indexPath.section]
        if let userValues: [User] = userDict[userKey] {
            selectedTrainer = userValues[indexPath.row]
            trainerNameLabel.text = selectedTrainer?.userName
            trainerDesignationLabel.text = LocalizedString.shared.chooseTrainerDesignation
            //  trainerDesignationLabel.text = self.selectedTrainer?.roleId
            let imagUrl: String = Constants.ImageUrl.SmallImage + (selectedTrainer?.profileImg)!
            trainerImageView.sd_setImage(with: URL(string: imagUrl), placeholderImage: UIImage(named: "defaultPic.png"))
        }
    }

    func sectionIndexTitles(for _: UITableView) -> [String]? {
        return sectionIndexTitles
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 28
    }

    func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection _: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = UIColor.black
        headerView.textLabel?.font = UIFont.gothamMedium(15)
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 1.0, animations: { cell.alpha = 1 })
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 0.2, animations: { cell.layer.transform = CATransform3DIdentity })

        let userKey = userSectionTitles[indexPath.section]
        if let userValues: [User] = self.userDict[userKey] {
            let userEmp: User = userValues[indexPath.row]
            if selectedTrainer != nil && selectedTrainer?.userId == userEmp.userId {
                cell.setSelected(true, animated: false)
            }
        }
    }
}

//MARK: - UISearchBarDelegate, UISearchDisplayDelegate
extension ChooseTrainerViewController: UISearchBarDelegate, UISearchDisplayDelegate {

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        userDict.removeAll()
        userArray = userMainArray
        if (associatesSearchBar.text?.characters.count)! > 1 {
            let filteredData = userArray.filter {
                let string = $0.userName
                return (string?.localizedStandardContains(searchText))!
            }
            userArray = filteredData
        }
        createProfileDict()
        trainerTableView.reloadData()
    }
}

//MARK: - API Calls
extension ChooseTrainerViewController {

    func loadMorePages() {
        if associatesSearchBar.text?.characters.count == 0 {
            trainerTableView.addInfiniteScrolling {
                if !self.isInProgress && self.currentPageNumber <= self.totalPages {
                    self.currentPageNumber = self.currentPageNumber + 1
                    self.isInProgress = true
                    self.getAssociatesList(self.currentPageNumber, isShowLoader: false)
                } else {
                    if let _ = self.trainerTableView.infiniteScrollingView {
                        self.trainerTableView.infiniteScrollingView.stopAnimating()
                    }
                }
            }
        }
    }

    func getAssociatesList(_ pageNumber: Int, isShowLoader: Bool) {
        trainerTableView.tableFooterView = totalPages == currentPageNumber ? indicatorFooter : UIView()
        if isShowLoader {
            Helper.showLoader()
        }
        UserManager.shared.activeUser.getAssociatesList(1, pageNumber: pageNumber) { (success, _, resulrArray, _, pageCount) -> Void in
            self.isInProgress = false
            Helper.hideLoader()
            if let _ = self.trainerTableView.infiniteScrollingView {
                self.trainerTableView.infiniteScrollingView.stopAnimating()
            }
            if let _ = self.trainerTableView.pullToRefreshView {
                self.trainerTableView.pullToRefreshView.stopAnimating()
            }
            if success {
                if (resulrArray?.count)! > 0 {
                    for arrayObj in resulrArray! {
                        self.userArray.append(arrayObj)
                    }
                    self.userDict.removeAll()
                    self.userMainArray = self.userArray
                    self.createProfileDict()
                    self.trainerTableView.reloadData()
                }
                self.totalPages = pageCount
            }
        }
    }
}

/*
 extension UISearchBar {

 private func getViewElement<T>(type: T.Type) -> T? {

 let svs = subviews.flatMap { $0.subviews }
 guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
 return element
 }

 func getSearchBarTextField() -> UITextField? {

 return getViewElement(type: UITextField.self)
 }

 func setTextColor(color: UIColor) {

 if let textField = getSearchBarTextField() {
 textField.textColor = color
 }
 }

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

 func setPlaceholderTextColor(color: UIColor) {

 if let textField = getSearchBarTextField() {
 textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSForegroundColorAttributeName: color])
 }
 }

 func setTextFieldClearButtonColor(color: UIColor) {

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
 }
 */
