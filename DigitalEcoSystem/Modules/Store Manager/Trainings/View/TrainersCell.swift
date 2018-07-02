//
//  TrainersCell.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 14/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class TrainersCell: UITableViewCell {

    //MARK : - Outlets
    @IBOutlet weak var trainerLabel: UILabel!
    @IBOutlet weak var trainerImageView: UIImageView!

    @IBOutlet weak var selectedImageView: UIImageView!
    
    //MARK : - View life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        showCircularTrainerImageView()
    }

    //MARK : - setup data
    func showCircularTrainerImageView() {
        trainerImageView.layoutIfNeeded()
        trainerImageView.layer.cornerRadius = trainerImageView.frame.size.width / 2
        trainerImageView.layer.masksToBounds = true
        trainerImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectedImageView.isHidden = false
        } else {
            selectedImageView.isHidden = true
        }
        // Configure the view for the selected state
    }
}
