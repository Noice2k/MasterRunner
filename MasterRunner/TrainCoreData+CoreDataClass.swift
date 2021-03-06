//
//  TrainCoreData+CoreDataClass.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 09/03/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import JavaScriptCore
import CoreLocation


//  this entyty uses for save start/stop interval times
//  all data, such as heartbeat/locations/ect savein main entity

@objc(TrainCoreData)
public class TrainCoreData: NSManagedObject {

    class func startTrain (inPersistentContainer container: NSPersistentContainer ) -> TrainCoreData? {
        if let entity = NSEntityDescription.entity(forEntityName: "TrainCoreData", in: container.viewContext) {
            if let newTrain = NSManagedObject(entity: entity, insertInto: container.viewContext) as? TrainCoreData {
                newTrain.traindata = NSDate()
                newTrain.caption = "Train at \(newTrain.traindata!)"
                newTrain.StartInterval()
                return newTrain
            }
        }
        return nil
    }
    
    
    func EndTrain(){
        EndInterval()
        closeHeartBeat()
        closeLocationPoints()
    }
    
    // MARK: Interval
    
    func StartInterval(){
        
        if currentInterval != nil {
            EndInterval()
        }
        
        // inititilize variables
        let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        let interval_entity = NSEntityDescription.entity(forEntityName: "TrainInterval", in: container!.viewContext)
        let interval = NSManagedObject(entity: interval_entity!, insertInto: container!.viewContext) as? TrainInterval
        // init interval values
        interval?.start_timestamp = NSDate()
        interval?.distance = 0;
        interval?.stop_timestamp = NSDate()
        // set the current interval
        currentInterval = interval
        addToIntervals(interval!)
    }
    
    func EndInterval(){
        // save the last time to acces to the interval
        currentInterval?.stop_timestamp = NSDate()
        print("\(currentInterval!.stop_timestamp)")
        currentInterval = nil
    }
    
    
    // MARK: HeartBeat
    
    struct heartBeatValue {
        var time: NSDate
        var value: Int
        init (_value: Int, _time : NSDate) {
            time = _time
            value = _value
        }
        
    }
    
    var currentInterval : TrainInterval?
    
    var hbCurrentJsonString = ""
    var heartbeats: [heartBeatValue] = []
    
    func addHeartBeat(hbvalue : Int, timestamp: NSDate) {
        
        
        // add heartbeat to array
        heartbeats += [heartBeatValue(_value: hbvalue, _time : timestamp)]
        // convert to the json part string
        let tempstr = "{\"\(timestamp)\" : \"\(hbvalue)\"},"
        hbCurrentJsonString += tempstr
        // each 10 valus we convert this shit to json and store as nsData
        if heartbeats.count % 10 == 0 {
           updateHearBeat()
        }
        
    }
    
    func closeHeartBeat()
    {
        // add one empty value and close marker
        hbCurrentJsonString += "{\"0\":\"0\"}]"
        updateHearBeat()
        
        // just for debug
        let d = heartbeat_data! as Data
        let  str = NSString(data: d, encoding: String.Encoding.utf8.rawValue)
        print(str!)
    }
    
    // Update heartbeat data in CoreData storage
    func  updateHearBeat() {
        let tempdata = NSMutableData()
        if heartbeat_data != nil {
            tempdata.append(heartbeat_data as Data!)
        }
        else {
            // add begin array marker if we try store first data to this field
            hbCurrentJsonString.insert("[", at: hbCurrentJsonString.startIndex)
        }
        // append old data, and save it
        tempdata.append(Data(hbCurrentJsonString.utf8))
        heartbeat_data = tempdata
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        // reset temp string
        hbCurrentJsonString = ""
        
    }
    
    // MARK: Location
    
    var locCurrentJsonString = ""
    var locationPoints: [CLLocation] = []
    
    func addLocationPoint(locPoint : CLLocation) {
        // add to array
        locationPoints += [locPoint]
        // add to json store string
        var tmpStr = "{\"loc.lat\":\"\(locPoint.coordinate.latitude)\",\"loc.long\":\"\(locPoint.coordinate.longitude)\",\"time\":\"\(locPoint.timestamp)\","
        tmpStr += "\"loc.alt\":\"\(locPoint.altitude)\",\"loc.hacc\":\"\(locPoint.horizontalAccuracy)\",\"loc.vacc\":\"\(locPoint.verticalAccuracy)\","
        tmpStr += "\"loc.speed\":\"\(locPoint.speed)\",\"loc.course\":\"\(locPoint.course)\"},"
        locCurrentJsonString += tmpStr
        
        if locationPoints.count % 10 == 0 {
            updateLocationPoints()
        }
    }
    
    // Update location data in CoreData storage
    func updateLocationPoints() {
        let tempdata = NSMutableData()
        if location_data != nil {
            // safe current data
            tempdata.append(location_data as Data!)
        }
        else {
            // add begin array marker if we try store first data to this field
            locCurrentJsonString.insert("[", at: locCurrentJsonString.startIndex)
        }
        // append old data, and save it
        tempdata.append(Data(locCurrentJsonString.utf8))
        location_data = tempdata
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        // reset temp string
        locCurrentJsonString = ""
    }
    
    // close the train
    func closeLocationPoints()
    {
        // add one empty value and close marker
        locCurrentJsonString += "{\"loc.lat\":\"0.0\",\"loc.long\":\"0.0\",\"time\":\"\(Date())\"}]"
        updateLocationPoints()
        
        // just for debug
        let d = location_data! as Data
        let  str = NSString(data: d, encoding: String.Encoding.utf8.rawValue)
        print(str!)
    }
    
    
    func getAllCoordinates2D () -> [CLLocationCoordinate2D]
    {
        var coordinates = [CLLocationCoordinate2D]()
        // 
        if location_data != nil {
            let json = try? JSONSerialization.jsonObject(with: location_data! as Data, options: [])
            if json != nil {
                if let items = json as? NSArray {
                    for item in items {
                        if let loc = item as? [String:String] {
                            let long = loc["loc.long"]!
                            if long != "0.0" {
                                let long = Double(loc["loc.long"]!)
                                let lant = Double(loc["loc.lat"]!)
                                coordinates += [CLLocationCoordinate2DMake(lant!, long!)]
                            }
                        }
                    }
                }
            }
        }
        return coordinates
    }
    
    
    /*
     
     
     let string = "{  \"type\": \"FeatureCollection\",  \"features\": [    {      \"type\": \"Feature\",      \"properties\": {        \"stroke\": \"#00f\",        \"stroke-width\": 3,        \"stroke-opacity\": 1      },      \"geometry\": {        \"type\": \"LineString\",        \"coordinates\": [          [            -122.40106959,            37.57843435          ],          [            -122.44106959,            37.53843435          ]        ]      }    }  ]}"
     
     */
    
    func getGeoJsonString() ->String {
        var geoString = "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"stroke\":\"#00f\",\"stroke-width\": 3,\"stroke-opacity\":1},\"geometry\": { \"type\": \"LineString\",        \"coordinates\": ["
      
        let json = try? JSONSerialization.jsonObject(with: location_data! as Data, options: [])
        if json != nil {
            if let items = json as? NSArray {
                for item in items {
                    if let loc = item as? [String:String] {
                        let long = loc["loc.long"]!
                        let lant = loc["loc.lat"]!
                        if long != "0.0" {
                            geoString += "[\(long),\(lant)],"
                        }
                        else {
                            geoString.characters = geoString.characters.dropLast()
                        }
                        
                    }
                }
            }
        }
        geoString += "]}}]}"

        
        return geoString
        
    }
    
    func exportLocationDataToFile() {
        if  let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let path = dir.appendingPathComponent("\(traindata!).json")
            do {
                try location_data?.write(to: path, options: NSData.WritingOptions.atomicWrite)
            }
            catch {}
        }
            
        
        
    }
    
}
