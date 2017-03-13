//
//  BTConroller.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 27/02/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import UIKit
import CoreBluetooth

class BTViewController : UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        heartBeatDevice = User.currentUser?.blueToothHBDevice
        
        
        if heartBeatDevice != nil {
            // start connecting to bluetooth HB device
            centralManager = CBCentralManager.init(delegate: self, queue: nil)
            BTFindDeviceLoop();
        }
    }
    
    // MARK: - CBCentralManagerDelegate
    
    // main manager
    var centralManager : CBCentralManager?
    // heart beat device attributes
    var heartBeatDevice : BTDevice?
    // servise type
    let serviseUUIDs:[CBUUID] = [CBUUID(string:"180D")]
    
    // device change state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case CBManagerState.poweredOff:
            print("poweredOff")
        case CBManagerState.poweredOn:
            print("poweredOn")
            //
            let lastPeripherals = centralManager?.retrieveConnectedPeripherals(withServices: serviseUUIDs)
            
            
            if (lastPeripherals?.count)! > 0 {
                for peripheral in lastPeripherals! {
                    
                    if peripheral.identifier == heartBeatDevice?.uuid {
                        // TODO: connect to device
                        connectingPeripheral = peripheral
                        connectingPeripheral.delegate = self
                        centralManager?.connect(connectingPeripheral, options: nil)
                    }
                }
            }
            else{
                if heartBeatDevice != nil {
                    // TODO: add sleep at least 5 seconds to reconnect to save battery
                    // start observing connecting to bluetooth HB device
                    centralManager?.scanForPeripherals(withServices: serviseUUIDs, options: nil)
                }
                
            }
        case CBManagerState.unsupported:
            print("unsupported")
        default:
            print("unknow")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.identifier == self.heartBeatDevice!.uuid! {
            
            // TODO: connect to device
            print(heartBeatDevice!.uuid!)
            
            connectingPeripheral = peripheral
            connectingPeripheral.delegate = self
            centralManager?.connect(connectingPeripheral, options: nil)
        }
        
    }
    // discover all services for
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        print("didconnect")
    }
    // disconnect device:
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disconnected")
        // connectingPeripheral = nil
        // reconect
        BTFindDeviceLoop()
        
    }
    
    
    
    // MARK: - CBPeripheralDelegate
    
    // loop function to reconnect Periphela if it was disconnedcted
    func BTFindDeviceLoop() {
        
        if self.heartBeatDevice != nil {
            if connectingPeripheral != nil {
                if connectingPeripheral.state == CBPeripheralState.disconnected {
                    centralManager?.connect(connectingPeripheral, options: nil)
                }
                // run self in 5 minutes
                let dispathTime = DispatchTime.now() + .seconds(5)
                DispatchQueue.main.asyncAfter(deadline: dispathTime, execute: {
                    self.BTFindDeviceLoop()
                })
            }
        }
    }
    
    // the peripheral device
    var connectingPeripheral : CBPeripheral!
    
    //
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let actualError = error {
            print(actualError)
        } else {
            for service in peripheral.services as [CBService]! {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    //
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let actualError = error {
            print(actualError)
        } else {
            if service.uuid == serviseUUIDs[0] {
                for charasteristic in service.characteristics as [CBCharacteristic]! {
                    switch charasteristic.uuid.uuidString  {
                    case "2A37":
                        //
                        print("found heart beat service")
                        peripheral.setNotifyValue(true, for: charasteristic)
                    default:
                        print(charasteristic.uuid.uuidString)
                    }
                }
            }
        }
    }
    
    // callback function - the peripheral return same data, we need processing it
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let actualError = error {
            print(actualError)
        } else
        {
            //  print("state: \(connectingPeripheral.state.rawValue)")
            let timestamp = NSDate()
            
            let heartRateData = characteristic.value!
            var buffer = [UInt8](repeating:0, count:heartRateData.count)
            heartRateData.copyBytes(to: &buffer, count: heartRateData.count)
            
            var bpm:UInt16?
            if (buffer.count >= 2){
                if (buffer[0] & 0x01 == 0){
                    bpm = UInt16(buffer[1]);
                }else {
                    bpm = UInt16(buffer[1]) << 8
                    bpm =  bpm! | UInt16(buffer[2])
                }
            }
            setBeatPerMinute(heartrate: Int(bpm!), timestamp: timestamp)
            //print(characteristic.value!)
        }
    }
    
    
    
    func setBeatPerMinute(heartrate : Int , timestamp: NSDate) {
        print("")
    }
}
