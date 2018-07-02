//
//  ConfirmAssigneeViewController.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 15/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

let assignTableViewAccessibilityID = "assignTableView"

class ConfirmAssigneeViewController: BaseViewController {

    //MARK: -Variables
    public var selectedTrainer: User?
    public var selectedTraineesArray: NSMutableArray = NSMutableArray()
    public var selectedTrainingsArray = [Training]()

    // MARK: - IBOutlets
    @IBOutlet weak var assignButton: UIButton!
    @IBOutlet weak var assignTableView: UITableView!

    //MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        assignTableView.accessibilityIdentifier = assignTableViewAccessibilityID
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

    // MARK: - Showing Banner and initial setup
    func showBanner(_ titelString: String) {
        let banner = Banner(title: titelString, subtitle: "", image: UIImage(named: "check"), backgroundColor: UIColor.colorWithRedValue(21.0, greenValue: 160.0, blueValue: 94.0, alpha: 1.0))
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }

    func moveToStoreManagerTrainingViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    func handleLocalizeStrings() {
        navigationItem.title = LocalizedString.shared.confirmTitleString
        assignButton.setTitle(LocalizedString.shared.assignString, for: .normal)
    }

    func doInitialSetup() {
        // super.addWhiteBackBarButton()
        super.addLeftBarButton(withImageName: Constants.BarButtonItemImage.BackArrowWhiteColor)
        //        super.setNavBarTitle(LocalizedString.shared.confirmTitleString)
        assignTableView.tableFooterView = UIView()
    }

    //MARK: - Actions
    override func leftButtonPressed(_: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func assignButtonAction(_: UIButton) {

        let trainingsIdArray = selectedTrainingsArray.map({ (training: Training) -> Int in
            training.trainingId!
        })

        let swiftArray: [User] = selectedTraineesArray.flatMap({ $0 as? User })
        let traineesIdArray = swiftArray.map({ (traineeUser: User) -> Int in
            traineeUser.userId!
        })
        let trainerId = selectedTrainer.map({ (user: User) -> Int in
            user.userId!
        })
        Helper.showLoader()
        Training.assignTraining(traineesIdArray as AnyObject, traningIds: trainingsIdArray as AnyObject, trainerId: trainerId!, storeId: 1) { success, _ in
            Helper.hideLoader()
            if success {
                self.showBanner(LocalizedString.shared.trainerAssignedString)
                self.moveToStoreManagerTrainingViewController()
            } else {
            }
        }
    }
}

//MARK: -  UITableViewDataSource, UITableViewDelegate
extension ConfirmAssigneeViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Table view data source

    func numberOfSections(in _: UITableView) -> Int {
        return 3
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        case 2:
            return selectedTrainingsArray.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "AssignedTrainer", for: indexPath) as! AssignedTrainerCell
            cell.accessibilityIdentifier = "AssignedTrainer\(indexPath.row)"
            (cell as! AssignedTrainerCell).setData(trainer: selectedTrainer!)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "AssignedTrainee", for: indexPath) as! AssignedTraineeCell
            cell.accessibilityIdentifier = "AssignedTrainee\(indexPath.row)"
            (cell as! AssignedTraineeCell).setTraineesData(traineeArray: selectedTraineesArray)

        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "AssignedTraining", for: indexPath) as! AssignedTrainingCell
            cell.accessibilityIdentifier = "AssignedTraining\(indexPath.row)"
            (cell as! AssignedTrainingCell).setTrainingData(training: selectedTrainingsArray[indexPath.row])
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "AssignedTraining", for: indexPath) as! AssignedTrainingCell
        }
        return cell
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        switch section {
        case 1, 2:
            return 15
        default:
            return 0
        }
    }

    // Adding Header in tableView
    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch section {
        case 1:
            title = LocalizedString.shared.traineesTitle + " (\(selectedTraineesArray.count))"
        case 2:
            title = LocalizedString.shared.trainingTitle + " (\(selectedTrainingsArray.count))"
        default:
            title = ""
        }
        return title
    }

    func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.gothamBook(13.0)
        header.textLabel?.frame = header.frame
        header.accessibilityIdentifier = "header \(section)"
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 1.0, animations: { cell.alpha = 1 })
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform = rotationTransform
        UIView.animate(withDuration: 0.2, animations: { cell.layer.transform = CATransform3DIdentity })
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 113
        case 1: // collection cell
            var numberOfItem = CGFloat(selectedTraineesArray.count / 2)
            if selectedTraineesArray.count % 2 == 0 {
                numberOfItem = CGFloat(selectedTraineesArray.count / 2)
            } else {
                numberOfItem = CGFloat(selectedTraineesArray.count / 2) + 1
            }

            let itemHeight = TableOffset.getItemHeight(boundHeight: 60, numberOfItems: numberOfItem)
            return itemHeight
        case 2:
            return 84
        default:
            return UITableViewAutomaticDimension
        }
    }
}
