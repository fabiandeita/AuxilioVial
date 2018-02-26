//
//  Localizacion.swift
//  AuxilioVial
//
//  Created by Iris Viridiana on 20/02/18.
//  Copyright © 2018 Iris Viridiana. All rights reserved.
//

import UIKit
import CoreLocation

class Localizacion: NSObject, CLLocationManagerDelegate{
    var locationManager : CLLocationManager?
    
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("lat: ", locations[0].coordinate.latitude, " long: ", locations[0].coordinate.longitude, " Alt: ", locations[0].altitude)
    }
}
