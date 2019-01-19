//
//  addNewTimeTableViewCell.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 6/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class addNewTimeTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var timeSnippetLabel: UILabel!
    @IBOutlet weak var selectedTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
