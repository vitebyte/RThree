//
//  AssociateTrainersCell.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 05/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class AssociateTrainersCell: UITableViewCell {

    //MARK : - Outlets
    @IBOutlet weak var associateTrainersImageView: UIImageView!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var associateTrainerNameLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!

    //MARK : - View lfie cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        removeButton.isHidden = true
        showCircularAssociateTrainersImageView()
    }

    //MARK : - setup data
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showDataForTrainerswithData(trainer: User) {
        associateTrainerNameLabel.text = trainer.userName
        designationLabel.text = LocalizedString.shared.chooseTrainerDesignation
        let imagUrl: String = Constants.ImageUrl.SmallImage + trainer.profileImg!
        associateTrainersImageView.sd_setImage(with: URL(string: imagUrl), placeholderImage: UIImage(named: "defaultPic.png"))
    }

    func showCircularAssociateTrainersImageView() {
        associateTrainersImageView.layoutIfNeeded()
        associateTrainersImageView.layer.cornerRadius = associateTrainersImageView.frame.size.width / 2
        associateTrainersImageView.layer.masksToBounds = true
        associateTrainersImageView.contentMode = .scaleAspectFill
    }
}
