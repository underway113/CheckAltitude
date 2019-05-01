//
//  ViewController.swift
//  CheckAltitude
//
//  Created by Jeremy Adam on 01/05/19.
//  Copyright © 2019 Underway. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    let manager = CLLocationManager()
    

    var minValue:Double = 999999
    var maxValue:Double = 0
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation? = locations[0] as CLLocation
        let altitudeValue = location?.altitude
        
        if minValue > altitudeValue as! Double {
//            lastValue = altitudeValue ?? 0
            minValue = altitudeValue ?? 0
            let formattedminValue = (NSString(format:"%.5f", minValue) as String) + " m"
            minLabel.text = formattedminValue
            
        }
        if maxValue < altitudeValue as! Double {
//            lastValue = altitudeValue ?? 0
            maxValue = altitudeValue ?? 0
            let formattedmaxValue = (NSString(format:"%.5f", maxValue) as String) + " m"
            maxLabel.text = formattedmaxValue
        }
        
        let formattedAltitudeValue = (NSString(format:"%.5f", altitudeValue!) as String) + " m" as String
        print("Current: \(formattedAltitudeValue)")
        altitudeLabel.text = formattedAltitudeValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                manager.delegate = self
                manager.desiredAccuracy = kCLLocationAccuracyBest
                manager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
        }
    }


}

