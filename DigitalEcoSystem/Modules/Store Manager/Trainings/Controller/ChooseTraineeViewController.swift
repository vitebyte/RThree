//
//  ChooseTraineeViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 06/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

let traineeTableViewAccessibilityID = "traineeTableView"
let traineeSearchBarID = "traineeSearchBar"

class ChooseTraineeViewController: BaseViewController {
    // Paging
    //MARK: - variables
    fileprivate var currentPageNumber: Int = 1
    fileprivate var totalPages: Int = 1
    fileprivate var isInProgress: Bool = false
    fileprivate var indicatorFooter = UIView()

    fileprivate var chosenIndexPath: IndexPath?
    public var selectedTrainer: User?
    public var userArray: [User] = [User]()
    public var userMainArray: [User] = [User]()
    public var newUserDict = [String: [User]]()
    public var userSectionTitles = [String]()
    fileprivate var selectedRowsArray: NSMutableArray = NSMutableArray()
    public var sectionIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]

    // MARK: - IBOutlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var selectedNoLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var traineeSearchBar: UISearchBar!
    @IBOutlet weak var traineeTableView: UITableView!
    @IBOutlet var navigationView: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var navigationSubtitleLabel: UILabel!

    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        traineeTableView.accessibilityIdentifier = traineeTableViewAccessibilityID
        traineeSearchBar.accessibilityIdentifier = traineeSearchBarID
        doInitialSetup()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)

        handleLocalizeStrings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func doInitialSetup() {
        // super.addWhiteBackBarButton()
        super.addLeftBarButton(withImageName: Constants.BarButtonItemImage.BackArrowWhiteColor)

        newUserDict.removeAll()
        createProfileDict()
        deleteSelectedUserfromDictionary(user: selectedTrainer!)

        userMainArray = userArray
        traineeTableView.tableFooterView = UIView()
        userSectionTitles = [String](newUserDict.keys)

        userSectionTitles.sort()
        getAssociatesList(currentPageNumber, isShowLoader: true)
        loadMorePages()
    }

    func createProfileDict() {
        for userProfile in userArray {
            let userKey = userProfile.userName?.substring(to: (userProfile.userName?.index((userProfile.userName?.startIndex)!, offsetBy: 1))!)
            if var userValues = newUserDict[userKey!] {
                userValues.append(userProfile)
                newUserDict[userKey!] = userValues
            } else {
                newUserDict[userKey!] = [userProfile]
            }
        }
        userSectionTitles = [String](newUserDict.keys)
        userSectionTitles.sort()
    }

    func handleLocalizeStrings() {
        navigationItem.titleView = setTitle(title: LocalizedString.shared.traineeTitleString, subtitle: LocalizedString.shared.traineeSubtitleString)
        nextButton.setTitle(LocalizedString.shared.buttonNextTitle, for: .normal)
        traineeSearchBar.placeholder = LocalizedString.shared.searchAssociatesString
    }

    func deleteSelectedUserfromDictionary(user: User) {
        let userKey = user.userName?.substring(to: (user.userName?.index((user.userName?.startIndex)!, offsetBy: 1))!)

        // let userKey:String = "\(user.userName?.characters.first!)"
        if var userValues: [User] = self.newUserDict[userKey!] {
            userValues = userValues.filter { $0.userId != user.userId }
            if userValues.count > 0 {
                newUserDict[userKey!] = userValues
            } else {
                newUserDict.removeValue(forKey: userKey!)
            }
        }
        userArray = userArray.filter({ $0.userId != user.userId })
        traineeTableView.reloadData()
    }

    func deleteSelectedUserFromArray(user: User) -> [User] {
        userArray = userArray.filter { $0.userId != user.userId }
        return userArray
    }

    func updateSelectedUserArrayWith(selectedUser: User, toAppend: Bool) {
        if toAppend == true && !selectedRowsArray.contains(selectedUser) {
            selectedRowsArray.add(selectedUser)
        } else if selectedRowsArray.contains(selectedUser) {
            selectedRowsArray.remove(selectedUser)
        }
        let count = selectedRowsArray.count
        self.updateLabel(count)
    }

    func updateLabel(_ count: Int) {
        let textAttributes = [NSForegroundColorAttributeName: UIColor.init(white: 1, alpha: 0.7), NSFontAttributeName: UIFont.gothamBook(14.0)]
        let countAttributes = [NSForegroundColorAttributeName: UIColor.init(white: 1, alpha: 1.0), NSFontAttributeName: UIFont.gothamBook(14.0)]
        let countString = NSMutableAttributedString(string: String(count), attributes: countAttributes)
        let textString = NSMutableAttributedString(string: LocalizedString.shared.selectedTitleString, attributes: textAttributes)

        let combination = NSMutableAttributedString()
        combination.append(countString)
        combination.append(textString)

        selectedNoLabel.attributedText = combination
    }

    // MARK: Navigation Bar View With Subtitle
    func setTitle(title atitle: String, subtitle aSubtitle: String) -> UIView {
        navigationTitleLabel.attributedText = UILabel.addTextSpacing(textString: navigationTitleLabel.text!, spaceValue: -0.2)
        navigationSubtitleLabel.attributedText = UILabel.addTextSpacing(textString: navigationSubtitleLabel.text!, spaceValue: 0.1)
        navigationTitleLabel.text = atitle
        navigationSubtitleLabel.text = aSubtitle
        return navigationView
    }

    // MARK: - Buttton Actions
    override func leftButtonPressed(_: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_: Any) {
        if selectedRowsArray.count == 0 {
            showAlertViewWithMessage(LocalizedString.shared.ERROR_TITLE, message: LocalizedString.shared.TRAINEE_NOTSELECTED,true)
            return
        }

        let storyboard = UIStoryboard.associateTrainingStoryboard()
        let selectModulesViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.SelectModulesIdentifier) as! SelectModulesViewController
        selectModulesViewController.selectedTrainer = selectedTrainer
        selectModulesViewController.selectedTraineesArray = selectedRowsArray
        navigationController?.pushViewController(selectModulesViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChooseTraineeViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source

    func numberOfSections(in _: UITableView) -> Int {
        return userSectionTitles.count
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return userSectionTitles[section]
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userKey = userSectionTitles[section]
        if let userVables = self.newUserDict[userKey] {
            return userVables.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TraineesCell", for: indexPath) as! TrainersCell

        cell.accessibilityIdentifier = "TraineesCell\(indexPath.row)"
        let userKey = userSectionTitles[indexPath.section]
        if let userValues: [User] = self.newUserDict[userKey] {
            let userEmp: User = userValues[indexPath.row]

            cell.trainerLabel.text = userEmp.userName
            let imagUrl: String = Constants.ImageUrl.SmallImage + userEmp.profileImg!
            cell.trainerImageView?.sd_setImage(with: URL(string: imagUrl), placeholderImage: UIImage(named: "defaultPic.png"))
        }
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = traineeTableView.cellForRow(at: indexPath) as! TrainersCell
        cell.trainerLabel.font = UIFont.gothamMedium(15)
        let userKey = userSectionTitles[indexPath.section]
        let userValues = newUserDict[userKey]
        let selectedUser: User = (userValues?[indexPath.row])!
        updateSelectedUserArrayWith(selectedUser: selectedUser, toAppend: true)
    }

    func tableView(_: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = traineeTableView.cellForRow(at: indexPath) as! TrainersCell
        cell.trainerLabel.font = UIFont.gothamMedium(15)
        let userKey = userSectionTitles[indexPath.section]
        let userValues = newUserDict[userKey]
        let selectedUser: User = (userValues?[indexPath.row])!
        updateSelectedUserArrayWith(selectedUser: selectedUser, toAppend: false)
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

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 1.0, animations: { cell.alpha = 1 })
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 0.2, animations: { cell.layer.transform = CATransform3DIdentity })
    }
}

// MARK: - UISearchBarDelegate, UISearchDisplayDelegate
extension ChooseTraineeViewController: UISearchBarDelegate, UISearchDisplayDelegate {

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        newUserDict.removeAll()
        userArray = userMainArray
        if (traineeSearchBar.text?.characters.count)! > 0 {
            let filteredData = userArray.filter {
                let string = $0.userName
                return (string?.localizedStandardContains(searchText))!
            }
            userArray = filteredData
        }
        createProfileDict()
        traineeTableView.reloadData()
    }
}

// MARK: - API Calls
extension ChooseTraineeViewController {

    func getAssociatesList(_ pageNumber: Int, isShowLoader: Bool) {
        traineeTableView.tableFooterView = totalPages == currentPageNumber ? indicatorFooter : UIView()
        if isShowLoader {
            Helper.showLoader()
        }
        UserManager.shared.activeUser.getAssociatesList(1, pageNumber: pageNumber) { (success, _, resulrArray, _, pageCount) -> Void in
            self.isInProgress = false
            Helper.hideLoader()
            if let _ = self.traineeTableView.infiniteScrollingView {
                self.traineeTableView.infiniteScrollingView.stopAnimating()
            }
            if let _ = self.traineeTableView.pullToRefreshView {
                self.traineeTableView.pullToRefreshView.stopAnimating()
            }
            if success {
                if (resulrArray?.count)! > 0 {
                    for arrayObj in resulrArray! {
                        self.userArray.append(arrayObj)
                    }
                    self.selectedRowsArray.removeAllObjects()
                    self.updateLabel(self.selectedRowsArray.count)
                    self.newUserDict.removeAll()
                    self.userArray = self.deleteSelectedUserFromArray(user: self.selectedTrainer!)
                    self.userMainArray = self.userArray
                    self.createProfileDict()
                    self.traineeTableView.reloadData()
                }
                self.totalPages = pageCount
            }
        }
    }

    // Pagination in listing
    func loadMorePages() {
        if traineeSearchBar.text?.characters.count == 0 {
            traineeTableView.addInfiniteScrolling {
                if !self.isInProgress && self.currentPageNumber <= self.totalPages {
                    self.currentPageNumber = self.currentPageNumber + 1
                    self.isInProgress = true
                    self.getAssociatesList(self.currentPageNumber, isShowLoader: false)
                } else {
                    if let _ = self.traineeTableView.infiniteScrollingView {
                        self.traineeTableView.infiniteScrollingView.stopAnimating()
                    }
                }
            }
        }
    }
}
