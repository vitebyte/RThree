//
//  WalkThroughCollectionViewCell.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 16/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

class WalkThroughCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var walkthroughImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - View life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
