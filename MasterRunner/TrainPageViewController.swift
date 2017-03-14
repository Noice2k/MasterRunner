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
import CoreLocation

class TrainPageViewController: BTViewController,MGLMapViewDelegate, CLLocationManagerDelegate {

    
    // MARK: model
    
    var current_core_data_train : TrainCoreData?
    
    // MARK: - coredata
    var persistentContainer : NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var locationMamager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setCenter(CLLocationCoordinate2D(latitude: 57.8220, longitude: 28.3317), animated: false)
        mapView.setZoomLevel(14, animated: false)
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // setup location manager
        self.locationMamager.requestAlwaysAuthorization()
        self.locationMamager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationMamager.delegate = self
            locationMamager.desiredAccuracy = kCLLocationAccuracyBest
            locationMamager.startUpdatingLocation()
        }
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
        current_core_data_train?.closeHeartBeat()
        tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    @IBAction func onClickStartTrain(_ sender: UIButton) {
        buttonStop.isHidden = false
        buttonStart.isHidden = true
        tabBarController?.tabBar.isUserInteractionEnabled = false
        
        current_core_data_train = TrainCoreData.startTrain(inPersistentContainer: persistentContainer!)
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
     
        
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
    
    
    // MARK: location manager routing
    
    // processing the location change
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for loc in locations {
            mapView.longitude = loc.coordinate.longitude
            mapView.latitude  = loc.coordinate.latitude
            
            /*// add coordinate to Tracker
            if trackingUser {
                if distanceForMarker <= totalDistance {
                    // add  annotation with point
                    let annotation = MGLPointAnnotation()
                    annotation.coordinate =  loc.coordinate
                    annotation.title = "\(Int(distanceForMarker/1000))"
                    openBoxMapView.addAnnotation(annotation)
                    // increase distance
                    distanceForMarker += 1000
                    
                }
                currentLap?.points += [loc]
                currentTrack += [CLLocationCoordinate2DMake( loc.coordinate.latitude, loc.coordinate.longitude)]
                if lastLoc != nil {
                    let dist = loc.distance(from: lastLoc!)
                    totalDistance += dist
                    labelTrainDistance.text = totalDistance.to2dig()
                    print(dist)
                    print("location : \(loc.coordinate.longitude)-\(loc.coordinate.latitude)")
                }
                // update
                let line = MGLPolyline(coordinates: &currentTrack, count: UInt(currentTrack.count))
                line.title = currentLap?.name
                openBoxMapView.addAnnotation(line)}
            lastLoc = loc
            */
            
            // set
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
