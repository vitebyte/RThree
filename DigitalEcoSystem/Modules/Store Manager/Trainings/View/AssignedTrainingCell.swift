//
//  AssignedTrainingCell.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 14/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class AssignedTrainingCell: UITableViewCell {
    
    //MARK : - OUtlets
    @IBOutlet weak var trainingLabel: UILabel!
    @IBOutlet weak var trainimgImageView: UIImageView!
    
    //MARK : - view life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK : - setup data
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setTrainingData(training: Training) {
        trainingLabel.text = training.trainingTitle
        let imagUrl: String = Constants.ImageUrl.SmallImage + training.imageUrl!
        trainimgImageView.sd_setImage(with: URL(string: imagUrl), placeholderImage: UIImage(named: "defaultPic.png")) }
}
