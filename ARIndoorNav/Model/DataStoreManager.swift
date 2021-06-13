//  ARIndoorNav
//
//  DataStoreManager.swift
//  class - DataStoreManager
//
//  Created by Bryan Ung on 5/18/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This class is responsible for all actions performed on the DataStore such as saving data

import Foundation

enum DataStoreManagerStringNames: String {
    case dataStoreManager = "dataStoreManager"
}

final class DataStoreManager {
    
    // MARK: - Properties
    
    static let dataStoreManagerSharedInstance: DataStoreManager = DataStoreManager()
    var dataStore = DataStore()
    
    //MARK: - Init
    
    /*/ init()
     Init for the class. Attemps to load data saved on device
     
     -Error Handling is disabled for now
     */
    private init() {
        do {
            let defaults = UserDefaults.standard
            let decoded = defaults.object(forKey: DataStoreManagerStringNames.dataStoreManager.rawValue)
            if decoded != nil {
                let dataStore = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded as! Data)
//                let dataStore = try NSKeyedUnarchiver.unarchivedObject(ofClass: DataStore.self, from: decoded as! Data)
                if dataStore != nil {
                    self.dataStore = dataStore! as! DataStore
                    print(ConsoleConstants.dataStoreDataLoadedSuccess)
                }
            }
        }
//        } catch  {
//            fatalError("Error Occurred with Data")
//            let nsError = error as NSError
//            print(nsError.localizedDescription)
//        }
        
    }
    
    //MARK: - Save
    
    /*/ saveDataStore()
     Saves dataStore data to the device.
     */
    func saveDataStore() {
        do{
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: self.dataStore, requiringSecureCoding: false)
            //let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.dataStore)
            let defaults = UserDefaults.standard
            defaults.set(encodedData, forKey: DataStoreManagerStringNames.dataStoreManager.rawValue)
        } catch {
            let nsError = error as NSError
            print(nsError.localizedDescription)
        }
        print(ConsoleConstants.customMapSaveSuccess)
    }
}
