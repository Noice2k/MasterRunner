//
//  TrainCoreData+CoreDataProperties.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 30/03/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import Foundation
import CoreData


extension TrainCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainCoreData> {
        return NSFetchRequest<TrainCoreData>(entityName: "TrainCoreData");
    }

    @NSManaged public var avarage_bpm: Int16
    @NSManaged public var average_speed: Double
    @NSManaged public var caption: String?
    @NSManaged public var distance: Double
    @NSManaged public var fb_stored: Bool
    @NSManaged public var heartbeat_data: NSData?
    @NSManaged public var location_data: NSData?
    @NSManaged public var max_bpm: Int16
    @NSManaged public var max_speed: Double
    @NSManaged public var min_bpm: Int16
    @NSManaged public var min_speed: Double
    @NSManaged public var time: Double
    @NSManaged public var traindata: NSDate?
    @NSManaged public var screenshot: NSData?
    @NSManaged public var screenshot_width: Int16
    @NSManaged public var screenshot_heigth: Int16
    @NSManaged public var intervals: NSSet?

}

// MARK: Generated accessors for intervals
extension TrainCoreData {

    @objc(addIntervalsObject:)
    @NSManaged public func addToIntervals(_ value: TrainInterval)

    @objc(removeIntervalsObject:)
    @NSManaged public func removeFromIntervals(_ value: TrainInterval)

    @objc(addIntervals:)
    @NSManaged public func addToIntervals(_ values: NSSet)

    @objc(removeIntervals:)
    @NSManaged public func removeFromIntervals(_ values: NSSet)

}
