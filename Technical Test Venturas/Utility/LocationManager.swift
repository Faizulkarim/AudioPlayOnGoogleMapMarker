//
//  LocationManager.swift
//  
//  Technical Test Venturas
//  Created by Faizul Karim on 7/11/21.
//

import UIKit
import CoreLocation
import GoogleMaps

class LocationManager: NSObject , CLLocationManagerDelegate {
    
    static let shared : LocationManager = LocationManager()
    
    var location             = CLLocationCoordinate2D()
    var locationManager     : CLLocationManager = CLLocationManager()
    
    
    //---------------------------------------------------------------------
    
    //MARK: - Current Lat Long
    
    //TODO: To get location permission just call this method
    func getLocation() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //TODO: To get permission is allowed or declined
    func checkStatus() -> CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
    
    //TODO: To get user's current location
    func getUserLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    

    
    
    //MARK: Delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations[0].coordinate
       print("Lat :",location.latitude , ", Long : " , location.longitude)
        
        let newLocation : [String : CLLocationCoordinate2D] = ["location" : location]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"LocationChange"), object: nil, userInfo: newLocation)
    }
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
            
        case .denied:
            print("Permission Denied")
            break
        case .notDetermined:
            print("Permission Not Determined G")
            break
            
        default:
            print("\(location.latitude)")
            print("\(location.longitude)")
            
            break
        }
    }
    


}


