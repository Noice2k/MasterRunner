//
//  ProSportNews.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 15/01/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import UIKit

class ProSportNewsItem{
    init(dict: Dictionary<String,AnyObject>) {
        
    }
    
}

class ProSportNews{
    
    var dictionary: NSMutableDictionary?
    
    init(dictionary: NSMutableDictionary) {
        self.dictionary = dictionary
    }
    static var _proSportNews: ProSportNews?
    
    class var proSportNews: ProSportNews? {
        get{
            if (_proSportNews == nil) {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "ProSportNews") as? Data
                if let userData = userData {
                    if let dictionary = try? JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary {
                        let mdictionary = NSMutableDictionary (dictionary: dictionary)
                        _proSportNews = ProSportNews(dictionary: mdictionary)
                    } else {
                        // empy object
                        let mdictionary = NSMutableDictionary()
                        _proSportNews = ProSportNews(dictionary: mdictionary)
                    }
                }
                else {
                    // empy object
                    let mdictionary = NSMutableDictionary()
                    _proSportNews = ProSportNews(dictionary: mdictionary)
                }
            }
            return _proSportNews
        }
        
        set (news){
            _proSportNews = news
            
            let defaults = UserDefaults.standard
            if let news = news {
                let data = try! JSONSerialization.data(withJSONObject: news.dictionary!, options: [])
                defaults.set(data, forKey: "ProSportNews")
            } else{
                defaults.set(nil, forKey: "ProSportNews")
            }
            
        }
    }

    var _News: [ProSportNewsItem] = []
}

