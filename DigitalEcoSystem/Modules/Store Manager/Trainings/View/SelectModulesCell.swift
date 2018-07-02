//
//  SelectModulesCell.swift
//  DigitalEcoSystem
//
//  Created by Ravi Ranjan on 14/04/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import UIKit

protocol SelectModulesCellDelegate {
    func cellButtonTapped(cell: SelectModulesCell)
}

class SelectModulesCell: UITableViewCell {

    //MARK : - Variables
    var idxPath: IndexPath?
    
    var delegate: SelectModulesCellDelegate?
    
    //MARK : - Outlets
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var trainingTitleLabel: UILabel!
    @IBOutlet weak var trainingImageView: UIImageView!
    
    //MARK : - view life cycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
         selectButton.setTitle(LocalizedString.shared.selectTitleString, for: .normal)
         selectButton.setTitleColor(UIColor.black, for: .normal)
         selectButton.setBackgroundColor(color: UIColor.white, forState: .normal)
         
         selectButton.titleLabel?.layer.removeAllAnimations()
         selectButton.setTitle(LocalizedString.shared.selectedTitleString, for: .selected)
         selectButton.setTitleColor(UIColor.white, for: .selected)
         selectButton.setBackgroundColor(color: UIColor.black, forState: .selected)
         */
        selectButton.setImage(UIImage.init(named: "btnModuleUnselected"), for: .normal)
        selectButton.setImage(UIImage.init(named: "btnModuleSelected"), for: .selected)
        selectButton.layer.cornerRadius = 2.0
        selectButton.layer.shadowOpacity = 0.1
        selectButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        selectButton.layer.shadowRadius = 12.0
        selectButton.layer.shadowColor = UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
        
        // Initialization code
    }
    
    //MARK : - Actions
    @IBAction func buttonTapped(sender _: AnyObject) {
        delegate?.cellButtonTapped(cell: self)
    }

    //MARK : - setup data
     func setData(training: Training, atIndexPath: IndexPath) {
        idxPath = atIndexPath
        trainingTitleLabel.text = training.trainingTitle
        if training.imageUrl == nil {
            return
        }
        let imagUrl: String = Constants.ImageUrl.SmallImage + training.imageUrl!
        trainingImageView.sd_setImage(with: URL(string: imagUrl), placeholderImage: UIImage(named: "defaultPic.png"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
