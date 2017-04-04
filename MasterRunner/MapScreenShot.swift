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
        
        coreTrain.exportLocationDataToFile()
       
        let  coordinates = coreTrain.getAllCoordinates2D()
        if (coordinates.count<2)
        {
            return nil
        }
        
        coreTrain.exportLocationDataToFile()
        //let geoJsonString = coreTrain.getGeoJsonString()
        let bounds = getCoordinateBounds(coordinates : coordinates)
        
        let geoJsonString = boundsToGeoString(bounds: bounds!)
        // 2. get image map
        let dx = (bounds!.ne.longitude - bounds!.sw.longitude)
        let dy = (bounds!.ne.latitude  - bounds!.sw.latitude)
        let x = bounds!.ne.longitude - dx/2
        let y = bounds!.ne.latitude - dy/2
        let center : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: y, longitude: x)
        
        
        // calculate size in pixes to show with max zoom
        let zoom = 14.0
        
        
        let l1 = CLLocation(latitude: bounds!.sw.longitude, longitude: bounds!.ne.latitude)
        let l2 = CLLocation(latitude: bounds!.ne.longitude, longitude: bounds!.ne.latitude)
        
        let dis = l1.distance(from: l2)
        
      let camera = SnapshotCamera(lookingAtCenter: CLLocationCoordinate2DMake(y, x), zoomLevel : CGFloat(zoom))
        let json = GeoJSON(objectString: geoJsonString)
        let options = SnapshotOptions(styleURL: URL(string: "mapbox://styles/mapbox/streets-v9")!, camera: camera, size: CGSize(width: 200, height: 200))
//options.overlays.append(json)
        let snapshot = Snapshot(options: options, accessToken: "pk.eyJ1Ijoibm9pY2UyayIsImEiOiJjaXRwaG9wZTIwMDBmMnlwZmQ2MWp3ZG1rIn0.jG6g5nKhHJUz35S9AWrjHA")
     //   return snapshot.image

        
      //  let stringUrl = "https://api.mapbox.com/styles/v1/mapbox/streets-v9/static/\(center.longitude),\(center.latitude),\(zoom)/200x200@2x?access_token=pk.eyJ1Ijoibm9pY2UyayIsImEiOiJjaXRwaG9wZTIwMDBmMnlwZmQ2MWp3ZG1rIn0.jG6g5nKhHJUz35S9AWrjHA"

        let stringUrl = "https://api.mapbox.com/styles/v1/mapbox/streets-v9/static/\(center.longitude),\(center.latitude),\(zoom)/400x400?access_token=pk.eyJ1Ijoibm9pY2UyayIsImEiOiJjaXRwaG9wZTIwMDBmMnlwZmQ2MWp3ZG1rIn0.jG6g5nKhHJUz35S9AWrjHA"

        
        let imageUrl = URL(string: stringUrl)
        if  let imageData = try? Data(contentsOf: imageUrl!) {
            resultImage = UIImage(data: imageData)
            // check the image
            if resultImage!.size.width > 0 {
                // 3. draw
                resultImage = drawInterval(image: resultImage!,center: center, zoom: zoom, coordinates : coordinates)
                // resultImage = drawInterval(image: snapshot.image!,center: center, zoom: zoom, coordinates : coordinates)
            }
        }
        return resultImage
    }
    
    // draw interval to the image
    func drawInterval(image: UIImage, center : CLLocationCoordinate2D, zoom: Double, coordinates: [CLLocationCoordinate2D]) -> UIImage? {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: CGPoint.zero)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(1.0)
        context?.setStrokeColor(UIColor.blue.cgColor)
        
        // retina : x2
        //let zoom = (156412/pow(2,zoom))/2
       // let zoom = (156412/pow(2,zoom+2.2928))
        let xzoom = Double.pi*2*63727982*cos(center.latitude*Double.pi/180)/pow(2, zoom+11+1.2928)
       // let yzoom = (156412/pow(2,zoom+2.2928))
        let yzoom = (156412/pow(2,zoom+1.2928))
        
        //let zoom = (156412/pow(2,zoom+2.414))
        var x,y : Double
        if coordinates.count > 0 {
            x = CLLocation.distance_x(from: center, to: coordinates[0])/xzoom
            y = CLLocation.distance_y(from: center, to:  coordinates[0])/xzoom
            context?.move(to: CGPoint(x: 200-x, y: 200+y))
            for coord in coordinates {
                x = CLLocation.distance_x(from: center, to: coord)/xzoom
                y = CLLocation.distance_y(from: center, to: coord)/xzoom
                context?.addLine(to: CGPoint(x: 200-x, y: 200+y))
            }
        }
        context?.strokePath()
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
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


extension CLLocation {
    
    // be carefull : this is distance by longitude only
    class func distance_x(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double{
        let p1 = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let p2 = CLLocation(latitude: from.latitude, longitude: to.longitude)
        if from.longitude > to.longitude {
            return p1.distance(from: p2)
        } else
        {
            return p1.distance(from: p2)*(-1)
        }
    }
   
    // be carefull : this is distance by latitude only
    class func distance_y(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double{
        let p1 = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let p2 = CLLocation(latitude: to.latitude, longitude: from.longitude)
        if from.latitude > to.latitude {
            return p1.distance(from: p2)
        } else
        {
            let v = p1.distance(from: p2)
            return p1.distance(from: p2)*(-1)
        }
    }
    
}

// coordinames : [CLLocationCoordinate2D]
