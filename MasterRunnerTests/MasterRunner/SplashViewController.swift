//
//  SplashViewController.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 14/12/2016.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit
import VK_ios_sdk

class SplashViewController: UIViewController, FirebaseLoginDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!appDelegate.splashDelay) {
            // check
            delay(delay: 1, closure: {
                
                
                self.continueLogin()
            })
        }
    }
    
    func goToLogin(){
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    func goToApp() {
         self.performSegue(withIdentifier: "ShowMainTabWindow", sender: self)
    }
    
    func continueLogin() {
        
        appDelegate.splashDelay = false
        
        if User.currentUser == nil {
            // show login offer
            self.goToLogin()
        } else {
            NSLog("authorized")
            goToApp()

        }
        
/*        // try to auto login to
        VKSdk.wakeUpSession(scope, complete: {(state: VKAuthorizationState, error: Error?) -> Void in
            if state == .authorized {
                // auto autotization ok, init user
                
            } else {
            }
            return
        })
 */

        
        
       
    }
    
}
