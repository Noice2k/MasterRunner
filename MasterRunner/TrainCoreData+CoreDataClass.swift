//
//  TrainCoreData+CoreDataClass.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 09/03/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import Foundation
import CoreData

@objc(TrainCoreData)
public class TrainCoreData: NSManagedObject {

    class func startTrain (inPersistentContainer container: NSPersistentContainer ) -> TrainCoreData? {
        
        if let entity = NSEntityDescription.entity(forEntityName: "TrainCoreData", in: container.viewContext) {
            let newTrain = NSManagedObject(entity: entity, insertInto: container.viewContext) as? TrainCoreData
            
            newTrain?.caption = "Traint at \(NSDate())"
            
            return newTrain
        }
        
        return nil
        
    }
}
