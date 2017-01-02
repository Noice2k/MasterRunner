//
//  User.swift
//  
//
//  Created by Igor Sinyakov on 26/12/2016.
//
//

import UIKit

// user Firebase account
// store the user emal,pass,nickname for future compartibilyti with another login system
class User {
    var dictionary: NSMutableDictionary?
    
    init(dictionary: NSMutableDictionary) {
        self.dictionary = dictionary
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get{
            if (_currentUser == nil) {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUser") as? Data
                if let userData = userData {
                    if let dictionary = try? JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary {
                        let mdictionary = NSMutableDictionary (dictionary: dictionary)
                        _currentUser = User(dictionary: mdictionary)
                    } else {
                        _currentUser = nil
                    }
                    
                }
            }
            return _currentUser
        }
        
        set (user){
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUser")
            } else{
                defaults.set(nil, forKey: "currentUser")
            }
            
        }
    }
   
    
    func SetVkUser(email: String) {
        dictionary?["VkLogin"] = true
        dictionary?["Email"] = email
    }
    
}
