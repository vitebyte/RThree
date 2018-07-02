//
//  FilterCell.swift
//  DigitalEcoSystem
//
//  Created by Narender Kumar on 15/05/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    //MARK : - Outlets
    //TODO: change in storyboard
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!

    //MARK : - view life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
