//
//  BTSourceList.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 31/01/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore


class BTDevice {
    var name: String = ""
    var uuid : UUID?
}


// deletage
protocol BTDeviceSelect {
    // update data after all news
    func OnBlueToothDeviceSelected(device: BTDevice?)
}

class BTSourceList: UITableViewController,CBCentralManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // initilize
        centralManager = CBCentralManager.init(delegate: self, queue: nil)
        // start run check
        
        if centralManager?.state == CBManagerState.poweredOn {
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - delegate
    var delegate: BTDeviceSelect?
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return btDevices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "btDeviceCell", for: indexPath) as! BTDeviceCell

        cell.deviceNameLabel.text = btDevices[indexPath.row].name
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = "выбрать устройство"
        let text = "Вы хотите использовать это устройсво для измерения пульса во время тренировок?"
        let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.alert)
        
        currentDevice = btDevices[indexPath.row]
        // add actions
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (_ : UIAlertAction) in
                self.currentDevice = nil
            } ))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(_ : UIAlertAction) in
            do {
                self.delegate?.OnBlueToothDeviceSelected(device: self.currentDevice)
                self.navigationController!.popToRootViewController(animated: true)
            }
            
        } ))

        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Model
    var centralManager : CBCentralManager?
    var btDevices = [BTDevice]()
    var currentDevice : BTDevice?
    
    
    // MARK: - BlueTooth Central manager

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case CBManagerState.poweredOff:
            print("poweredOff")
        case CBManagerState.poweredOn:
            print("poweredOn")
            // servise type
            let serviseUUIDs:[CBUUID] = [CBUUID(string:"180D")]
            //
            let lastPeripherals = centralManager?.retrieveConnectedPeripherals(withServices: serviseUUIDs)
            
            //
            btDevices.removeAll()
            
            if (lastPeripherals?.count)! > 0 {
                for device in lastPeripherals! {
                    let btdevice = BTDevice()
                    btdevice.name = device.name!
                    btdevice.uuid = device.identifier
                    print(btdevice.uuid!.uuidString)
                    
                    btDevices += [btdevice]
                }
                tableView.reloadData()
            }
            else{
                centralManager?.scanForPeripherals(withServices: serviseUUIDs, options: nil)
            }
            
            
        case CBManagerState.unsupported:
            print("unsupported")
        default:
            print("unknow")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let btdevice = BTDevice()
        btdevice.name = peripheral.name!
        btdevice.uuid = peripheral.identifier
        print(btdevice.uuid!.uuidString)
        btDevices += [btdevice]
        tableView.reloadData()

    }
    
}
