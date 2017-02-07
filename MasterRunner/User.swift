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
                let arr = [UInt8](userData!)
                print(arr)
                
                if let userData = userData {
                    if let dictionary = try? JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary {
                        let mdictionary = NSMutableDictionary (dictionary: dictionary)
                        _currentUser = User(dictionary: mdictionary)
                    } else {
                        _currentUser = User(dictionary: NSMutableDictionary())
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
    
    func updateUser() {
        let defaults = UserDefaults.standard
        let data = try! JSONSerialization.data(withJSONObject: self.dictionary!, options: [])
        defaults.set(data, forKey: "currentUser")
    }
   
    func SetVkUser(email: String) {
        dictionary?["VkLogin"] = true
        dictionary?["Email"] = email
    }
    var _blueToothHBDevice : BTDevice? = BTDevice()
    var blueToothHBDevice : BTDevice? {
        get {
               if let _ = dictionary?["bt_hb_device_name"] {
                _blueToothHBDevice = BTDevice()
                _blueToothHBDevice?.name = dictionary?["bt_hb_device_name"] as! String
                let uuid = dictionary?["bt_hb_device_uuid"] as! String
                _blueToothHBDevice?.uuid = UUID(uuidString : uuid)
            }
            return _blueToothHBDevice
        }
        set (device){
            dictionary?["bt_hb_device_name"] = device?.name
            dictionary?["bt_hb_device_uuid"] = device?.uuid?.uuidString
            _blueToothHBDevice = device
            updateUser()
        }
    }
    
    
}
