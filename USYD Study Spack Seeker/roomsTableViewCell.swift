//
//  roomsTableViewCell.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 14/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class roomsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var nextAvailableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
