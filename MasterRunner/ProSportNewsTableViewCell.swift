//
//  ProSportTableViewCell.swift
//  Pods
//
//  Created by Igor Sinyakov on 11/01/2017.
//
//

import UIKit

class ProSportTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func setPreviewImage(image: UIImage?, index: Int) {
        if index == 2 {
            imagePreview3.image = image
        }
        if index == 1 {
            imagePreview2.image = image
        }
        if index == 0 {
            imagePreview1.image = image
        }
        
    }
    
    func UpdateUI()  {
        
    }
    
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var imagePreview1: UIImageView!
    @IBOutlet weak var imagePreview2: UIImageView!
    @IBOutlet weak var imagePreview3: UIImageView!
    
}
