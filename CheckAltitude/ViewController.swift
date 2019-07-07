//
//  ViewController.swift
//  CheckAltitude
//
//  Created by Jeremy Adam on 01/05/19.
//  Copyright © 2019 Underway. All rights reserved.
//

import UIKit
import CoreLocation
import NetworkExtension
import SystemConfiguration.CaptiveNetwork

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
    var formattedAltitudeValue = 0
    var historyArray:[Double] = []
    var altitudeValue:Double = 0
    var coordinateValue:CLLocationCoordinate2D = CLLocationCoordinate2D()
    //CoreLocation Function
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var formattedMinValue:String = "0 m"
        var formattedMaxValue:String = "0 m"
        var formattedAvgValue:String = "0 m"
        let location: CLLocation? = locations[0] as CLLocation
        altitudeValue = location!.altitude
        coordinateValue = location!.coordinate
        
        
        historyArray.append(altitudeValue)
        if historyArray.count > historyCapacity {
            historyArray.removeFirst()
        }
        
        if minValue > altitudeValue {
            minValue = altitudeValue
            formattedMinValue = (NSString(format:"%.4f", minValue) as String) + " m"
            minLabel.text = formattedMinValue
        }
        
        if maxValue < altitudeValue {
            maxValue = altitudeValue
            formattedMaxValue = (NSString(format:"%.4f", maxValue) as String) + " m"
            maxLabel.text = formattedMaxValue
        }
        
        
        let sumArray = historyArray.reduce(0, +)
        let avgArrayValue = sumArray / Double(historyArray.count)
        formattedAvgValue = (NSString(format:"%.4f", avgArrayValue) as String) + " m"
        
        let formattedAltitudeValue = (NSString(format:"%.4f", altitudeValue) as String) + " m" as String
        
        // print("Current: \(formattedAltitudeValue)")
        altitudeLabel.text = formattedAltitudeValue
        avgLabel.text = formattedAvgValue
        
        changeWifi()
    }
    //
    
    // Get Wifi SSID
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    //
    
    
    //
    func changeWifi() {
//        var currentWifi = getWiFiSsid()
        
        let coordinate1 = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        let geoFence = CLCircularRegion(center: coordinate1, radius: 100, identifier: "geoFence")
        
        if geoFence.contains(coordinateValue) {
            print("Inside")
            
            if altitudeValue >= 22 && altitudeValue <= 24 {
                print("Connect to xxxx")
                connectWifi(inSsid: "xxxx", inPass: "xxxx")
            }
            else {
                print("Connect to xxx")
                connectWifi(inSsid: "xxxx", inPass: "xxxxx")
            }
            
        }
        //
    
        
    }
    //
    
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        print("henlo")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("Authorized status changed")
//        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
//            let circularRegion = CLCircularRegion.init(center: coordinateValue,
//                                                       radius: 200.0,
//                                                       identifier: "Home")
//            circularRegion.notifyOnEntry = true
//            circularRegion.notifyOnExit = true
//            manager.startMonitoring(for: circularRegion)
//        }
//    }
//
    
    func connectWifi(inSsid:String, inPass:String) {
        let config = NEHotspotConfiguration.init(ssid: inSsid, passphrase: inPass, isWEP: false)
        config.joinOnce = true
        
        NEHotspotConfigurationManager.shared.apply(config) { (error) in
            if error != nil {
                if error?.localizedDescription == "already associated."
                {
                    print("Connected")
                }
                else{
                    print("No Connected")
                }
            }
            else {
                print("Connected")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.requestAlwaysAuthorization()
        
        //Altitude
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
        //
      
        
        
        
       
        
        
       
        
        
        
    }


}

