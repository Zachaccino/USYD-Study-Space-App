//
//  nowTableViewCell.swift
//  USYD Study Spack Seeker
//
//  Created by JingyuanTu on 17/12/18.
//  Copyright © 2018 JingyuanTu. All rights reserved.
//

import UIKit

class nowTableViewCell: UITableViewCell {
    
    // MARK: Outlet
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var freeUntilLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
