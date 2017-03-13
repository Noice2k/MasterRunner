//
//  TrainPageViewController.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 02/02/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import UIKit
import Mapbox
import CoreData


class TrainPageViewController: BTViewController,MGLMapViewDelegate {

    
    // MARK: model
    
    var current_core_data_train : TrainCoreData?
    
    // MARK: - coredata
    var persistentContainer : NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setCenter(CLLocationCoordinate2D(latitude: 57.8220, longitude: 28.3317), animated: false)
        mapView.setZoomLevel(14, animated: false)
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBOutlet weak var bmpLabel: UILabel!
    @IBOutlet weak var mapView: MapView!
    
    @IBOutlet weak var buttonStop: BorderButton!
    @IBOutlet weak var buttonStart: BorderButton!
    // Do any additional setup after loading the view.
    
    
    @IBAction func onClickStopTrain(_ sender: UIButton) {
        buttonStop.isHidden = true
        buttonStart.isHidden = false
        //tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    @IBAction func onClickStartTrain(_ sender: UIButton) {
        buttonStop.isHidden = false
        buttonStart.isHidden = true
        tabBarController?.tabBar.isUserInteractionEnabled = false
        fetchcount()
        current_core_data_train = TrainCoreData.startTrain(inPersistentContainer: persistentContainer!)
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
     
        fetchcount()
    }
    
    func fetchcount()
    {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "TrainCoreData")
        if let results =  (try? persistentContainer?.viewContext.fetch(request)) {
            
            
            let fr = results?.last as? TrainCoreData
            if let data = fr?.heartbeat_data as NSData? {
                let d = data as Data
                var str = NSString(data: d, encoding: String.Encoding.utf8.rawValue)
                print("\(str)")
            }
            print("found \(fr?.heartbeat_data?.bytes) records")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func setBeatPerMinute(heartrate : Int , timestamp: NSDate) {
        bmpLabel.text = "\(heartrate)"
        if (current_core_data_train != nil)
        {
            current_core_data_train?.addHeartBeat(hbvalue: heartrate, timestamp: timestamp)
        }
    }
    
 }
