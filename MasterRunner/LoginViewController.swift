//
//  LoginViewController.swift
//  MasterRunner
//
//  Контроллер для идентификации пользователя 
//
//  Created by Igor Sinyakov on 15/12/2016.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit
import VK_ios_sdk

import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController , VKSdkDelegate, VKSdkUIDelegate{
    
    //static let instanceLoginVC? : LoginViewController
    
    var db: FIRDatabaseReference!
    
    var email       = ""
    var password    = ""
    
    func qtest(responce: VKResponse<VKApiObject>) {
        print("SwiftyVK: captcha.force success \n \(responce)")
       // var json : Array<Any>!
        
            if let json = try JSONSerialization.data(withJSONObject: responce.json, options: []) as? Array! {
                print(json["count"])
                
            }
            
    }
    
    @IBAction func testGroup(_ sender: Any) {
        // try to get wall 
        
        let req = VKApi.request(withMethod: "wall.get", andParameters: ["domain" : "begoman"])
        req?.execute(resultBlock: {response in
                    self.qtest(responce: response!)
                }, errorBlock: { (error) in
            })
        
        
        
        
            }
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRApp.initialize()
        

        //instanceLoginVC = self
        
        /*let vk = VKSdk.initialize(withAppId: "ddf")
        vk?.register(self)
        vk?.uiDelegate = self
 */
        
        sdkInstance!.register(self)
        sdkInstance!.uiDelegate = self
        
        

        // Do any additional setup after loading the view.
    }

    @IBAction func test(_ sender: UIButton) {
    }
    @IBAction func LoginWithVK(_ sender: UIButton) {
       
        let scope = ["friends", "email"]
        VKSdk.wakeUpSession(scope, complete: {(state: VKAuthorizationState, error: Error?) -> Void in
            if state == .authorized {
                NSLog("authorized")
                
                
                self.tryInitFireBaseUser()
               // self.dismiss(animated: true)
                
            } else {
                VKSdk.authorize(scope)
            }
            return
        })
        
       
    }
  
    func vkSdkUserAuthorizationFailed() {
        print("error")
        
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        // try loing to FireBase with VKLogin
        guard result.token != nil else {
            return
        }
        tryInitFireBaseUser()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
     
        show(controller, sender: self)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
    
    
    func tryInitFireBaseUser()  {
        //
        let email = VKSdk.accessToken().email
        
        if FIRAuth.auth()?.currentUser != nil {
        } else {
            // try login before create new user
            
            
            
            
            FIRAuth.auth()?.createUser(withEmail: email!, password: "passsssssword", completion: { (user, error) in
                print(error.debugDescription)
                if (user != nil) {
                    
                }
                
            })
            
        }
        let dictionary = NSMutableDictionary();
        
        dictionary["VkLogin"] = true
        dictionary["Email"] = VKSdk.accessToken().email
        let user = User(dictionary: dictionary)
        User.currentUser = user

        // leave login page
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
}
