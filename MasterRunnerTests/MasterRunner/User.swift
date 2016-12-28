//
//  User.swift
//  
//
//  Created by Igor Sinyakov on 26/12/2016.
//
//

import UIKit

class User {
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
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
                        _currentUser = User(dictionary: dictionary)
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
    
}
