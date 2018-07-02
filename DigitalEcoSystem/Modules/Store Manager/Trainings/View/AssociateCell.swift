//
//  AssociateCell.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 05/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class AssociateCell: UITableViewCell {

    //MARK : - Outlets
    @IBOutlet weak var associateImageView: UIImageView!
    @IBOutlet weak var associateNameLabel: UILabel!
    
    //MARK : - view life cyle methods
    override func awakeFromNib() {
        super.awakeFromNib()

        associateImageView.layoutIfNeeded()
        associateImageView.layer.cornerRadius = associateImageView.frame.size.width / 2
        associateImageView.layer.masksToBounds = true
        associateImageView.contentMode = .scaleAspectFill
    }

    //MARK : - setup data
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func showDataForAssociateswithData(associate: User) {
        associateNameLabel.text = associate.userName
        let imagUrl: String = Constants.ImageUrl.SmallImage + associate.profileImg!
        associateImageView.sd_setImage(with: URL(string: imagUrl), placeholderImage: UIImage(named: "defaultPic.png"))
    }
}
