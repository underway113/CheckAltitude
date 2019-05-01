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

    //IBOutlet
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    let manager = CLLocationManager()
    
    //Variable
    var minValue:Double = 999999
    var maxValue:Double = 0
    let historyCapacity = 10
    
    var historyArray:[Double] = []
    
    //CoreLocation Function
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var formattedMinValue:String = "0 m"
        var formattedMaxValue:String = "0 m"
        var formattedAvgValue:String = "0 m"
        let location: CLLocation? = locations[0] as CLLocation
        let altitudeValue = location?.altitude
        
        historyArray.append(altitudeValue ?? 0)
        if historyArray.count > historyCapacity {
            historyArray.removeFirst()
        }
        
        if minValue > altitudeValue as! Double {
            minValue = altitudeValue ?? 0
            formattedMinValue = (NSString(format:"%.4f", minValue) as String) + " m"
            minLabel.text = formattedMinValue
        }
        
        if maxValue < altitudeValue as! Double {
            maxValue = altitudeValue ?? 0
            formattedMaxValue = (NSString(format:"%.4f", maxValue) as String) + " m"
            maxLabel.text = formattedMaxValue
        }
        
        
        let sumArray = historyArray.reduce(0, +)
        let avgArrayValue = sumArray / Double(historyArray.count)
        formattedAvgValue = (NSString(format:"%.4f", avgArrayValue) as String) + " m"
        
        let formattedAltitudeValue = (NSString(format:"%.4f", altitudeValue!) as String) + " m" as String
        
        print("Current: \(formattedAltitudeValue)")
        altitudeLabel.text = formattedAltitudeValue
        avgLabel.text = formattedAvgValue
    }
    //
    
    
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
            default:
                print("Error Location")
            }
        } else {
            print("Location services are not enabled")
        }
    }


}

