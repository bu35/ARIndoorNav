//  ARIndoorNav
//
//  LocationManager.swift
//  class - LocationManager
//
//  Created by Bryan Ung on 5/13/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  Class is responsible for handling the geolocation of the user.
//
//  *NOTE* The app doesnt make use of this functionality yet.

import Foundation
import CoreLocation
import ARKit
class LocationManager: NSObject, CLLocationManagerDelegate{
    
    static let locationManagerInstance = LocationManager()
    
    //MARK: - Properties
    
    let locationManager = CLLocationManager()
    var dataModelSharedInstance: DataModel?

    //MARK: - Init
    
    /*/ init()
     initializer function
     */
    override init() {
        super.init()
        dataModelSharedInstance = DataModel.dataModelSharedInstance
    }
    //MARK: - Helper Functions
    
    /*/ requestLocationAuth(success: @escaping((String) -> Void), failure: @escaping((String) -> Void))
     Request user access to Location
     */
    func requestLocationAuth(success: @escaping((String) -> Void), failure: @escaping((String) -> Void)){
        if CLLocationManager.locationServicesEnabled() == true {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined{
                failure(AlertConstants.locationServiceError)
            } else {
                locationManager.requestWhenInUseAuthorization()
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            }
        } else {
            failure(AlertConstants.locationServiceError)
        }
        success(ConsoleConstants.locationSuccess)
        self.locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - Unimplemented Functionality
//    func updateLocation(){
//        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else {
//            return
//        }
//        locationDetailsSharedInstance?.setSourcePosition(source: locValue)
//        print("SourceLocation: \(locValue.longitude) \(locValue.latitude)")
//    }
//    func updateLocation(sourcePos: CLLocationCoordinate2D){
//        let locValue = CLLocationCoordinate2D(latitude: sourcePos.latitude, longitude: sourcePos.longitude)
//        locationDetailsSharedInstance!.setSourcePosition(source: locValue)
//        print("SourceLocation: \(locValue.longitude) \(locValue.latitude)")
//    }
//    func updateDestination(destinationPos: CLLocationCoordinate2D){
//        let locValue = CLLocationCoordinate2D(latitude: destinationPos.latitude, longitude: destinationPos.longitude)
//        locationDetailsSharedInstance!.setDestinationPosition(destination: locValue)
//        print("Destination: \(locValue.longitude) \(locValue.latitude)")
//    }
//    func distanceBetweenCoords(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Double{
//        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
//        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
//        let distance = sourceLocation.distance(from: destinationLocation)
//        return distance
//    }
//    func getBearingBetweenPoints(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double{
//        let lat1 = degreesToRadians(degrees: point1.latitude)
//        let lon1 = degreesToRadians(degrees: point1.longitude)
//
//        let lat2 = degreesToRadians(degrees: point2.latitude)
//        let lon2 = degreesToRadians(degrees: point2.longitude)
//        let dLon = lon2 - lon1
//
//        let y = sin(dLon) * cos(lat2)
//        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
//        let radiansBearing = atan2(y, x)
//        return radiansToDegrees(radians: radiansBearing)
//    }
//    func degreesToRadians(degrees: Double) -> Double{return degrees * .pi / 180}
//    func radiansToDegrees(radians: Double) -> Double{return radians * 180 / .pi}
    
}
