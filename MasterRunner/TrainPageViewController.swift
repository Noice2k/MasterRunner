//
//  TrainPageViewController.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 02/02/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import UIKit
import Mapbox
import CoreBluetooth

class TrainPageViewController: UIViewController,MGLMapViewDelegate,CBCentralManagerDelegate, CBPeripheralDelegate {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setCenter(CLLocationCoordinate2D(latitude: 57.8220, longitude: 28.3317), animated: false)
        mapView.setZoomLevel(14, animated: false)
        mapView.delegate = self
        // Do any additional setup after loading the view.
        
        heartBeatDevice = User.currentUser?.blueToothHBDevice
        
        
        if heartBeatDevice != nil {
            // start connecting to bluetooth HB device
            centralManager = CBCentralManager.init(delegate: self, queue: nil)
            BTFindDeviceLoop();
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var mapView: MGLMapView!

    
    // Do any additional setup after loading the view.
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
        connectingPeripheral = nil
        // reconect 
        BTFindDeviceLoop()
        
    }

    
    
    // MARK: - CBPeripheralDelegate
    
    
    func BTFindDeviceLoop() {
        if self.heartBeatDevice != nil {
            if connectingPeripheral == nil {
                
                let lastPeripherals = centralManager?.retrieveConnectedPeripherals(withServices: serviseUUIDs)
                
                centralManager?.scanForPeripherals(withServices: serviseUUIDs, options: nil)
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
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let actualError = error {
            print(actualError)
        } else {
            if service.uuid == serviseUUIDs[0] {
                for charasteristic in service.characteristics as [CBCharacteristic]! {
                    switch charasteristic.uuid.uuidString  {
                    case "2A37":
                        // 
                        print("found")
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
            
            processingPeripheralData(heartRateData: characteristic.value!)
            //print(characteristic.value!)
        }
    }
    
    
    func processingPeripheralData(heartRateData: Data){
        
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
        
        if let actualBpm = bpm{
            print("\(bpm!)")
        }else {
            print("\(bpm!)")
        }
    }
 }
