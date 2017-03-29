//
//  BorderButton.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 28/02/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import UIKit

@IBDesignable
class BorderButton: UIButton {
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var normalBorderColor : UIColor? {
        didSet {
            layer.borderColor = normalBorderColor?.cgColor
        }
    }
    
    var _width : Int = 0
    
   /* override var isHidden: Bool // default is NO. doesn't check superviews
        {
        willSet (value) {
            // disable constraint by name 
           if (constraints.count > 0) {
                for index in 0...constraints.count-1 {
                    print("\(constraints[index].identifier)")
                    if constraints[index].identifier == "width" {
                        constraints[index].constant = value ? 0 : 150
                    }
                }
            }
        }
    }
    
*/
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.frame.height/2
        clipsToBounds = true
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
