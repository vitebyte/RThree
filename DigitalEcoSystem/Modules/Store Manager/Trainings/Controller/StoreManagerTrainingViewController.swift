//
//  StoreManagerTrainingViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 05/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit
import Popover

let trainerTableViewAccessibilityID = "trainerTableView"
let associateTableViewAccessibilityID = "associateTableView"
let segmentControlID = "segmentControl"

class StoreManagerTrainingViewController: BaseViewController, FilterViewDelegate {
    // let options = [.animationIn(0.1)] as [PopoverOption]

    //MARK : - Variables
    fileprivate var associateArray: [User] = [User]()

    public var trainerArray: [User] = [User]()
    var isShowingAssociates: Bool = false
    // Paging
    fileprivate var currentPageNumber: Int = 1
    fileprivate var totalPages: Int = 1
    fileprivate var isInProgress: Bool = false
    fileprivate var isPullToRefresh: Bool = false
    fileprivate var indicatorFooter = UIView()
    fileprivate var selectedTrainer: User?

    fileprivate var currentPageNumberFilter: Int = 1
    fileprivate var totalPagesFilter: Int = 1
    fileprivate var isInProgressFilter: Bool = false
    fileprivate var isPullToRefreshFilter: Bool = false
    fileprivate var indicatorFooterFilter = UIView()
    // Filter
    fileprivate var popover = Popover(options: [.animationIn(0.001), .animationOut(0.001)] as [PopoverOption], showHandler: nil, dismissHandler: nil)
    fileprivate var isApplyFilter: Bool = false
    fileprivate var categoryList: [Category]? = [Category]()
    fileprivate var selectedCategoryId: Int = -1
    fileprivate var selectedSubCategoryId: Int = -1
    fileprivate var filterAssociateTrainee: [Trainee]? = [Trainee]()

    // MARK: - IBOutlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var categoriesButtonView: UIView!
    @IBOutlet weak var categoriesButton: UIButton!
    @IBOutlet weak var associateTableView: UITableView!
    @IBOutlet weak var trainerTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyHeaderTitleLabel: UILabel!
    @IBOutlet weak var emptyDescLabel: UILabel!
    @IBOutlet weak var segmentControlView: UIView!
    @IBOutlet weak var filtersView: UIView!

    //MARK : - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        doInitialSetup()

        // managing Segment
        segmentControlView.layer.zPosition = 1
        segmentControl.selectedSegmentIndex = 0
        segmentControlTapped(segmentControl)

        // managing localization on EmptyView
        emptyHeaderTitleLabel.text = LocalizedString.shared.emptyViewTitle
        emptyDescLabel.text = LocalizedString.shared.emptyViewDesc
        emptyView.isHidden = true
        categoriesButtonView.isHidden = false
        categoriesButton.setTitle(LocalizedString.shared.categoriesButtonString, for: .normal)
        categoriesButton.titleLabel?.numberOfLines = 0

        // managing footer view
        associateTableView.tableFooterView = UIView()
        trainerTableView.tableFooterView = UIView()

        associateTableView.accessibilityIdentifier = associateTableViewAccessibilityID
        trainerTableView.accessibilityIdentifier = trainerTableViewAccessibilityID
        segmentControl.accessibilityIdentifier = segmentControlID
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)

        // Managing  Paging and Pull to refresh
        if segmentControl.selectedSegmentIndex == 1 {
            defaultPagingValue()
            if trainerArray.count > 0 {
                trainerArray.removeAll()
            }
            getTrainerList()
            loadMorePagesForTrainers()
        } else if segmentControl.selectedSegmentIndex == 0 {
            defaultPagingValue()
            if associateArray.count > 0 {
                associateArray.removeAll()
            }
            getAssociateList()
            loadMorePagesForAssociates()
        }

        pullToRefresh()
        handleLocalizeStrings()
    }

    override func leftButtonPressed(_: UIButton) {
        moveToChooseTrainer()
    }

    // MARK: - Helper Methods
    func doInitialSetup() {
        // super.addMoreLeftBarButton()
        super.setNavBarTitle(LocalizedString.shared.trainingTitleString)

        super.navigationBarAppearanceBlack(navController: navigationController!)
        super.addLeftBarButton(withImageName: Constants.BarButtonItemImage.AddWhiteColor)
        super.addRightBarButton(withImageName: Constants.BarButtonItemImage.MoreWhiteColor)

        trainerTableView.tableFooterView = UIView()
    }

    // MARK: - Selected segment seleted
    func getTrainerList() {
        if segmentControl.selectedSegmentIndex == 1 {
            if trainerArray.count > 0 {
                trainerArray.removeAll()
            }
            getTrainerList(currentPageNumber, isShowLoader: true)
            trainerTableView.reloadData()
        }
    }

    func getAssociateList() {
        if segmentControl.selectedSegmentIndex == 0 {
            if associateArray.count > 0 {
                associateArray.removeAll()
            }
            getAssociatesList(currentPageNumber, isShowLoader: true)
            associateTableView.reloadData()
        }
    }

    func handleLocalizeStrings() {
        segmentControl.setTitle(LocalizedString.shared.associateString, forSegmentAt: 0)
        segmentControl.setTitle(LocalizedString.shared.trainerString, forSegmentAt: 1)
    }

    func defaultPagingValue() {
        currentPageNumber = 1
        totalPages = 1
        isInProgress = false
        isPullToRefresh = false
    }

    func pullToRefresh() {
        
        // Set filter button default
        self.defaultFilterButton()

        trainerTableView.addPullToRefresh {
            self.currentPageNumber = 1
            self.isPullToRefresh = true
            self.getTrainerList(self.currentPageNumber, isShowLoader: false)
        }
    }

    func moveToAssociateOverviewController() {
        let storyBoard: UIStoryboard = UIStoryboard.associateTrainingStoryboard()
        let associateOverviewViewController = storyBoard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.associateOverviewIdentifier) as! AssociateOverviewViewController
        associateOverviewViewController.selectedAssociate = selectedTrainer
        navigationController?.pushViewController(associateOverviewViewController, animated: true)
    }

    // MARK: - FilterViewDelegate
    // FilterViewDelegate - Popoverview delegate
    func applyButtonTapped(_ categoryId: Int, _ subCategoryId: Int) {
        print("Selected cat and subcat : \(categoryId), \(subCategoryId)")
        selectedCategoryId = categoryId
        selectedSubCategoryId = subCategoryId
        popover.dismiss()

        currentPageNumberFilter = 1

        if selectedCategoryId > -1 {
            let categoryObj: Category = categoryList![self.selectedCategoryId]
            let categoryName = categoryObj.catName

            var subCategoryId = 0
            var subCategoryName = ""
            if selectedSubCategoryId > -1 {
                let subCategories = categoryObj.subCatList
                subCategoryName = (subCategories?[self.selectedSubCategoryId].subCatName)!
                subCategoryId = (subCategories?[self.selectedSubCategoryId].subCatId)!
            }

            if (filterAssociateTrainee?.count)! > 0 {
                filterAssociateTrainee?.removeAll()
                associateTableView.reloadData()
            }
            setCategoryButton(title: categoryName!, andSubTitle: subCategoryName)
            getFilteredAssociateList(categoryObj.catId!, subCategoryId: subCategoryId, pageNumber: currentPageNumberFilter, isShowLoader: true)
        }
    }

    func defaultButtonTapped() {

        // Reset default
        defaultFilterButton()

        // Remove all data from table
        if (filterAssociateTrainee?.count)! > 0 {
            filterAssociateTrainee?.removeAll()
        }
        if trainerArray.count > 0 {
            trainerArray.removeAll()
        }

        // Remove popover view
        popover.dismiss()

        // Default Api
        defaultPagingValue()
        getAssociateList()
    }

    func defaultFilterButton() {
        // Reset default value
        selectedCategoryId = -1
        selectedSubCategoryId = -1

        // Set default button title
        setCategoryButton(title: LocalizedString.shared.categoriesButtonString, andSubTitle: "")
    }

    // Set Category Button Title and SubTitle
    func setCategoryButton(title: String, andSubTitle subTitle: String) {
        if subTitle.characters.count > 0 {
            categoriesButton.setTitleAndSubtitle(title: title, subTitle: subTitle)
        } else {
            categoriesButton.setAttributedTitle(nil, for: .normal)
            categoriesButton.setTitle(title, for: .normal)
        }
    }

    // MARK: - SegmentAction

    @IBAction func categoriesButtonCicked(_: UIButton) {

        // FilterView and position
        let filterView = FilterView.filterView()
        var frm = filterView.frame
        frm.origin.y = 0
        filterView.frame = frm
        filterView.defaultButtonTitle(LocalizedString.shared.categoriesButtonString)
        filterView.delegate = self
        filterView.selectedCategoryId = selectedCategoryId
        filterView.selectedSubCategoryId = selectedSubCategoryId

        // Pop overview position
        let startPoint = CGPoint(x: categoriesButton.frame.width / 2 + categoriesButton.frame.origin.x, y: categoriesButtonView.frame.height + categoriesButtonView.frame.origin.y + 60)
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        aView.addSubview(filterView)
        popover.popoverColor = UIColor.black

        // Check and category array
        if (categoryList?.count)! > 0 {
            popover.show(aView, point: startPoint)
            filterView.inlization(categoryList!)
        } else {
            // API for get category list
            getFilter { success, categoryArray in
                if success {
                    self.categoryList = categoryArray
                    self.popover.show(aView, point: startPoint)
                    filterView.inlization(self.categoryList!)
                }
            }
        }
    }

    @IBAction func segmentControlTapped(_: Any) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            associateTableView.isHidden = false
            trainerTableView.isHidden = true
            categoriesButtonView.isHidden = false
            if !(associateArray.count > 0) {
                emptyView.isHidden = false
                getAssociateList()
            } else {
                emptyView.isHidden = true
            }

        case 1:
            categoriesButtonView.isHidden = true
            associateTableView.isHidden = true
            trainerTableView.isHidden = false
            if !(trainerArray.count > 0) {
                emptyView.isHidden = false
                getTrainerList()
            } else {
                emptyView.isHidden = true
            }

        default:
            break
        }
    }
}

//MARK : - UITableViewDataSource, UITableViewDelegate
extension StoreManagerTrainingViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            if selectedCategoryId > -1 {
                return (filterAssociateTrainee?.count)!
            } else {
                return associateArray.count
            }
        } else {
            return trainerArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cellToReturn: UITableViewCell?
        switch segmentControl.selectedSegmentIndex {
        case 0:
            if selectedCategoryId > -1 {
                if (filterAssociateTrainee?.count)! > 0 {
                    let cell = associateTableView.dequeueReusableCell(withIdentifier: "AssociateTraineeCell", for: indexPath) as! AssociateTraineeCell
                    cell.accessibilityIdentifier = "AssociateTraineeCell\(indexPath.row)"
                    cell.showDataForAssociatesTraineeithData(associate: (filterAssociateTrainee?[indexPath.row])!)
                    isShowingAssociates = false
                    cellToReturn = cell
                }
            } else {

                if associateArray.count > 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AssociateCell", for: indexPath) as! AssociateCell
                    cell.accessibilityIdentifier = "AssociateCell\(indexPath.row)"
                    let disclosureImage = UIImage(named: "cellIndicator.png")
                    cell.accessoryType = .disclosureIndicator
                    cell.accessoryView = UIImageView(image: disclosureImage!)
                    cell.showDataForAssociateswithData(associate: associateArray[indexPath.row])
                    cellToReturn = cell
                    isShowingAssociates = true
                }
            }

        case 1:
            if trainerArray.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AssociateTrainers", for: indexPath) as! AssociateTrainersCell
                cell.accessibilityIdentifier = "AssociateTrainers\(indexPath.row)"
                cell.showDataForTrainerswithData(trainer: trainerArray[indexPath.row])
                isShowingAssociates = false
                cellToReturn = cell
            }

        default:
            return cellToReturn!
        }
        return cellToReturn!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentControl.selectedSegmentIndex == 0 {
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell is AssociateCell {
                    selectedTrainer = associateArray[indexPath.row]
                    moveToAssociateOverviewController()
                }
            }
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {

        switch segmentControl.selectedSegmentIndex {
        case 1 :
            return 93.0
        default:
            return 69.0
        }
    }
}

//MARK : - API Calls
extension StoreManagerTrainingViewController {

    // Pagination in listing
    func loadMorePagesForTrainers() {
        trainerTableView.addInfiniteScrolling {
            if !self.isInProgress && self.currentPageNumber <= self.totalPages {
                self.currentPageNumber = self.currentPageNumber + 1
                self.isInProgress = true
                self.getTrainerList(self.currentPageNumber, isShowLoader: false)
            } else {
                if let _ = self.trainerTableView.infiniteScrollingView {
                    self.trainerTableView.infiniteScrollingView.stopAnimating()
                }
            }
        }
    }

    func getTrainerList(_ pageNumber: Int, isShowLoader: Bool) {
        trainerTableView.tableFooterView = totalPages == currentPageNumber ? indicatorFooter : UIView()
        if isShowLoader {
            Helper.showLoader()
        }
        UserManager.shared.activeUser.getTrainersList(pageNumber) { (success, _, resulrArray, _, pageCount) -> Void in
            self.isInProgress = false
            Helper.hideLoader()
            if let _ = self.trainerTableView.infiniteScrollingView {
                self.trainerTableView.infiniteScrollingView.stopAnimating()
            }
            if let _ = self.trainerTableView.pullToRefreshView {
                self.trainerTableView.pullToRefreshView.stopAnimating()
            }
            if success {

                if self.isPullToRefresh {
                    if self.trainerArray.count > 0 {
                        self.trainerArray.removeAll()
                    }
                }

                if (resulrArray?.count)! > 0 {
                    self.emptyView.isHidden = true
                    for arrayObj in resulrArray! {
                        self.trainerArray.append(arrayObj)
                    }
                    self.trainerTableView.reloadData()
                } else {
                    if self.trainerArray.count == 0 {
                        self.emptyView.isHidden = false
                    }
                }
                self.totalPages = pageCount
            } else {
            }
            self.isPullToRefresh = false
        }
    }

    func loadMorePagesForAssociates() {
        associateTableView.addInfiniteScrolling {
            if !self.isInProgress && self.currentPageNumber <= self.totalPages {
                self.currentPageNumber = self.currentPageNumber + 1
                self.isInProgress = true
                self.getAssociatesList(self.currentPageNumber, isShowLoader: false)
            } else {
                if let _ = self.associateTableView.infiniteScrollingView {
                    self.associateTableView.infiniteScrollingView.stopAnimating()
                }
            }
        }
    }

    func getAssociatesList(_ pageNumber: Int, isShowLoader: Bool) {
        associateTableView.tableFooterView = totalPages == currentPageNumber ? indicatorFooter : UIView()
        if isShowLoader {
            Helper.showLoader()
        }
        UserManager.shared.activeUser.getAssociatesList(1, pageNumber: pageNumber) { (success, _, resulrArray, _, pageCount) -> Void in
            self.isInProgress = false
            Helper.hideLoader()
            if let _ = self.associateTableView.infiniteScrollingView {
                self.associateTableView.infiniteScrollingView.stopAnimating()
            }
            if let _ = self.associateTableView.pullToRefreshView {
                self.associateTableView.pullToRefreshView.stopAnimating()
            }
            if success {
                if (resulrArray?.count)! > 0 {
                    for arrayObj in resulrArray! {
                        self.associateArray.append(arrayObj)
                    }
                    self.associateTableView.reloadData()
                    self.emptyView.isHidden = true
                    self.associateTableView.isHidden = false
                }
                self.totalPages = pageCount
            } else {
                if self.associateArray.count == 0 {
                    self.emptyView.isHidden = false
                }
            }
        }
    }
}

// MARK: - Filter API Calls
extension StoreManagerTrainingViewController {
    //  Filter by training
    func getFilter(_ completionHandler: @escaping (_ success: Bool, _ resultArray: [Category]?) -> Void) {

        Helper.showLoader()
        CategoryService.getCategoryAndSubSubcategory(1) { success, _, categoryArray, _ in
            Helper.hideLoader()

            if success {
                if (categoryArray?.count)! > 0 {
                    completionHandler(true, categoryArray)
                } else {
                    self.showMessageForNoCategoryResult()
                    completionHandler(false, nil)
                    LogManager.logError("Error occurred while store manager get filter")
                }
            } else {
                self.showMessageForNoCategoryResult()
                LogManager.logError("Error occurred while store manager get filter")
                completionHandler(false, nil)
            }
        }
    }

    // MARK: Show error message when no category/filter data
    func showMessageForNoCategoryResult() {
        showAlertViewWithMessage(LocalizedString.shared.INFORMATION_TITLE, message: LocalizedString.shared.NO_FILTER,true)
    }

    // Filtered training list
    func getFilteredAssociateList(_ categoryId: Int, subCategoryId: Int, pageNumber: Int, isShowLoader: Bool) {

        var category_Id = categoryId
        if category_Id == -1 {
            category_Id = 0
        }
        var subCategory_Id = subCategoryId
        if subCategory_Id == -1 {
            subCategory_Id = 0
        }

        associateTableView.tableFooterView = totalPagesFilter == currentPageNumberFilter ? indicatorFooterFilter : UIView()
        if isShowLoader {
            Helper.showLoader()
        }

        CategoryService.getAssociateByCategory(category_Id, subCategoryId: subCategory_Id, pageNumber: pageNumber) { success, message, associateArray, totalPages in
            self.isInProgressFilter = false
            Helper.hideLoader()

            if let _ = self.associateTableView.infiniteScrollingView {
                self.associateTableView.infiniteScrollingView.stopAnimating()
            }
            if let _ = self.associateTableView.pullToRefreshView {
                self.associateTableView.pullToRefreshView.stopAnimating()
            }

            if success {

                if self.isPullToRefreshFilter {
                    if (self.filterAssociateTrainee?.count)! > 0 {
                        self.filterAssociateTrainee?.removeAll()
                    }
                }

                if (associateArray?.count)! > 0 {
                    for arrayObj in associateArray! {
                        self.filterAssociateTrainee?.append(arrayObj)
                    }
                } else {
                    if pageNumber == 1 && associateArray?.count == 0 {
                        self.showAlertViewWithMessage(LocalizedString.shared.INFORMATION_TITLE, message: LocalizedString.shared.NO_ASSOCIATE)
                        if (self.filterAssociateTrainee?.count)! > 0 {
                            self.filterAssociateTrainee?.removeAll()
                        }
                        if self.associateArray.count > 0 {
                            self.associateArray.removeAll()
                        }
                    }
                }
                self.totalPagesFilter = totalPages
                self.associateTableView.reloadData()

            } else {
                self.showAlertViewWithMessage(LocalizedString.shared.INFORMATION_TITLE, message: message!,true)
            }

            self.isPullToRefreshFilter = false
        }
    }

    // Pagination in listing
    func loadMorePagesForTrainersFilter() {
        trainerTableView.addInfiniteScrolling {
            if !self.isInProgressFilter && self.currentPageNumberFilter <= self.totalPagesFilter {
                self.currentPageNumberFilter = self.currentPageNumberFilter + 1
                self.isInProgressFilter = true
                self.getFilteredAssociateList(self.selectedCategoryId, subCategoryId: self.selectedCategoryId, pageNumber: self.currentPageNumberFilter, isShowLoader: false)
            } else {
                if let _ = self.trainerTableView.infiniteScrollingView {
                    self.trainerTableView.infiniteScrollingView.stopAnimating()
                }
            }
        }
    }
}

//MARK : - NAvigation
extension StoreManagerTrainingViewController {

    func moveToChooseTrainer() {
        let storyboard = UIStoryboard.associateTrainingStoryboard()
        let controller = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.ChooseTrainerIdentifier) as! ChooseTrainerViewController
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        let popoverPresentationController = controller.popoverPresentationController
        popoverPresentationController?.delegate = self
        // result is an optional (but should not be nil if modalPresentationStyle is popover)
        if let _popoverPresentationController = popoverPresentationController {
            // set the view from which to pop up
            _popoverPresentationController.sourceView = view
            controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            let navController = UINavigationController(rootViewController: controller)
            super.navigationBarAppearanceBlack(navController: navController)
            navigationController?.present(navController, animated: true, completion: nil)
        }
    }

    func moveToFilterView() {
        let storyboard = UIStoryboard.associateTrainingStoryboard()
        let controller = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllerIdentifiers.filterIdentifier) as! FilterViewController
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        let popoverPresentationController = controller.popoverPresentationController
        popoverPresentationController?.delegate = self
        // result is an optional (but should not be nil if modalPresentationStyle is popover)
        if let _popoverPresentationController = popoverPresentationController {
            // set the view from which to pop up
            _popoverPresentationController.sourceView = view
            controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            let navBar = UINavigationController(rootViewController: controller)
            navigationController?.present(navBar, animated: true, completion: nil)
        }
    }
}
