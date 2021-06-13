//  ARIndoorNav
//
//  NetworkService.swift
//  Class - NetworkService
//
//  Created by Bryan Ung on 7/27/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This class handles the API Requests to the NodeJS Server.

import Foundation

class NetworkService {
    
    //MARK: - Properties
    static let networkServiceSharedInstance = NetworkService()
    
    //MARK: - Request Functions
    
    /*/ requestDownloadCustomMap(_ urlPath: String, mapName: String, uid: String, completion: @escaping(Result<Data,NSError>) -> Void)
     This function sends a request to the NodeJS server to download a custom map stored within the FireBase DB.
     
     @param: urlPath - String - the link to the service
     @param: mapName - String - the name of the map wanting to download
     @param: uid - String - the UID of the user
     
     completion:
        success: sends a success with the data containning information on the map
        failure: sends an error with the data wrapped as NSError
    */
    func requestDownloadCustomMap(_ urlPath: String, mapName: String, uid: String, completion: @escaping(Result<Data,NSError>) -> Void){
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        //Gets the normal configuration for a typical request.
        let configuration = NetworkService.getSessionConfiguration()
        let session = URLSession(configuration: configuration)
        
        //Configures a dict to be translated into a JSONObject
        let dict = NSMutableDictionary()
        dict.setValue(uid, forKey: "uid")
        dict.setValue(mapName, forKey: "map_name")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict) else {return}
        request.httpBody = httpBody
        
        let task = session.dataTask(with: request) { (data, _, error) in
            if let unwrappedError = error {
                completion(.failure(unwrappedError as NSError))
            } else if let unwrappedData = data {
                completion(.success(unwrappedData))
            }
        }
        task.resume()
    }
    /*/ requestDownloadCustomMapNames(_ urlPath: String, uid: String, completion: @escaping(Result<Data,NSError>) -> Void)
     Sends a request to the NodeJS server to retrieve a list of all saved maps names on the Firebase DB that are related to the user.
     
     @param: urlPath - String - the link to the service
     @param: uid - String - the UID of the user
     
     completion:
        success: sends a success with the data containning information on the map names
        failure: sends an error with the data wrapped as NSError
    */
    func requestDownloadCustomMapNames(_ urlPath: String, uid: String, completion: @escaping(Result<Data,NSError>) -> Void){
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        //Gets the normal configuration for a typical request.
        let configuration = NetworkService.getSessionConfiguration()
        let session = URLSession(configuration: configuration)
        
        //Configures a dict to be translated into a JSONObject
        let dict = NSMutableDictionary()
        dict.setValue(uid, forKey: "uid")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict) else {return}
        request.httpBody = httpBody
        
        let task = session.dataTask(with: request) { (data, _, error) in
            if let unwrappedError = error {
                completion(.failure(unwrappedError as NSError))
            } else if let unwrappedData = data {
                completion(.success(unwrappedData))
            }
        }
        task.resume()
    }
    /*/ requestUploadCustomMap(_ urlPath: String, userID: String,  locInfo: LocationInfo, completion: @escaping(Result<Data, NSError>) -> Void)
     Sends a request to the NodeJS server to upload a specific map saved on the user's device through the app.
     
     @param: urlPath - String - the link to the service
     @param: uid - String - the UID of the user
     @param: locInfo - LocationInfo - LocationInfo of the map information needed to save to the DB.
     
     completion:
        success: sends a success with the data containning information on the return string from the server
        failure: sends an error with the data wrapped as NSError
    */
    func requestUploadCustomMap(_ urlPath: String, uid: String, locInfo: LocationInfo, completion: @escaping(Result<Data, NSError>) -> Void){
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        //Calls the LocationInfo.swift class to JSONize the object, which heirchally JSONs all data within the object.
        let locInfoJson = locInfo.getJSON()
        locInfoJson.setValue(uid, forKey: "uid")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: locInfoJson) else {return}
        request.httpBody = httpBody

        //Gets the normal configuration for a typical request.
        let configuration = NetworkService.getSessionConfiguration()
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { (data, _, error) in
            if let unwrappedError = error {
                completion(.failure(unwrappedError as NSError))
            } else if let unwrappedData = data {
                completion(.success(unwrappedData))
            }
        }
        task.resume()
    }
    /*/ requestNavigationInfo(_ urlPath: String, infoArr: [String?], completion: @escaping(Result<Data, NSError>)
     Sends a request to the NodeJS Server to retrieve the navigation details/information of a particular map.
     
     @param: urlPath - String - the link to the service
     @param: infoArr - [String?] - an array consisting of information to locate the map
     
     completion:
        success: sends a success with the data containning information on the map
        failure: sends an error with the data wrapped as NSError
    */
    func requestNavigationInfo(_ urlPath: String, infoArr: [String?], completion: @escaping(Result<Data, NSError>) -> Void){
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        
        //unpacking arr to get details to convert to JSON.
        let destination = infoArr[0]
        let beaconScannedName = infoArr[1]
        
        let parameters: [String: Any] = [
            "destination": destination!,
            "scannedBeaconName": beaconScannedName!
        ]
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters) else {return}
        request.httpBody = httpBody
        
        //Gets the normal configuration for a typical request.
        let configuration = NetworkService.getSessionConfiguration()
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { (data, _, error) in
            if let unwrappedError = error {
                completion(.failure(unwrappedError as NSError))
            } else if let unwrappedData = data {
                completion(.success(unwrappedData))
            }
        }
        task.resume()
    }
    /*/ requestSearchableDestinations(_ urlPath: String, completion: @escaping(Result<Data, NSError>) -> Void)
     Sends a request to the NodeJS server to retrieve a list of all saved maps names on the Firebase DB that are available to all users
     
     @param: urlPath - String - the link to the service (destinationList)
     
     completion:
        success: sends a success with the data containning information on the map names
        failure: sends an error with the data wrapped as NSError
    */
    func requestSearchableDestinations(_ urlPath: String, completion: @escaping(Result<Data, NSError>) -> Void) {
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        //let session = URLSession.shared
        let configuration = NetworkService.getSessionConfiguration()
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { (data, _, error) in
            if let unwrappedError = error {
                completion(.failure(unwrappedError as NSError))
            } else if let unwrappedData = data {
                completion(.success(unwrappedData))
            }
        }
        task.resume()
    }
    /*/ getSessionConfiguration() -> URLSessionConfiguration
     Returns the generic session configuration with the following properties
     - timeoutInterval 10 secs
    
     @return: URLSessionConfiguration - session configuration
    */
    static func getSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(10)
        configuration.timeoutIntervalForResource = TimeInterval(10)
        return configuration
    }
}
