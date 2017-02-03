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
import CoreBluetooth
import QuartzCore

class SettingsViewController: UIViewController, BTDeviceSelect {

    override func viewDidLoad() {
        super.viewDidLoad()
        let text = User.currentUser?.blueToothHBDevice?.name
        btDeviceButton.setTitle(text, for: .normal)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseBTDeviceSegue" {
            if let tvc = segue.destination as? BTSourceList {
                tvc.delegate = self
            }
        }
    }
    // MARK: - change the BT heart beat device 
    func OnBlueToothDeviceSelected(device: BTDevice?){
        User.currentUser?.blueToothHBDevice = device
        let name = User.currentUser?.blueToothHBDevice?.name
        btDeviceButton.titleLabel?.text = name
        view.setNeedsDisplay()
    }
    
    @IBOutlet weak var btDeviceButton: UIButton!
}
