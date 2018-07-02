//
//  TrainerCollectionCell.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 15/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class TrainerCollectionCell: UICollectionViewCell {
    
    //MARK : - Outlets
    @IBOutlet weak var trainerImageView: UIImageView!

    @IBOutlet weak var trainerNameLabel: UILabel!

    //MARK : - view life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        showCircularTrainerImageView()
        // Initialization code
    }

    func showCircularTrainerImageView() {
        trainerImageView.layoutIfNeeded()
        trainerImageView.layer.cornerRadius = trainerImageView.frame.size.width / 2
        trainerImageView.layer.masksToBounds = true
        trainerImageView.contentMode = .scaleAspectFill
    }
}
