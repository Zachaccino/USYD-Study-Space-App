//
//  buildingNameTableViewCell.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 10/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class buildingNameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buildingNameLabel: UILabel!
    
    @IBOutlet weak var availabilityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
