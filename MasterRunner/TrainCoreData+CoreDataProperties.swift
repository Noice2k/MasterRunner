//
//  TrainCoreData+CoreDataProperties.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 09/03/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import Foundation
import CoreData


extension TrainCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainCoreData> {
        return NSFetchRequest<TrainCoreData>(entityName: "TrainCoreData");
    }

    @NSManaged public var traindata: NSDate?
    @NSManaged public var caption: String?
    @NSManaged public var max_bpm: Int16
    @NSManaged public var avarage_bpm: Int16
    @NSManaged public var distance: Double
    @NSManaged public var max_speed: Double
    @NSManaged public var min_speed: Double
    @NSManaged public var heartbeat_data: NSData?
    @NSManaged public var time: Double
    @NSManaged public var min_bpm: Int16
    @NSManaged public var location_data: NSData?
    @NSManaged public var fb_stored: Bool

}
