//
//  JRLocationManager.swift
//  Jarvis
//
//  Created by Chaithanya Kumar on 10/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit
import CoreLocation

public typealias JRLocationAddressHandler = (_: JRAddress?, _: NSError?) -> Void
public typealias JRLocationHandler = (_: String?, _: NSError?) -> Void
public typealias JRCurrentLocationHandler = (_: [String: Any]?, _: NSError?) -> Void

@objc public class JRLocationManager: NSObject {
    
    @objc public static let shared: JRLocationManager = JRLocationManager()
    public var currentLocationInfo: [String: Any]?
    public var lastFetchedAddress: JRAddress?
    private(set) var authrizeStatus: CLAuthorizationStatus?
    
    fileprivate var locationManager: CLLocationManager?
    fileprivate var lastUpdatedLocation: CLLocation?
    fileprivate var lastUpdatedTimestamp: Date?
    fileprivate var cityReturnBlock: JRLocationHandler?
    fileprivate var currentLocationblock: JRCurrentLocationHandler?
    fileprivate var currentLocationFullAddressblock: JRLocationAddressHandler?
    
    
    override public init() {
        super.init()
        
        DispatchQueue.main.async { [weak self] () in
            self?.initLocationMgr()
        }
    }
    
    public func requestPermission() {
        DispatchQueue.main.async { [weak self] () in
            self?.locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    @objc public func updateCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
            if let location: CLLocation = locationManager?.location {
                setLastUpdatedLocation( location)
            }
        }
    }
    
    
    @objc public func updateCurrentLocationWithHandler(_ handler: @escaping JRCurrentLocationHandler) {
        currentLocationblock = handler;
        
        if !CLLocationManager.locationServicesEnabled() {
            let error: NSError = NSError.init(domain: "Location Service is disabled", code: CLError.regionMonitoringDenied.rawValue, userInfo: [NSLocalizedDescriptionKey: "Please enable location service through settings and try again"])
            if let currentLocationblock = currentLocationblock {
                currentLocationblock(nil, error)
                self.currentLocationblock = nil
            }
            return
        }
        locationManager?.startUpdatingLocation()
    }
    
    public func getCurrentLocationCords()->(Double,Double){
        var coords:(Double,Double) = (0.0,0.0)
        if let currentLocationInfo = currentLocationInfo {
            if let lat = currentLocationInfo["lat"] as? Double{
                coords.0 = lat
            }
            if let long = currentLocationInfo["long"] as? Double{
                coords.1 = long
            }
        }
        return coords
    }
    
    public func getCurrentCityWithHandler(_ handler: @escaping JRLocationHandler) {
       
        cityReturnBlock = handler;
        
        if !CLLocationManager.locationServicesEnabled() {
            let error: NSError = NSError.init(domain: "Location Service is disabled", code: CLError.regionMonitoringDenied.rawValue, userInfo: [NSLocalizedDescriptionKey: "Please enable location service through settings and try again"])
            if let cityReturnBlock = cityReturnBlock {
                cityReturnBlock(nil, error)
                self.cityReturnBlock = nil
            }
            return
        }
        locationManager?.startUpdatingLocation()
    }
    
    @objc public func getCurrentAddressWithHandler(_ handler: @escaping JRLocationAddressHandler) {
        currentLocationFullAddressblock = handler;
        if !CLLocationManager.locationServicesEnabled() {
            let error: NSError = NSError.init(domain: "Location Service is disabled", code: CLError.regionMonitoringDenied.rawValue, userInfo: [NSLocalizedDescriptionKey: "Please enable location service through settings and try again"])
            if let currentLocationFullAddressblock = currentLocationFullAddressblock {
                currentLocationFullAddressblock(nil, error)
                self.currentLocationFullAddressblock = nil
            }
            return
        }
        locationManager?.startUpdatingLocation()
    }
    
    public func locationAutorizationStatus() -> CLAuthorizationStatus {
        if CLLocationManager.locationServicesEnabled() {
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            return status
        }
        return CLAuthorizationStatus.denied
    }
}


fileprivate extension JRLocationManager {
    func setLastUpdatedLocation(_ location: CLLocation?) {
        if let location = location {
            let coordinate: CLLocationCoordinate2D = location.coordinate
            let dictionary: [String : CLLocationDegrees] = ["lat":coordinate.latitude, "long": coordinate.longitude]
            currentLocationInfo = dictionary
            lastUpdatedLocation = location
        } else {
            currentLocationInfo = nil
            lastUpdatedLocation = nil
        }
    }
    
    func initLocationMgr() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.distanceFilter = 10
    }
}


extension JRLocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            if newLocation.horizontalAccuracy <= locationManager!.desiredAccuracy {
                lastUpdatedTimestamp = Date()
                setLastUpdatedLocation(newLocation)
            }
            locationManager?.stopUpdatingLocation()
            
            if let currentLocationblock = currentLocationblock {
                if let currentLocationInfo = currentLocationInfo {
                    currentLocationblock(currentLocationInfo, nil)
                } else {
                    
                    let currentLocInfo = ["lat":newLocation.coordinate.latitude, "long": newLocation.coordinate.longitude]
                    currentLocationblock(currentLocInfo, nil)
                }
                self.currentLocationblock = nil;
            }
            
            if let _ = self.cityReturnBlock {
                let geoCoder: CLGeocoder = CLGeocoder.init()
                geoCoder.reverseGeocodeLocation(newLocation) {[weak self] (placemarks, error) -> Void in
                    
                    if let placemarks = placemarks {
                        
                        for placemark in placemarks {
                            if let locality = placemark.locality {
                                
                                if let cityReturnBlock = self?.cityReturnBlock {
                                    cityReturnBlock(locality, nil)
                                    self?.cityReturnBlock = nil
                                }
                                break
                            }
                        }
                        
                    } else if let _ = error, let cityReturnBlock = self?.cityReturnBlock {
                        cityReturnBlock(nil, NSError(domain: "Please select a city", code: 0, userInfo: ["NSLocalizedDescription" : "We are unable to detect your city at the moment, please select a city."]))
                        self?.cityReturnBlock = nil
                    }
                }
            }
            
            
            
            if let _ = self.currentLocationFullAddressblock {
                let geoCoder: CLGeocoder  = CLGeocoder.init()
                geoCoder.reverseGeocodeLocation(newLocation) {[weak self] (placemarks, error) -> Void in
                    if let placemarks = placemarks {
                        for placemark in placemarks {
                            let address: JRAddress = JRAddress()
                            address.address2 = placemark.name
                            address.city = placemark.locality
                            address.state = placemark.administrativeArea
                            address.pin = placemark.postalCode
                            address.country = placemark.country
                            address.locationRawAddress = placemark.addressDictionary
                            self?.lastFetchedAddress = address
                            
                            if let currentLocationFullAddress = self?.currentLocationFullAddressblock {
                                currentLocationFullAddress(address, nil)
                                self?.currentLocationFullAddressblock = nil
                            }
                            break
                        }
                        
                    } else if let _ = error, let currentLocationFullAddress = self?.cityReturnBlock {
                        currentLocationFullAddress(nil, NSError(domain: "Please select a city", code: 0, userInfo: ["NSLocalizedDescription" : "We are unable to detect your city at the moment, please select a city."]))
                        self?.currentLocationFullAddressblock = nil
                    }
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authrizeStatus = status
        JRCommonManager.shared.applicationDelegate?.locationManagerDidChangeAuthrization(status)
        let nc: NotificationCenter = NotificationCenter.default
        nc.post(name: Notification.Name("didChangeAuthorization"), object: status)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager :didFailWithError")
        if let cityReturnBlock = cityReturnBlock {
            cityReturnBlock(nil, NSError(domain: "Please select a city", code: 0, userInfo: ["NSLocalizedDescription" : "We are unable to detect your city at the moment, please select a city."]))
            self.cityReturnBlock = nil
        }
        
        if let currentLocationblock = currentLocationblock {
            currentLocationblock(nil, error as NSError?)
            self.currentLocationblock = nil
        }
        
        if let currentLocationFullAddressblock = currentLocationFullAddressblock {
            currentLocationFullAddressblock(nil, error as NSError?)
            self.currentLocationFullAddressblock = nil
        }
    }
    
    public func getPlacemark(_ location:CLLocation,handler:@escaping (_ placemarks : CLPlacemark?,_ error: Error?) -> Void) {
        let geoCoder: CLGeocoder = CLGeocoder.init()
        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            handler(placemarks?.first,error)
        }
    }
}
