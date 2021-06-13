//  ARIndoorNav
//
//  Constants.swift
//  Constants - AppThemeColorConstants,
//            - TableViewConstants,
//            - mapViewConstants,
//            - ButtonConstants,
//            - BottomLabelConstants
//            - AlertConstants,
//            - TextConstants,
//            - ConsoleConstants,
//            - ArkitNodeDimension,
//            - URLConstants,
//            - DBKeyValues,
//
//  Created by Bryan Ung on 5/13/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This swift file provides constants that is used throughout the app.

import Foundation
import UIKit

let ipaddress = "192.168.1.208"

struct AppThemeColorConstants{
    static let blue = UIColor(red: 0/255, green: 185/255, blue: 242/255, alpha: 1)
    static let white : UIColor = .white
    static let red: UIColor = .red
    static let gray: UIColor = .gray
}
struct TableViewConstants {
    static let rowHeight: CGFloat = 80
    static let width: CGFloat = 24
    static let height: CGFloat = 24
    static let leftPadding: CGFloat = 12
    static let font: CGFloat = 18
}
struct mapViewConstants{
    static let height: CGFloat = 40
    static let width: CGFloat = 40
    static let font: CGFloat = 30
    static let leftDescriptionPadding: CGFloat = 30
}
struct ButtonConstants{
    static let topPadding: CGFloat = 9
    static let rightPadding: CGFloat = -9
    static let leftPadding: CGFloat = 9
    static let width: CGFloat = 60
    static let height: CGFloat = 60
    static let font: CGFloat = 20
    static let distanceBetweenButtons: CGFloat = 30
}
struct BottomLabelConstants{
    static let heightOffset = -40
    static let height: CGFloat = 60
    static let leftPadding: CGFloat = 25
    static let rightPadding: CGFloat = -25
    static let bottomPadding: CGFloat = -100
    static let fontSize: CGFloat = 24
}
struct AlertConstants{
    static let arErrorMessage = "Device does not support ARConfiguration"
    static let locationServiceError = "Location Services needs to be enabled"
    static let cameraAccessErrorMessage = "Camera needs to be enabled"
    static let serverRequestFailed = "Failure to connect/retrieve data from server"
    static let notLoggedIn = "Please Login To Continue."
    static let selectMapToUpload = "Select a map to upload."
    static let failedMapUpload = "Map failed to upload."
    static let createMapToUpload = "Please create at least one map before attempting to upload."
    static let randomError = "A error occurred. Please try again."
    static let cameraAccessError = "Camera usage was denied. \n\nPlease enable it by going to Settings > ARIndoorNav > Camera"
}
struct TextConstants{
    static let findBeaconText = "Scan a beacon to begin indoor navigation"
    static let beaconFound = "Beacon Found!"
    static let navigationBegan = "Beginning Navigation..."
    static let findBeaconToBuildCustomMap = "Scan a beacon to begin the process"
    static let beaconFoundAddStartNode = "Add starting node"
    static let startNodeAddedAddIntermediate = "Add Intermediate node(s)\nAdd End Node When Done"
    static let endNodePlaced = "Select Save to save your map"
    static let passwordRequirements = "Passwords must be at least 6 characters long"
    static let destinationReached = "Destination Reached"
}
struct ConsoleConstants{
    static let locationSuccess = "Location Retrieved Succesfully"
    static let dataModelSucces = "Data Model Setup Successfully"
    static let locationDetailsSuccess = "Location Details SetUp Successfully"
    static let locationManagerSuccess = "Location Manager SetUp Successfully"
    static let ARSCNViewSuccess = "ARKit Scene View SetUp Sucessfully"
    static let nodeManagerSuccess = "Node Manager SetUp Sucessfully"
    static let dataStoreManagerSuccess = "DataStore SetUp Successfully"
    static let customMapSaveSuccess = "***DataStore Saved Sucessfully***"
    static let dataStoreDataLoadedSuccess = "***DataStore Loaded Successfully***"
}
struct ArkitNodeDimension {
    static let arrowNodeXOffset = CGFloat(0.1)
}
/*/
   NOTE: The constants for this are using localhost port 8080 in order to do handling of data transfer between app and server (DOES NOT INCLUDE AUTH PROCESSES). When running the server, it is configured to run on local host.
 */
struct URLConstants {
//    static let navigationRequest = "http://10.0.0.21:8080/NavigationInstructions"
//    static let destinationListRequest = "http://10.0.0.21:8080/DestinationList"
//    static let uploadCustomMapRequest = "http://10.0.0.21:8080/UploadCustomMap"
//    static let downloadableMapNames = "http://10.0.0.21:8080/DownloadCustomMapNames"
//    static let downloadCustomMap = "http://10.0.0.21:8080/DownloadCustomMap"
    static let navigationRequest = "http://" + ipaddress + ":8080/NavigationInstructions"
    static let destinationListRequest = "http://" + ipaddress + ":8080/DestinationList"
    static let uploadCustomMapRequest = "http://" + ipaddress + ":8080/UploadCustomMap"
    static let downloadableMapNames = "http://" + ipaddress + ":8080/DownloadCustomMapNames"
    static let downloadCustomMap = "http://" + ipaddress + ":8080/DownloadCustomMap"
//    static let navigationRequest = "http://192.168.1.223:8080/NavigationInstructions"
//    static let destinationListRequest = "http://192.168.1.223:8080/DestinationList"
//    static let uploadCustomMapRequest = "http://192.168.1.223:8080/UploadCustomMap"
//    static let downloadableMapNames = "http://192.168.1.223:8080/DownloadCustomMapNames"
//    static let downloadCustomMap = "http://192.168.1.223:8080/DownloadCustomMap"
}
struct DBKeyValues{
    static let firstName = "first_name"
    static let lastName = "last_name"
    static let userName = "username"
    static let birthday = "birthday"
    static let phoneNumber = "phone"
    static let email = "email"
}
