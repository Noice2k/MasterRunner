//
//  TrainPreviewCell.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 22/03/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import UIKit

class TrainPreviewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var labelAverageSpeed: UILabel!
    @IBOutlet weak var labelTrainDistance: UILabel!
    @IBOutlet weak var labelTrainDate: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
