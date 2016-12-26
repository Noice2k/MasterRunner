//
//  SplashViewController.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 14/12/2016.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, FirebaseLoginDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!appDelegate.splashDelay) {
            delay(delay: 1, closure: {
                self.continueLogin()
            })
        }
    }
    
    func goToLogin(){
        self.performSegue(withIdentifier: "LoginSegue", sender: self)
    }
    
    func continueLogin() {
        appDelegate.splashDelay = false
        self.goToLogin()
    }
    
}
