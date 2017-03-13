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
        let tempstr = "'\(timestamp)' : '\(hbvalue)',"
        hbCurrentJsonString += tempstr
        // each 10 valus we convert this shit to json and store as nsData
        if heartbeats.count % 10 == 0 {
           let tempdata = NSMutableData()
            if heartbeat_data != nil {
                tempdata.append(heartbeat_data as Data!)
            }
            tempdata.append(Data(hbCurrentJsonString.utf8))
            heartbeat_data = tempdata
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }
        
        
    }
}
