//
//  TrainInterval+CoreDataProperties.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 23/03/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import Foundation
import CoreData

extension TrainInterval {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainInterval> {
        return NSFetchRequest<TrainInterval>(entityName: "TrainInterval");
    }

    @NSManaged public var distance: Double
    @NSManaged public var start_timestamp: NSDate?
    @NSManaged public var stop_timestamp: NSDate?
    @NSManaged public var train: TrainCoreData?

}
