//
//  SelectModulesViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 14/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

let moduleTableViewAccessibilityID = "moduleTableView"

class SelectModulesViewController: BaseViewController {

    public var selectedTraineesArray: NSMutableArray = NSMutableArray()
    public var selectedTrainer: User?
    public var selectedItems = [Training]()
    public var itemsList: [Training] = [Training]()
    fileprivate var isHighLighted: Bool = false
    fileprivate var selectedRowsArray: NSMutableArray = NSMutableArray()
    // Paging
    fileprivate var trainingArray: NSMutableArray!
    fileprivate var currentPageNumber: Int = 1
    fileprivate var totalPages: Int = 1
    fileprivate var isInProgress: Bool = false
    fileprivate var isPullToRefresh: Bool = false
    fileprivate var indicatorFooter = UIView()

    // MARK: - IBOutlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var moduleTableView: UITableView!

    // MARK: - view life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        super.navigationBarAppearanceBlack(navController: navigationController!)

        super.addLeftBarButton(withImageName: Constants.BarButtonItemImage.BackArrowWhiteColor)

        moduleTableView.accessibilityIdentifier = moduleTableViewAccessibilityID
        moduleTableView.tableFooterView = UIView()
        getTrainingList(currentPageNumber, isShowLoader: true)
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)

        handleLocalizeStrings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - initial setup
    func handleLocalizeStrings() {
        //        super.setNavBarTitle(LocalizedString.shared.selectModulesTitleString)
        navigationItem.title = LocalizedString.shared.selectModulesTitleString
        nextButton.setTitle(LocalizedString.shared.buttonNextTitle, for: .normal)
    }
    
    // MARK: - Actions
    override func leftButtonPressed(_: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func nextButtonAction(_: UIButton) {
        if selectedItems.count == 0 {
            showAlertViewWithMessage(LocalizedString.shared.ERROR_TITLE, message: LocalizedString.shared.TRAINER_NOTSELECTED,true)
            return
        }

        let storyboard = UIStoryboard.associateTrainingStoryboard()
        let confirmAssigneeViewController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ConfirmAssigneeIdentifier) as! ConfirmAssigneeViewController
        confirmAssigneeViewController.selectedTrainer = selectedTrainer
        confirmAssigneeViewController.selectedTraineesArray = selectedTraineesArray
        confirmAssigneeViewController.selectedTrainingsArray = selectedItems

        navigationController?.pushViewController(confirmAssigneeViewController, animated: true)
    }

    // Pull to refresh
    func pullToRefresh() {
        moduleTableView.addPullToRefresh {
            self.currentPageNumber = 1
            self.isPullToRefresh = true
            self.getTrainingList(self.currentPageNumber, isShowLoader: false)
        }
    }

    // Pagination in listing
    func loadMorePages() {
        moduleTableView.addInfiniteScrolling {
            if !self.isInProgress && self.currentPageNumber <= self.totalPages {
                self.currentPageNumber = self.currentPageNumber + 1
                self.isInProgress = true
                self.getTrainingList(self.currentPageNumber, isShowLoader: false)
            } else {
                if let _ = self.moduleTableView.infiniteScrollingView {
                    self.moduleTableView.infiniteScrollingView.stopAnimating()
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate, SelectModulesCellDelegate
extension SelectModulesViewController: UITableViewDataSource, UITableViewDelegate, SelectModulesCellDelegate {
    // MARK: - Table view data source

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectModules", for: indexPath) as! SelectModulesCell
        cell.accessibilityIdentifier = "SelectModules\(indexPath.row)"
        cell.delegate = self
        cell.idxPath = indexPath
        let trainingData = itemsList[indexPath.row]
        cell.setData(training: trainingData, atIndexPath: indexPath)
        cell.selectButton.isSelected = false
        if selectedItems.contains(itemsList[indexPath.row]) {
            cell.selectButton.isSelected = true
        }
        return cell
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 1.0, animations: { cell.alpha = 1 })
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 0.2, animations: { cell.layer.transform = CATransform3DIdentity })
    }

    func cellButtonTapped(cell: SelectModulesCell) {
        //        let obj = model[cell.idxPath?.row]
        _ = itemsList[(cell.idxPath?.row)!]

        if let button = cell.selectButton {
            if button.isSelected {
                // set selected
                button.isSelected = false
            } else {
                // set deselected
                button.isSelected = true
            }
        }

        let indexPath = moduleTableView.indexPathForRow(at: cell.center)!
        let selectedItem = itemsList[indexPath.row] as Training

        if let selectedItemIndex = (selectedItems as Array).index(of: selectedItem) {
            selectedItems.remove(at: selectedItemIndex)
        } else {
            selectedItems.append(selectedItem)
        }
        let count = selectedItems.count

        let textAttributes = [NSForegroundColorAttributeName: UIColor.init(white: 1.0, alpha: 0.7), NSFontAttributeName: UIFont.gothamBook(14.0)]
        let countAttributes = [NSForegroundColorAttributeName: UIColor.init(white: 1.0, alpha: 1.0), NSFontAttributeName: UIFont.gothamBook(14.0)]
        let countString = NSMutableAttributedString(string: String(count), attributes: countAttributes)
        let textString = NSMutableAttributedString(string: LocalizedString.shared.selectedTitleString, attributes: textAttributes)

        let combination = NSMutableAttributedString()
        combination.append(countString)
        combination.append(textString)
        selectedLabel.attributedText = combination
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 112
    }
}

// MARK: - API calls
extension SelectModulesViewController {

    func getTrainingList(_ pageNumber: Int, isShowLoader: Bool) {
        moduleTableView.tableFooterView = totalPages == currentPageNumber ? indicatorFooter : UIView()
        if isShowLoader {
            Helper.showLoader()
        }
        Training.loadTrainings(0, subcategoryId: 0, pageNumber: pageNumber) { (success, _, resulrArray, _, pageCount) -> Void in
            self.isInProgress = false
            Helper.hideLoader()
            if let _ = self.moduleTableView.infiniteScrollingView {
                self.moduleTableView.infiniteScrollingView.stopAnimating()
            }
            if let _ = self.moduleTableView.pullToRefreshView {
                self.moduleTableView.pullToRefreshView.stopAnimating()
            }
            if success {
                if self.isPullToRefresh && self.itemsList.count > 0 {
                    self.itemsList.removeAll()
                }
                if (resulrArray?.count)! > 0 {
                    for arrayObj in resulrArray! {
                        // self.itemsList.add(arrayObj)
                        self.itemsList.append(arrayObj)
                    }
                    self.moduleTableView.reloadData()
                }
                self.totalPages = pageCount
            } else {
            }
            self.isPullToRefresh = false
        }
    }
}
