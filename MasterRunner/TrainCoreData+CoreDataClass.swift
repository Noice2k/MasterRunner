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

@objc(TrainCoreData)
public class TrainCoreData: NSManagedObject {

    class func startTrain (inPersistentContainer container: NSPersistentContainer ) -> TrainCoreData? {
        if let entity = NSEntityDescription.entity(forEntityName: "TrainCoreData", in: container.viewContext) {
            if let newTrain = NSManagedObject(entity: entity, insertInto: container.viewContext) as? TrainCoreData {
                newTrain.traindata = NSDate()
                newTrain.caption = "Traint at \(newTrain.traindata)"
                return newTrain
            }
        }
        return nil
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
        var tmpStr = "{\"loc.lat\":\"\(locPoint.coordinate.latitude)\",\"loc.long\":\"\(locPoint.coordinate.longitude)\",\"time\":\"\(locPoint.timestamp)\""
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
            hbCurrentJsonString.insert("[", at: locCurrentJsonString.startIndex)
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
        hbCurrentJsonString += "{\"loc.lat\":\"0.0\",\"loc.long\":\"0.0\",\"time\":\"\(Date())\"}]"
        updateLocationPoints()
        
        // just for debug
        let d = location_data! as Data
        let  str = NSString(data: d, encoding: String.Encoding.utf8.rawValue)
        print(str!)
    }
}
