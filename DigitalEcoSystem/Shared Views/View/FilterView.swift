//
//  FilterView.swift
//  DigitalEcoSystem
//
//  Created by Narender Kumar on 17/05/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

protocol FilterViewDelegate {
    func applyButtonTapped(_ categoryId: Int, _ subCategoryId: Int)
    func defaultButtonTapped()
}

class FilterView: UIView {

    //MARK : - Variables
    var filterArray: [Category] = [Category]()
    var delegate: FilterViewDelegate?
    var selectedCategoryId: Int = -1
    var selectedSubCategoryId: Int = -1

    fileprivate var arrayForBool: NSMutableArray = NSMutableArray()
    fileprivate var sectionTitleArray: NSMutableArray = NSMutableArray()
    fileprivate let tickWhiteImage: String = "icTick"
    fileprivate let tickBlankImage: String = "icBlack"

    let cellReuseIdentifier = "FilterHeaderCell"
    let subCategoryCellIdentifier = "FilterViewCell"

    //MARK : - Outlets
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var defaultButton: UIButton!

    //MARK : - Get FilterView
    class func filterView() -> FilterView {
        let nibs: [Any] = Bundle.main.loadNibNamed(String(describing: FilterView.self), owner: self, options: nil)!
        let filter: FilterView? = (nibs.first as? FilterView)
        return filter!
    }

    //MARK : - setup data
    func defaultButtonTitle(_ title: String) {
        defaultButton.setTitle(title, for: UIControlState.normal)
        defaultButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 105)
        defaultButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -125, bottom: 0, right: 0)
    }

    func inlization(_ dataArray: [Category]) {
        filterArray = dataArray

        // Register Cell
        filterTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        let cellNib = UINib(nibName: subCategoryCellIdentifier, bundle: nil)
        filterTableView.register(cellNib, forCellReuseIdentifier: subCategoryCellIdentifier)

        sectionTitleArray = NSMutableArray(array: filterArray)
        for _ in sectionTitleArray {
            arrayForBool.add(false)
        }
        if selectedCategoryId > -1 {
            arrayForBool[self.selectedCategoryId] = true
        }
        filterTableView.reloadData()
        if selectedSubCategoryId > -1 && selectedCategoryId > -1 {
            let indexPath = IndexPath(row: selectedSubCategoryId, section: selectedCategoryId)
            tableView(filterTableView, didSelectRowAt: indexPath)
        }

        if selectedSubCategoryId == -1 && selectedCategoryId == -1 {
            defaultButton.isSelected = true
        }
    }

    // MARK: - Action
    @IBAction func applyAction(_: UIButton) {
        if defaultButton.isSelected {
            delegate?.defaultButtonTapped()
        } else {
            delegate?.applyButtonTapped(selectedCategoryId, selectedSubCategoryId)
        }
    }

    @IBAction func defaultButtonAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false

        } else {
            sender.isSelected = true

            selectedCategoryId = -1
            selectedSubCategoryId = -1
            if arrayForBool.count > 0 {
                arrayForBool.removeAllObjects()
            }
            inlization(filterArray)
            filterTableView.reloadData()
        }
    }
}

//MARK : - UITableViewDelegate, UITableViewDataSource
extension FilterView: UITableViewDelegate, UITableViewDataSource {

    // MARK: - TableView DataSource and Delegate Methods
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value: Bool = arrayForBool.object(at: section) as! Bool
        if value {
            let category: Category = sectionTitleArray.object(at: section) as! Category
            return (category.subCatList?.count)!
        } else {
            return 0
        }
    }

    // create a cell for each table view row
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let category: Category = sectionTitleArray.object(at: indexPath.section) as! Category
        let subCategory = category.subCatList!

        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = filterTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!

        let manyCells: Bool = arrayForBool.object(at: indexPath.section) as! Bool

        if !manyCells {
            cell.backgroundColor = UIColor.black
            cell.textLabel?.text = ""
        } else {

            // Sub category cell
            let subCat: SubCatList = subCategory[indexPath.row]
            let filterCell: FilterViewCell = filterTableView.dequeueReusableCell(withIdentifier: subCategoryCellIdentifier) as! FilterViewCell!
            filterCell.categoryLabel?.text = subCat.subCatName
            filterCell.filterImageView?.image = UIImage(named: tickBlankImage)
            let tempIndexPath = IndexPath(row: selectedSubCategoryId, section: selectedCategoryId)
            if tempIndexPath == indexPath {
                filterCell.filterImageView?.image = UIImage(named: tickWhiteImage)
            }

            return filterCell
        }
        cell.textLabel?.textColor = UIColor.white

        return cell
    }

    func numberOfSections(in _: UITableView) -> Int {
        return sectionTitleArray.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you select section \(indexPath.section) and row \(indexPath.row)")
        //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)

        // deselected default button
        defaultButton.isSelected = false

        // Set Tick image on selection in Sub category cell
        let cell: FilterViewCell = tableView.cellForRow(at: indexPath) as! FilterViewCell
        cell.filterImageView?.image = UIImage(named: tickWhiteImage)

        selectedCategoryId = indexPath.section
        selectedSubCategoryId = indexPath.row

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("you didDeselectRowAt section \(indexPath.section) and row \(indexPath.row)")

        // Remove Tick image on deselection and set blank image in Sub category cell
        let cell: FilterViewCell = tableView.cellForRow(at: indexPath) as! FilterViewCell
        cell.filterImageView?.image = UIImage(named: tickBlankImage)
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let value: Bool = arrayForBool.object(at: indexPath.section) as! Bool
        if value {
            return 43
        } else {
            return 0
        }
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 43
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: filterTableView.frame.width, height: 43))
        sectionView.tag = section
        sectionView.backgroundColor = UIColor.black

        // Set Category Title on header
        let viewLabel: UILabel = UILabel.init(frame: CGRect(x: 42, y: 0, width: (filterTableView.frame.width - 42), height: 43))
        viewLabel.textColor = .white
        let category: Category = sectionTitleArray.object(at: section) as! Category
        viewLabel.text = category.catName
        sectionView.addSubview(viewLabel)

        // Set or Remove Tick image as per selection
        let collapsed: Bool = (arrayForBool[section] as? Bool)!
        let imgView: UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 20, height: 20))
        if collapsed {
            imgView.image = UIImage(named: tickWhiteImage)
        } else {
            imgView.image = UIImage(named: tickBlankImage)
        }
        sectionView.addSubview(imgView)

        // Add Gesture on section for identifity selection section
        let headerTapped: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(sectionHeaderTapped(_:)))
        sectionView.addGestureRecognizer(headerTapped)
        return sectionView
    }

    func sectionHeaderTapped(_ gestureRecognizer: UITapGestureRecognizer) {

        // deselected default button
        defaultButton.isSelected = false

        let indexPath: IndexPath = IndexPath(row: 0, section: gestureRecognizer.view!.tag)
        print("Header index : \(indexPath.section)")
        if indexPath.row == 0 {
            let collapsed: Bool = (arrayForBool[indexPath.section] as? Bool)!

            // Reset Category and Subcategory
            selectedCategoryId = -1
            selectedSubCategoryId = -1

            for i in 0 ..< sectionTitleArray.count {
                if indexPath.section == i {
                    arrayForBool[i] = !collapsed
                } else {
                    arrayForBool[i] = false
                }
            }

            // Update Category (if any select only header/Category only)
            if arrayForBool.contains(1) {
                let indx = arrayForBool.index(of: 1)
                print("select header index : \(indx)")
                selectedCategoryId = indx
            }

            // Animation
            let range = NSRange(location: 0, length: numberOfSections(in: filterTableView))
            let sections: NSIndexSet = NSIndexSet(indexesIn: range)
            filterTableView.reloadSections(sections as IndexSet, with: .fade)
        }
    }
}
