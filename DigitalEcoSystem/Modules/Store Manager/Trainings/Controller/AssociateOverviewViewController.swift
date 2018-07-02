//
//  AssociateOverviewViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 08/05/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit
import Popover

class AssociateOverviewViewController: BaseViewController, FilterViewDelegate {

    // MARK: - Variables
    fileprivate let footerHeight: CGFloat = 0
    fileprivate let cellIdentifier = "AssociateDataCell"

    fileprivate var selectedRowIndex = -1
    fileprivate var selectedCategoryId: Int = -1
    fileprivate var selectedSubCategoryId: Int = -1
    // fileprivate var popover = Popover()
    fileprivate var popover = Popover(options: [.animationIn(0.001), .animationOut(0.001)] as [PopoverOption], showHandler: nil, dismissHandler: nil)
    fileprivate var categoryList: [Category]? = [Category]()
    fileprivate var indicatorFooter = UIView()
    
    fileprivate var currentPageNumber: Int = 1
    fileprivate var totalPages: Int = 1
    fileprivate var isInProgress: Bool = false
    fileprivate var isPullToRefresh: Bool = false
    

    public var selectedAssociate: User?
    public var trainingArray: NSMutableArray! = NSMutableArray()

    var isSuccess: Bool = false

    // MARK: - IBOutlets
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var associateDataTableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var navigationSubtitleLabel: UILabel!
    @IBOutlet var navigationView: UIView!

    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // register scroll events
        loadMorePages()
        pullToRefresh()

        filterButton.titleLabel?.numberOfLines = 0

        // load trainings
        getAssociateTrainingList(currentPageNumber, isShowLoader: true)
        doInitialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Navigation Bar View With Subtitle
    func doInitialSetup() {
        super.addLeftBarButton(withImageName: Constants.BarButtonItemImage.BackArrowWhiteColor)
        navigationItem.title = selectedAssociate?.userName
    }

    // MARK: - Actions
    override func leftButtonPressed(_: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func filterButtonAction(_: UIButton) {

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
        let startPoint = CGPoint(x: filterButton.frame.width / 2 + filterButton.frame.origin.x, y: self.filterView.frame.height + self.filterView.frame.origin.y + 60) // +44 NavBar height + 20
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        aView.addSubview(filterView)
        popover.popoverColor = UIColor.black

        // Check and category array
        if (categoryList?.count)! > 0 {
            filterView.inlization(categoryList!)
            popover.show(aView, point: startPoint)
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

    // MARK: - FilterViewDelegate
    // FilterViewDelegate - Popoverview delegate
    func applyButtonTapped(_ categoryId: Int, _ subCategoryId: Int) {
        print("Selected cat and subcat : \(categoryId), \(subCategoryId)")
        selectedCategoryId = categoryId
        selectedSubCategoryId = subCategoryId
        popover.dismiss()

        // Remove all data from table
        if (trainingArray?.count)! > 0 {
            trainingArray.removeAllObjects()
        }
        associateDataTableView.reloadData()

        if selectedCategoryId > -1 {
            let categoryObj: Category = categoryList![self.selectedCategoryId]
            let categoryName = categoryObj.catName
            let categoryId = categoryObj.catId

            var subCategoryId = 0
            var subCategoryName = ""
            if selectedSubCategoryId > -1 {
                let subCategories = categoryObj.subCatList
                subCategoryName = (subCategories?[self.selectedSubCategoryId].subCatName)!
                subCategoryId = (subCategories?[self.selectedSubCategoryId].subCatId)!
            }
            setCategoryButton(title: categoryName!, andSubTitle: subCategoryName)
            getTrainingList((selectedAssociate?.userId)!, categoryId: categoryId!, subCategoryId: subCategoryId)
        }
    }

    func defaultButtonTapped() {

        // Reset default
        defaultFilterButton()

        // Remove all data from table
        if (trainingArray?.count)! > 0 {
            trainingArray.removeAllObjects()
        }

        // Remove popover view
        popover.dismiss()

        // Default Api
        getTrainingList((selectedAssociate?.userId)!, categoryId: 0, subCategoryId: 0)
    }

    func defaultFilterButton() {
        // Reset default value
        selectedCategoryId = -1
        selectedSubCategoryId = -1

        currentPageNumber = 1

        // Set default button title
        setCategoryButton(title: LocalizedString.shared.categoriesButtonString, andSubTitle: "")
    }

    // Set Category Button Title and SubTitle
    func setCategoryButton(title: String, andSubTitle subTitle: String) {
        if subTitle.characters.count > 0 {
            filterButton.setTitleAndSubtitle(title: title, subTitle: subTitle)
        } else {
            filterButton.setAttributedTitle(nil, for: .normal)
            filterButton.setTitle(title, for: .normal)
        }
    }

    func pullToRefresh() {
        // Set filter button default
        self.defaultFilterButton()
        
        isSuccess = false
        associateDataTableView.addPullToRefresh {
            // Remove all training objects and reload fresh data with page count 1
            if self.trainingArray.count > 0 {
                self.trainingArray.removeAllObjects()
                self.associateDataTableView.reloadData()
            }
            self.currentPageNumber = 1
            self.isPullToRefresh = true
            self.getAssociateTrainingList(self.currentPageNumber, isShowLoader: false)
        }
    }
}

 //MARK : - UITableViewDataSource, UITableViewDelegate, AssociateDataCellDelegate
extension AssociateOverviewViewController: UITableViewDataSource, UITableViewDelegate, AssociateDataCellDelegate {

    // MARK: UITableView
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return trainingArray.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = associateDataTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AssociateDataCell
        cell.delegate = self
        if let training: Training = self.trainingArray[indexPath.row] as? Training {
            if isSuccess {
                cell.resendButton.isHidden = true
            } else {
                cell.resendButton.isHidden = false
            }
            cell.setAssociateTrainingDataInCell(training, atIndexPath: indexPath)
        }
        return cell
    }

    func cellResendButtonTapped(_ indexPath: IndexPath) {

        let trainingObj: Training = trainingArray[indexPath.row] as! Training
        resetTraining(trainingId: trainingObj.trainingId!, isShowLoader: true)

        // update the height for all the cells
        associateDataTableView.beginUpdates()
        let cell = associateDataTableView.cellForRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section)) as! AssociateDataCell
        cell.resendButton.isHidden = true
        associateDataTableView.endUpdates()
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 116.0
        if let training: Training = self.trainingArray[indexPath.row] as? Training {
            let status: Int = training.status!
            if status == TrainingStatus.Expired.hashValue {
                if isSuccess {
                    isSuccess = false
                    height = 116.0
                } else {
                    height = 166.0
                }
            } else {
                height = 116.0
            }
        }
        return height
    }

    // Adding footer in tableView
    func tableView(_ tableView: UITableView, viewForFooterInSection _: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: footerHeight))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return footerHeight
    }
}

//MARK : - API Calls
extension AssociateOverviewViewController {
    func getTrainingList(_ userId: Int, categoryId: Int, subCategoryId: Int) {
        associateDataTableView.tableFooterView = totalPages == currentPageNumber ? indicatorFooter : UIView()
        
        var catId = categoryId
        if catId == -1 {
            catId = 0
        }
        var subCatId = subCategoryId
        if subCatId == -1 {
            subCatId = 0
        }
        
        CategoryService.getTrainingByFilter(userId, catId, subCategoryId: subCatId, pageNumber: currentPageNumber, completionHandler: { (success, _, resultArray, pageCount) -> Void in
            self.isInProgress = false
            Helper.hideLoader()
            
            if let _ = self.associateDataTableView.infiniteScrollingView {
                self.associateDataTableView.infiniteScrollingView.stopAnimating()
            }
            
            if let _ = self.associateDataTableView.pullToRefreshView {
                self.associateDataTableView.pullToRefreshView.stopAnimating()
            }
            
            if success {
                print("Trainings fetched from server")
                self.totalPages = pageCount
                
                // Do not reload here. Wait untill we trainings are cached in coredata
                
                // Load More - add object if user use loadmore in tableview
                if (resultArray?.count)! > 0 {
                    self.trainingArray.addObjects(from: resultArray!)
                    self.associateDataTableView.reloadData()
                } else {
                    // Show no request and get back
                    if self.currentPageNumber == 1 {
                        self.showAlertViewWithMessageAndActionHandler(LocalizedString.shared.INFORMATION_TITLE, message: LocalizedString.shared.NO_TRAINEE_REQUEST, actionHandler: {
                            self.leftButtonPressed(UIButton())
                        })
                    }
                }
            }
            
            if self.isPullToRefresh == true {
                self.isPullToRefresh = false
                
                // Remove all training objects and reload fresh data with page count 1
                self.trainingArray.removeAllObjects()
                self.associateDataTableView.reloadData()
            }
            
        })
    }
    
    // MARK: - Showing Banner
    func showBanner(_ titelString: String) {
        let banner = Banner(title: titelString, subtitle: "", image: UIImage(named: "check"), backgroundColor: UIColor.colorWithRedValue(21.0, greenValue: 160.0, blueValue: 94.0, alpha: 1.0))
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    // Pagination in listing
    func loadMorePages() {
        isSuccess = false
        associateDataTableView.addInfiniteScrolling {
            if !self.isInProgress && self.currentPageNumber <= self.totalPages {
                self.currentPageNumber = self.currentPageNumber + 1
                self.isInProgress = true
                self.getAssociateTrainingList(self.currentPageNumber, isShowLoader: false)
            } else {
                if let _ = self.associateDataTableView.infiniteScrollingView {
                    self.associateDataTableView.infiniteScrollingView.stopAnimating()
                }
            }
        }
    }
    
    func getAssociateTrainingList(_ pageNum: Int, isShowLoader: Bool) {
        associateDataTableView.tableFooterView = totalPages == currentPageNumber ? indicatorFooter : UIView()
        if isShowLoader {
            Helper.showLoader()
        }
        
        CategoryService.associatesTrainingByCategory(_associateId: (selectedAssociate?.userId)!, pageNumber: pageNum) { success, _, resultArray, pageCount in
            self.isInProgress = false
            Helper.hideLoader()
            if let _ = self.associateDataTableView.infiniteScrollingView {
                self.associateDataTableView.infiniteScrollingView.stopAnimating()
            }
            if let _ = self.associateDataTableView.pullToRefreshView {
                self.associateDataTableView.pullToRefreshView.stopAnimating()
            }
            if success {
                self.totalPages = pageCount
                
                if (resultArray?.count)! > 0 {
                    self.trainingArray.addObjects(from: resultArray!)
                }
                self.associateDataTableView.reloadData()
            }
            self.isPullToRefresh = false
        }
    }
    
    func resetTraining(trainingId: Int, isShowLoader: Bool) {
        associateDataTableView.tableFooterView = totalPages == currentPageNumber ? indicatorFooter : UIView()
        if isShowLoader {
            Helper.showLoader()
        }
        
        CategoryService.resetTraineeTraining((selectedAssociate?.userId)!, trainingId) { success, message in
            self.isInProgress = false
            Helper.hideLoader()
            if success {
                self.showBanner("Module has been resent")
                self.isSuccess = success
                // update the height for all the cells
                self.associateDataTableView.beginUpdates()
                self.associateDataTableView.endUpdates()
            } else {
                // TODO: Show Error message
                super.showAlertViewWithMessage(LocalizedString.shared.FAILURE_TITLE, message: message!)
            }
        }
    }
    
    // MARK: Filter by training
    func getFilter(_ completionHandler: @escaping (_ success: Bool, _ resultArray: [Category]?) -> Void) {
        
        Helper.showLoader()
        CategoryService.getCategoryForTraining((selectedAssociate?.userId)!, pageNumber: 1) { success, _, categoryArray, _ in
            Helper.hideLoader()
            
            if success {
                if (categoryArray?.count)! > 0 {
                    completionHandler(true, categoryArray)
                } else {
                    self.showMessageForNoCategoryResult()
                    completionHandler(false, nil)
                }
            } else {
                self.showMessageForNoCategoryResult()
                completionHandler(false, nil)
            }
        }
    }
    
    // MARK: Show error message when no category/filter data
    func showMessageForNoCategoryResult() {
        
        LogManager.logError("No category filter data")
        showAlertViewWithMessage(LocalizedString.shared.INFORMATION_TITLE, message: LocalizedString.shared.NO_FILTER)
    }

}
