//
//  MapScreenShot.swift
//  MasterRunner
//
//  Created by Igor Sinyakov on 30/03/2017.
//  Copyright © 2017 Igor Sinyakov. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Mapbox

class MapScreenShot
{
    func GetMapScreenShot(coreTrain : TrainCoreData) -> UIImage? {
        // 1. calculate bounce
        let coordinates = coreTrain.getAllCoordinates2D()
        let bounds = getCoordinateBounds(coordinates : coordinates)
        // 2. get image map
        let dx = abs(bounds!.ne.longitude - bounds!.sw.longitude)
        let dy = abs(bounds!.ne.latitude  - bounds!.sw.latitude)
        let x = bounds!.ne.longitude + dx/2
        let y = bounds!.ne.latitude - dx/2
        
        // calculate size in pixes to show with max zoom
        let px = (dx / 0.0005) + 20
        let py = (dy / 0.0005) + 20
        
        
        
        
        
        
        // 3. draw
        
        return nil
    }
    
    func getCoordinateBounds(coordinates: [CLLocationCoordinate2D]) -> MGLCoordinateBounds?{
        var bounds : MGLCoordinateBounds?
        if (coordinates.count > 1){
            for index in 0...coordinates.count-2 {
                if (bounds == nil) {
                    let c = coordinates.first!
                    bounds = MGLCoordinateBounds(sw: c, ne: c)
                } else {
                    // check the North coordinate
                    if (bounds!.ne.latitude < coordinates[index].latitude) { bounds!.ne.latitude = coordinates[index].latitude }
                    // check the South coordinate
                    if (bounds!.sw.latitude > coordinates[index].latitude) { bounds!.sw.latitude = coordinates[index].latitude }
                    // check the West coordinate
                    if (bounds!.sw.longitude > coordinates[index].longitude) { bounds!.sw.longitude = coordinates[index].longitude }
                    // check the East coordinate
                    if (bounds!.ne.longitude < coordinates[index].longitude) { bounds!.ne.longitude = coordinates[index].longitude }
                }
            }
        }
        return bounds
    }
}

// coordinames : [CLLocationCoordinate2D]
