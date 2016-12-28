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

class LoginViewController: UIViewController , VKSdkDelegate, VKSdkUIDelegate{
    
    //static let instanceLoginVC? : LoginViewController

    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.initUser()
                self.dismiss(animated: true)
                
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
        initUser()
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
        
        self.dismiss(animated: true)
        print(result)
        
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
     
        show(controller, sender: self)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
    
    func initUser()  {
        let dictionary = NSDictionary();
        
        let user = User(dictionary: dictionary)
        User.currentUser = user
    }
}
