//
//  AssociateTraineeTableViewCell.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 05/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class AssociateTraineeCell: UITableViewCell {

    //MARK : - Outlets
    @IBOutlet weak var traineeImageView: UIImageView!
    @IBOutlet weak var traineeNameLabel: UILabel!
    @IBOutlet weak var traineeModuleLabel: UILabel!
    @IBOutlet weak var traineeCompletedLabel: UILabel!

    //MARK : - view life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()

        traineeImageView.layoutIfNeeded()
        traineeImageView.layer.cornerRadius = traineeImageView.frame.size.width / 2
        traineeImageView.layer.masksToBounds = true
        traineeImageView.contentMode = .scaleAspectFill
    }

    //MARK : - setup data
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showDataForAssociatesTraineeithData(associate: Trainee) {

        traineeNameLabel.text = associate.traineeName?.capitalizingFirstLetter()
        let imagUrl: String = Constants.ImageUrl.SmallImage + associate.imageUrl!
        traineeImageView.sd_setImage(with: URL(string: imagUrl), placeholderImage: UIImage(named: "defaultPic"))
        traineeModuleLabel.text = associate.trainingTitle
        if let date = associate.trainingDate {
            traineeCompletedLabel.text = Helper.statusForTraining(status: associate.trainingStatus!) + " " + date
        } else {
            traineeCompletedLabel.text = Helper.statusForTraining(status: associate.trainingStatus!) + " " + "Not start"
        }
    }
}
