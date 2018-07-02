//
//  FilterViewController.swift
//  DigitalEcoSystem
//
//  Created by Narender Kumar on 10/05/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class FilterViewController: BaseViewController {

    //MARK : - Variables
    var filterArray: [Category] = [Category]()
    var arrayForBool: NSMutableArray = NSMutableArray()
    var sectionTitleArray: NSMutableArray = NSMutableArray()
    let cellReuseIdentifier = "FilterHeaderCell"

    //MARK : - Outlets
    @IBOutlet weak var filterTableView: UITableView!

    //MARK : - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        filterTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        sectionTitleArray = NSMutableArray(array: filterArray)
        for _ in sectionTitleArray {
            arrayForBool.add(false)
        }

        filterTableView.reloadData()
        doInitialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK : - Initial setup
    func doInitialSetup() {
        super.navigationBarAppearanceBlack(navController: navigationController!)
        title = " "
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.BarButtonItemImage.closeWhiteColor), style: .plain, target: self, action: #selector(rightBarButtonAction))
    }

    func rightBarButtonAction(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK : - UITableViewDelegate, UITableViewDataSource
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {

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
            let filterCell: FilterCell = filterTableView.dequeueReusableCell(withIdentifier: "FilterCell") as! FilterCell!
            filterCell.categoryLabel?.text = subCat.subCatName
            filterCell.backgroundColor = UIColor.black
            filterCell.filterImageView?.image = UIImage(named: "icTickBlank")

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

        // Set Tick image on selection in Sub category cell
        let cell: FilterCell = tableView.cellForRow(at: indexPath) as! FilterCell
        cell.filterImageView?.image = UIImage(named: "icTickWhite")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("you didDeselectRowAt section \(indexPath.section) and row \(indexPath.row)")

        // Remove Tick image on deselection and set blank image in Sub category cell
        let cell: FilterCell = tableView.cellForRow(at: indexPath) as! FilterCell
        cell.filterImageView?.image = UIImage(named: "icTickBlank")
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

        // Set Category Title on header
        let viewLabel: UILabel = UILabel.init(frame: CGRect(x: 42, y: 0, width: (filterTableView.frame.width - 42), height: 43))
        viewLabel.textColor = .white
        let category: Category = sectionTitleArray.object(at: section) as! Category
        viewLabel.text = category.catName
        sectionView.addSubview(viewLabel)

        // Set or Remove Tick image as per selection
        let collapsed: Bool = (arrayForBool[section] as? Bool)!
        let imgView: UIImageView = UIImageView.init(frame: CGRect(x: 15, y: 15, width: 10, height: 10))
        if collapsed {
            imgView.image = UIImage(named: "icTickWhite")
        } else {
            imgView.image = UIImage(named: "icTickBlank")
        }
        sectionView.addSubview(imgView)

        // Add Gesture on section for identifity selection section
        let headerTapped: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(sectionHeaderTapped(_:)))
        sectionView.addGestureRecognizer(headerTapped)
        return sectionView
    }

    func sectionHeaderTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let indexPath: IndexPath = IndexPath(row: 0, section: gestureRecognizer.view!.tag)
        print("Header index : \(indexPath.section)")
        if indexPath.row == 0 {
            let collapsed: Bool = (arrayForBool[indexPath.section] as? Bool)!

            for i in 0 ..< sectionTitleArray.count {
                if indexPath.section == i {
                    arrayForBool[i] = !collapsed
                } else {
                    arrayForBool[i] = false
                }
            }

            // Animation
            let range = NSRange(location: 0, length: numberOfSections(in: filterTableView))
            let sections: NSIndexSet = NSIndexSet(indexesIn: range)
            filterTableView.reloadSections(sections as IndexSet, with: .fade)
        }
    }
}
