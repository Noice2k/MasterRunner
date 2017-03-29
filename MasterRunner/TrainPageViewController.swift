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
    var needRecordTrain : Bool = false
    var totalDistance : Double = 0.0
    var totalTime : Int = 0
    var startTime = NSDate()
    var onPauseState : Bool  = false {
        didSet {
            let name =  onPauseState ? "ContinueTrain" : "PauseTrain"
            buttonPause.setImage(UIImage(named: name) , for: UIControlState.normal)
        }
    }
    
    var allIntervalsLine =  [MGLPolyline]()
    var currentTrack: [CLLocationCoordinate2D] = []
    var currentPolyLine : MGLPolyline?
   
    
    
    // MARK: - coredata
    var persistentContainer : NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    var locationMamager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.setCenter(CLLocationCoordinate2D(latitude: 57.8220, longitude: 28.3317), animated: false)
        mapView.setZoomLevel(14, animated: false)
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        
        buttonPause.isHidden = true
        buttonStop.isHidden  = true
        
        // setup location manager
        self.locationMamager.requestAlwaysAuthorization()
        self.locationMamager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationMamager.delegate = self
            locationMamager.desiredAccuracy = kCLLocationAccuracyBest
            locationMamager.startUpdatingLocation()
        }
        
        distanceLabel.text = "0.00"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    var timer = Timer()
    func timerUpdate() {
        let current = Date()
        let time = current.timeIntervalSince(startTime as Date)
        let timeInt = Int(time)
        
        timerLabel.text = timeInt.ToTime()
    }
    
   
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bmpLabel: UILabel!
    @IBOutlet weak var mapView: MapView!
    
    
    @IBOutlet weak var buttonPause: BorderButton!
    @IBOutlet weak var buttonStop: BorderButton!
    @IBOutlet weak var buttonStart: BorderButton!
    // Do any additional setup after loading the view.
    
    
    
    // On Stop Training
    @IBAction func onClickStopTrain(_ sender: UIButton) {
        buttonStop.isHidden = true
        buttonStart.isHidden = false
        buttonPause.isHidden = true
        //tabBarController?.tabBar.isHidden = false
        current_core_data_train?.EndTrain()
        tabBarController?.tabBar.isUserInteractionEnabled = true
        needRecordTrain = false
        timer.invalidate()
        onPauseState = false;
    }
    
    // On Pause/UnPause
    @IBAction func onClickPauseTrain(_ sender: UIButton) {
        onPauseState = !onPauseState
        
        if onPauseState == false {
            current_core_data_train?.StartInterval()
            addNewTrack()
        } else {
           current_core_data_train?.EndInterval()
        }
        
        
    }
    
    @IBAction func onClickStartTrain(_ sender: UIButton) {
        buttonStop.isHidden = false
        buttonStart.isHidden = true
        buttonPause.isHidden = false
        
        tabBarController?.tabBar.isUserInteractionEnabled = false
        
        current_core_data_train = TrainCoreData.startTrain(inPersistentContainer: persistentContainer!)
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        needRecordTrain = true
        totalDistance = 0
        lastLocation = nil
        totalTime = 0
        startTime = NSDate()
        onPauseState = false
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
        
        
        // create new polyline for map
        addNewTrack()
        
    }
    
    func addNewTrack()
    {
        currentTrack.removeAll()
        currentPolyLine = MGLPolyline(coordinates: &currentTrack, count: UInt(currentTrack.count))
        currentPolyLine!.title = "Interval#\(allIntervalsLine.count)"
        allIntervalsLine.append(currentPolyLine!)
    }
    
    func addPointToCurrentTrack(point : CLLocation) {
        currentTrack += [CLLocationCoordinate2DMake( point.coordinate.latitude, point.coordinate.longitude)]
        let newline = MGLPolyline(coordinates: &currentTrack, count: UInt(currentTrack.count))
        newline.title = "Interval#\(allIntervalsLine.count)"
        allIntervalsLine.remove(at: allIntervalsLine.count-1)
        allIntervalsLine.append(newline)
        
        if currentPolyLine != nil {
            mapView.removeAnnotation(currentPolyLine!)
        }
        mapView.addAnnotation(newline)
        currentPolyLine = newline
    }
    
    func fetchcount()
    {
       /* let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "TrainCoreData")
        if let results =  (try? persistentContainer?.viewContext.fetch(request)) {
            
            
            let fr = results?.last as? TrainCoreData
            if let data = fr?.heartbeat_data as NSData? {
                let d = data as Data
                var str = NSString(data: d, encoding: String.Encoding.utf8.rawValue)
                print("\(str)")
            }
            print("found \(fr?.heartbeat_data?.bytes) records")
        }
 */
    }
    
    
    // MARK: location manager routing
    
    var lastLocation : CLLocation?
    
    
    func updateDistance() {
        distanceLabel.text = "\((totalDistance/1000).toStringFormat(fraction: 2))"
        if current_core_data_train != nil {
            current_core_data_train?.distance = totalDistance
        }
    }
    
    func calculateCurrentSpeed(loc1 : CLLocation?, loc2: CLLocation ) {
        var speed : Double
        if  loc1 != nil {
            let distance = loc2.distance(from: loc1!)
            let time = loc2.timestamp.timeIntervalSince(loc1!.timestamp as Date)
            speed = distance/time
        } else {
            speed = loc2.speed
        }
        // convert speed from meter per second to the minutes per kilometr
        if speed > 0 {
            speed = 1000/(speed)
        }
        speedLabel.text = speed.toMinPerKm()
        
    }
    
    // processing the location change
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for loc in locations {
            mapView.longitude = loc.coordinate.longitude
            mapView.latitude  = loc.coordinate.latitude
            if needRecordTrain {
                calculateCurrentSpeed(loc1:lastLocation, loc2: loc)
                if lastLocation != nil {
                    totalDistance += loc.distance(from: lastLocation!)
                    updateDistance()
                }
                lastLocation = loc
                current_core_data_train?.addLocationPoint(locPoint: loc)
                // add new point to track
                if (onPauseState == false) {
                    addPointToCurrentTrack(point: loc)
                }
                
            }
            
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

extension Int {
    
    func to2dig() -> String
    {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        return formatter.string(from: self as NSNumber)!
    }
    
    func ToTime() -> String{
        let hours = self / 3600
        let min = (self/60) % 60
        let sec = self % 60
        return "\(hours.to2dig()):\(min.to2dig()):\(sec.to2dig())"
    }
}

extension Double {
    func toStringFormat(fraction: Int) -> String
    {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fraction
        formatter.maximumFractionDigits = fraction
        formatter.minimumIntegerDigits = 1
        return formatter.string(from: self as NSNumber)!
    }
    
    func toMinPerKm() -> String {
        let minutes = Int(self / 60)
        var second = Int(self)
        second =  second % 60
        return "\(minutes):\(second.to2dig())"
    }
}

/*
extension UITableViewController {
    func ShowMessageBox()
}
 */
