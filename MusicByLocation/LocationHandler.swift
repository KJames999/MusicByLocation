//
//  LocationHandler.swift
//  MusicByLocation
//
//  Created by James, Killian (NA) on 02/03/2022.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    @Published var lastKnownLocation: String = ""
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorisation() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstLocation = locations.first {
            geocoder.reverseGeocodeLocation(firstLocation, completionHandler: { (placemarks, error) in
                if error != nil {
                    self.lastKnownLocation = "Could not perform lookup of location from coordiante information"
                } else {
                    if let firstPlacemark = placemarks?[0] {
                        self.lastKnownLocation = firstPlacemark.locality ?? "Could not find locality"
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lastKnownLocation = "Error finding location"
    }
}
