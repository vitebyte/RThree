//
//  AssignedTrainerCell.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 14/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class AssignedTrainerCell: UITableViewCell {

    //MARK : - Outlets
    @IBOutlet weak var trainerLabel: UILabel!
    @IBOutlet weak var trainerImageView: UIImageView!
    
    //MARK : - View life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        showCirculartrainerImageView()
    }

    //MARK : - setup data
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(trainer: User) {
        let yourAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.gothamLight(15.0)]
        let yourOtherAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.gothamMedium(15.0)]
        let partOne = NSMutableAttributedString(string: LocalizedString.shared.buttonAssignTitle, attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: (trainer.userName)!, attributes: yourOtherAttributes)
        let partThree = NSMutableAttributedString(string: LocalizedString.shared.associateTrainerString, attributes: yourAttributes)

        let combination = NSMutableAttributedString()
        combination.append(partOne)
        combination.append(partTwo)
        combination.append(partThree)

        trainerLabel.attributedText = combination
        let imagUrl: String = Constants.ImageUrl.SmallImage + trainer.profileImg!
        trainerImageView.sd_setImage(with: URL(string: imagUrl), placeholderImage: UIImage(named: "defaultPic.png"))
    }

    func showCirculartrainerImageView() {
        trainerImageView.layoutIfNeeded()
        trainerImageView.layer.cornerRadius = trainerImageView.frame.size.width / 2
        trainerImageView.layer.masksToBounds = true
        trainerImageView.contentMode = .scaleAspectFill
    }
}
