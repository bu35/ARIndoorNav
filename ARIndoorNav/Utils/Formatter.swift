//  ARIndoorNav
//
//  Formatter.swift
//  Class - Formatter
//
//  Created by Bryan Ung on 7/27/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This class serves as a formatter for information retrieved from the NodeJS Server

import Foundation
import Firebase

class Formatter{
    static let FormatterSharedInstance = Formatter()
    
    //MARK: Functions
    
    /*/ decodeDownloadableCustomMapsNames(JSONdata: Data) -> DownloadableList?
     Decodes a Data Object into an array of strings: Alias = <DownloadableList> (Located in /Model/LocationInfo.DownloadableList)
     
     @param: JSONdata - Data - data retrieved from the NodeJS Server
     
     @return: DownloadableList? - [String] - array of custom map names related to user.
     */
    func decodeDownloadableCustomMapsNames(JSONdata: Data) -> DownloadableList? {
        let data = try? JSONDecoder().decode(DownloadableList.self, from: JSONdata)
        return data
    }
    /*/ decodeJSONDestination(JSONdata: Data) -> LocationInfo?
     Decodes a Data Object into a <LocationInfo> (LocationInfo.swift.LocationInfo) Object
     
     @param: JSONdata - Data - data retrieved from the NodeJS Server
     
     @return: LocationInfo? - LocationInfo - Class object of information about a particular location from start to finish
    */
    func decodeJSONDestination(JSONdata: Data) -> LocationInfo?{
        let data = try? JSONDecoder().decode(LocationInfo.self, from: JSONdata)
        return data
    }
    /*/ decodeJSONDestinationList(JSONdata: Data) -> DestinationList?
     Decodes a Data Object into a <DestinationList> (LocationInfo.swift.DestinationList) Object to show queryable results to users on the search controller
     
     @param: JSONdata - Data - data retrieved from the NodeJS Server
     
     @return: DestinationList? - DestinationList - Type alias [String], list of strings of queryable destinations.
    */
    func decodeJSONDestinationList(JSONdata: Data) -> DestinationList?{
        let data = try? JSONDecoder().decode(DestinationList.self, from: JSONdata)
        return data
    }
    /*/ decodeJSONMessage(JSONdata: Data) -> String
     Decodes a JSON message which is of type <String>
     
     @param: JSONdata - Data - data retrieved from the NodeJS Server
     
     @return: String - string message from server
     */
    func decodeJSONMessage(JSONdata: Data) -> String{
        let str = String(decoding: JSONdata, as: UTF8.self)
        return str
    }
    /*/ buildNodeListWithJsonData(jsonDecoded: LocationInfo) -> Array<Index>
     Builds an Array<Index> (LocationInfo.swift.Index) which houses information on each node from start to finish. Called from NodeManager.generateNodeList
     
     @param: jsonDecoded - LocationInfo - Constructed information on a particular location
     
     @return: Array<Index> - List of nodes from start to finish housed at a particular marker
    */
    func buildNodeListWithJsonData(jsonDecoded: LocationInfo) -> Array<Index>{
        let nodeCount = jsonDecoded.nodeCount
        let nodes = jsonDecoded.nodes.index
        var returnList = Array<Index>()
        
        for (index, nodeEntry) in nodes.enumerated(){
            let tempNode: Index
            if index == 0 {
                tempNode = Index(type: NodeType.start.rawValue, xOffset: nodeEntry.xOffset, yOffset: nodeEntry.yOffset, zOffset: nodeEntry.zOffset)
            } else if index == nodeCount - 1{
                tempNode = Index(type: NodeType.destination.rawValue, xOffset: nodeEntry.xOffset, yOffset: nodeEntry.yOffset, zOffset: nodeEntry.zOffset)
            } else {
                tempNode = Index(type: NodeType.intermediate.rawValue, xOffset: nodeEntry.xOffset, yOffset: nodeEntry.yOffset, zOffset: nodeEntry.zOffset)
            }
            returnList.append(tempNode)
        }
        return returnList
    }
}
