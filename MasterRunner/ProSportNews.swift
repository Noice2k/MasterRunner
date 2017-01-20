//
//  ProSportNews.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 15/01/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import UIKit
import VK_ios_sdk

class ProSportNewsItem{
    init(dict: Dictionary<String,AnyObject>) {
        newsText = ""
        if let text = dict["text"] as! String?{
            newsText = text
        }
        if let attachments = dict["attachments"] as? [[String: Any]] {
            for attachment in attachments {
                if let type = attachment["type"] as! String? {
                    if type == "photo" {
                        photos += [VKPhoto(dict: attachment["photo"] as! Dictionary<String,AnyObject>) ]
                        print(attachment["photo"]!)
                        
                    }
                }
            }
        }
    }
    
    var newsText : String
    var photos =  [VKPhoto]()
    
}

// deletage
protocol ProSportNewsDelegate {
    // update data after all news
    func onEndUpdateNews()
}

class ProSportNews{
    
    // just for test, to understand how it work
    func processingNewsRequest(responce: VKResponse<VKApiObject>) {
        // a million hours of sex to get this string
        if let wall = responce.json as? Dictionary<String,AnyObject> {
            if let items = wall["items"] as? NSArray {
                for item in items {
                    ProSportNews.proSportNews!._News += [ProSportNewsItem(dict: item as! Dictionary<String,AnyObject> )]
                }
                DispatchQueue.main.async {
                    self.delegate?.onEndUpdateNews()
                }
            }
        }
    }
    
    
    func getNews() {
        // load 20 messages
        let req = VKApi.request(withMethod: "wall.get", andParameters: ["domain" : "schoolprosport60"])
        req?.addExtraParameters(["count" : 20])
        req?.execute(resultBlock: {response in
            self.processingNewsRequest(responce: response!)
        }, errorBlock: { (error) in
        })

    }
    
    
    var delegate: ProSportNewsDelegate?
    
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

