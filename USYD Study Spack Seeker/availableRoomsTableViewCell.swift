//
//  availableRoomsTableViewCell.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 11/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class availableRoomsTableViewCell: UITableViewCell {

    @IBOutlet weak var venueLabel: UILabel!
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
