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

class TrainPageViewController: UIViewController,MGLMapViewDelegate,CBCentralManagerDelegate {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setCenter(CLLocationCoordinate2D(latitude: 57.8220, longitude: 28.3317), animated: false)
        mapView.setZoomLevel(14, animated: false)
        mapView.delegate = self
        // Do any additional setup after loading the view.
        
        if heartBeatDevice != nil {
            // start connecting to bluetooth HB device
            centralManager = CBCentralManager.init(delegate: self, queue: nil)
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
                for device in lastPeripherals! {
                    
                    if device.identifier == heartBeatDevice?.uuid {
                        // TODO: connect to device
                    }
                }
            }
            else{
                if heartBeatDevice != nil {
                    // start connecting to bluetooth HB device
                    centralManager = CBCentralManager.init(delegate: self, queue: nil)
                }
                
            }
        case CBManagerState.unsupported:
            print("unsupported")
        default:
            print("unknow")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.identifier == heartBeatDevice?.uuid {
            // TODO: connect to device
        }
    }
    
}
