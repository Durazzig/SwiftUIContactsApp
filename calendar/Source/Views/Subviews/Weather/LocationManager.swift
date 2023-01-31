//
//  LocationManager.swift
//  calendar
//
//  Created by Tadeo Durazo on 30/01/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    @Published var latitude: String = "0.0"
    @Published var longitude: String = "0.0"
    @Published var isLocationReady: Bool = false
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        } else {
            print("Location services not enabled")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted")
        case .denied:
            print("Your location is denied")
        case .authorizedAlways, .authorizedWhenInUse:
            latitude = "\(locationManager.location?.coordinate.latitude ?? 0)"
            longitude = "\(locationManager.location?.coordinate.longitude ?? 0)"
            isLocationReady = true
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

}
