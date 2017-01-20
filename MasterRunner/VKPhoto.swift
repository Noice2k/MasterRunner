//
//  VKPhoto.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 18/01/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import UIKit

class VKPhoto {

    init(dict: Dictionary<String,AnyObject>) {
        if let url = dict["photo_75"] as? String {
            urls["photo_75"] = URL(string: url)
            images["photo_75"] = loadImage(url: URL(string: url))
            
        }
        if let url = dict["photo_130"] as? String {
            urls["photo_130"] = URL(string: url)
        //    images["photo_75"] = loadImage(url: URL(string: url))

        }
        if let url = dict["photo_640"] as? String {
            urls["photo_640"] = URL(string: url)
        //    images["photo_75"] = loadImage(url: URL(string: url))

        }
        if let url = dict["photo_807"] as? String {
            urls["photo_807"] = URL(string: url)
        //    images["photo_75"] = loadImage(url: URL(string: url))

        }
        if let url = dict["photo_1280"] as? String {
            urls["photo_1280"] = URL(string: url)
        //    images["photo_75"] = loadImage(url: URL(string: url))

        }
        if let url = dict["photo_2560"] as? String {
            urls["photo_2560"] = URL(string: url)
        //    images["photo_75"] = loadImage(url: URL(string: url))

        }
    }
    
    var urls = Dictionary<String,URL>()
    var images = Dictionary<String,UIImage?> ()
    
    func loadImage(url: URL?) -> UIImage? {
        var image : UIImage?
        if let url = url {
            if let data =  NSData(contentsOf: url) {
                image = UIImage(data: data as Data)
            }
        }
        return image
    }
    
}
