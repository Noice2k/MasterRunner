//
//  SettingsViewController.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 26/12/2016.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit
import VK_ios_sdk
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func ForceLogOut(_ sender: Any) {
        
        VKSdk.forceLogout()
        do {
            try FIRAuth.auth()?.signOut()
        } catch  {
        }
        
        User.currentUser = nil
        
        parent?.dismiss(animated: true, completion: {})
        
    }
}
