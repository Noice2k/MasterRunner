//
//  BTDeviceCell.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 31/01/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import UIKit

class BTDeviceCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var deviceNameLabel: UILabel!
}
