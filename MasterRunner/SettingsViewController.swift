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

class SettingsViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate {

    var manager : CBCentralManager?
    var connectingPerioherel : CBPeripheral?
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CBCentralManager.init(delegate: self, queue: nil)
    
        manager?.scanForPeripherals(withServices: nil, options: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    var datas = [String : String]()
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        
        let key = peripheral.identifier.uuidString
        let data = advertisementData.description

        if let servises = peripheral.services {
            for service in servises {
                print(service.uuid.uuidString)
            }
        }
        if let previous = datas[key] {
            if (previous != data) {
                print("Different \(peripheral.name): \(data)")
            }
        } else {
            print("\(peripheral.name): \(data)");
            datas[key] = data
        }
        
        if let name = peripheral.name {
         print(name)
            
        }
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case CBManagerState.poweredOff:
            print("poweredOff")
        case CBManagerState.poweredOn:
            print("poweredOn")
            // servise type
            let serviseUUIDs:[CBUUID] = [CBUUID(string:"180D")]
            //
            let lastPeripherals = manager?.retrieveConnectedPeripherals(withServices: serviseUUIDs)
            
            
            if (lastPeripherals?.count)! > 0 {
                let device = (lastPeripherals?.last)! as CBPeripheral
                connectingPerioherel = device
                manager?.connect(connectingPerioherel!, options: nil)
             }
            else{
                manager?.scanForPeripherals(withServices: serviseUUIDs, options: nil)
            }
            
        
        case CBManagerState.unsupported:
            print("unsupported")
        default:
            print("unknow")
        }
    }

    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        connectingPerioherel = peripheral
        connectingPerioherel?.delegate = self
        manager?.connect(connectingPerioherel!, options: nil)
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
     
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
