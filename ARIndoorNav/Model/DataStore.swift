//  ARIndoorNav
//
//  DataStore.swift
//  Class - DataStore
//
//  Created by Bryan Ung on 5/18/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This class is responsbile for storing/persisting of variables

import Foundation

enum DataStoreStringNames: String{
    case locationInfo = "locationInfo"
}

class DataStore: NSObject, NSCoding {
    
    //MARK: - Properties
    
    private var locationInfoList: Array<LocationInfo> = []
    
    //MARK: - Init
    
    /*/ init()
     Init for the class
     */
    override init() {
        super.init()
    }
    
    //MARK: - Helper
    
    /*/ setLocationInfoList(list: Array<LocationInfo>)
     Sets locationInfoList to a Array<LocationInfo>
     
     @param: list - Array<LocationInfo> - an Array of LocationInfo
     */
    func setLocationInfoList(list: Array<LocationInfo>){
        self.locationInfoList = list
    }
    /*/ getLocationInfoList() -> Array<LocationInfo>
     returns locationInfoList
     
     @return: locationInfoList - Array<LocationInfo> - LocationInfo Array
     */
    func getLocationInfoList() -> Array<LocationInfo> {
        return self.locationInfoList
    }
    
    //MARK: - Encode
    
    /*/ encode(with coder: NSCoder)
     function which is called when app attempts to ArchiveData
     */
    func encode(with coder: NSCoder) {
        coder.encode(self.locationInfoList, forKey: DataStoreStringNames.locationInfo.rawValue)
    }
    
    //MARK: - Decode
    
    /*/ init?(coder decoder: NSCoder)
     Called when app attempts to unarchiveTopLevelObjectWithData. Sets the locationInfoList to saved LocationInfo Array
     */
    required init?(coder decoder: NSCoder) {
        super.init()
        self.locationInfoList = decoder.decodeObject(forKey: DataStoreStringNames.locationInfo.rawValue) as! Array<LocationInfo>
        
    }
    
}
