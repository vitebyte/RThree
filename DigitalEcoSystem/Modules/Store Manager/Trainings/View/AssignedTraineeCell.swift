//
//  AssignedTraineeCell.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 14/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class TableOffset {

    //MARK : - Variables
    static let column: CGFloat = 2

    static let minLineSpacing: CGFloat = 10.0
    static let minItemSpacing: CGFloat = 10.0

    static let offset: CGFloat = 1.0 // TODO: for each side, define its offset

    static func getItemHeight(boundHeight: CGFloat, numberOfItems: CGFloat) -> CGFloat {
        // totalCellWidth = (collectionview width or tableview width) - (left offset + right offset) - (total space x space width)
        let totalWidth = (boundHeight * numberOfItems) + (numberOfItems * minItemSpacing) + minLineSpacing
        return totalWidth
    }
}

class AssignedTraineeCell: UITableViewCell {
    
    //MARK : - Variables
    let cellIdentifier = "TraineeCell" // also enter this string as the cell identifier in the storyboard
    var items: NSMutableArray = NSMutableArray()
    
    //MARK : - Outlets
    @IBOutlet weak var collectionHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var traineeCollectionView: UICollectionView!
    
    //MARK : - View life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        traineeCollectionView.dataSource = self
        traineeCollectionView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK : - setup data
    func setTraineesData(traineeArray: NSMutableArray) {
        items = traineeArray
    }
}

//MARK : - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension AssignedTraineeCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDataSource protocol

    // tell the collection view how many cells to make
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }

    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! TrainerCollectionCell
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let traineeUser: User = items[indexPath.row] as! User
        cell.trainerNameLabel.text = traineeUser.userName
        let imagUrl: String = Constants.ImageUrl.SmallImage + traineeUser.profileImg!
        cell.trainerImageView.sd_setImage(with: URL(string: imagUrl), placeholderImage: UIImage(named: "defaultPic.png"))
        return cell
    }

    // MARK: - UICollectionViewDelegate protocol

    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {
        // handle tap events
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width / 2 - 40
        return CGSize(width: width, height: 60)
    }
}
