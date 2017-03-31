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
import MapboxStatic

class MapScreenShot
{
    func GetMapScreenShot(coreTrain : TrainCoreData) -> UIImage? {
        var resultImage : UIImage?
        // 1. calculate bounce
        let  coordinates = coreTrain.getAllCoordinates2D()
        if (coordinates.count<2)
        {
            return nil
        }
        //let geoJsonString = coreTrain.getGeoJsonString()
        let bounds = getCoordinateBounds(coordinates : coordinates)
        
        let geoJsonString = boundsToGeoString(bounds: bounds!)
        // 2. get image map
        let dx = (bounds!.ne.longitude - bounds!.sw.longitude)
        let dy = (bounds!.ne.latitude  - bounds!.sw.latitude)
        let x = bounds!.ne.longitude - dx/2
        let y = bounds!.ne.latitude - dy/2
        
        // calculate size in pixes to show with max zoom
        let px = (dx / 0.0005) + 20
        let py = (dy / 0.0005) + 20
        let zoom = 12.0
        
        let ppm = 63727982.0 * cos(y)/pow(2, zoom+8)
        let ppm1 = 63727982.0 / pow(2, zoom+8)
        
        
        let l1 = CLLocation(latitude: bounds!.sw.longitude, longitude: bounds!.ne.latitude)
        let l2 = CLLocation(latitude: bounds!.ne.longitude, longitude: bounds!.ne.latitude)
        
        let dis = l1.distance(from: l2)
        
        let camera = SnapshotCamera(lookingAtCenter: CLLocationCoordinate2DMake(y, x), zoomLevel : 12)
        let json = GeoJSON(objectString: geoJsonString)
        let options = SnapshotOptions(styleURL: URL(string: "mapbox://styles/mapbox/streets-v9")!, camera: camera, size: CGSize(width: 200, height: 200))
        options.overlays.append(json)
        let snapshot = Snapshot(options: options, accessToken: "pk.eyJ1Ijoibm9pY2UyayIsImEiOiJjaXRwaG9wZTIwMDBmMnlwZmQ2MWp3ZG1rIn0.jG6g5nKhHJUz35S9AWrjHA")
        return snapshot.image
        
        let stringUrl = "https://api.mapbox.com/styles/v1/mapbox/streets-v9/static/\(x),\(y),\(zoom)/200x200@2x?access_token=pk.eyJ1Ijoibm9pY2UyayIsImEiOiJjaXRwaG9wZTIwMDBmMnlwZmQ2MWp3ZG1rIn0.jG6g5nKhHJUz35S9AWrjHA"

        let imageUrl = URL(string: stringUrl)
        if  let imageData = try? Data(contentsOf: imageUrl!) {
            resultImage = UIImage(data: imageData)
            // check the image
            if resultImage!.size.width > 0 {
                
            }
        }
        // 3. draw
        return resultImage

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
    
    func boundsToGeoString(bounds : MGLCoordinateBounds ) -> String {
        var geoString = "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"properties\":{\"stroke\":\"#00f\",\"stroke-width\": 3,\"stroke-opacity\":1},\"geometry\": { \"type\": \"LineString\",        \"coordinates\": ["
        
        geoString += "[\(bounds.sw.longitude),\(bounds.ne.latitude)],"
        geoString += "[\(bounds.ne.longitude),\(bounds.ne.latitude)],"
        geoString += "[\(bounds.ne.longitude),\(bounds.sw.latitude)],"
        geoString += "[\(bounds.sw.longitude),\(bounds.sw.latitude)],"
        geoString += "[\(bounds.sw.longitude),\(bounds.ne.latitude)]"
        geoString += "]}}]}"
        return geoString
    }
}

// coordinames : [CLLocationCoordinate2D]
