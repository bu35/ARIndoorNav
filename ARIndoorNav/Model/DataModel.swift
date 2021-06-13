//  ARIndoorNav
//
//  DataModel.swift
//  Class - DataModel
//
//  Created by Bryan Ung on 5/18/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  The centralized source of Data within the application. Classes are able to retrieve instances of other data models/classes.

import Foundation
import UIKit
import ARKit
class DataModel {
    
    //MARK: - Properties
    
    static let dataModelSharedInstance = DataModel()
    var sceneView: ARSCNView?
    var mainVC: ViewController?
    var locationDetailsSharedInstance: LocationDetails?
    var locationManagerSharedInstance: LocationManager?
    var ARSCNViewDelegateSharedInstance: ARSceneViewDelegate?
    var nodeManagerSharedInstance: NodeManager?
    var dataStoreManagerSharedInstance: DataStoreManager?

    //MARK: - Helper Functions
    
    /*/ initLocationManager()
        Initializes the locationManager
     
        *NOTE* Gets User's location, nothing is currently done with location atm.
     */
    private func initLocationManager(){
        self.locationManagerSharedInstance!.requestLocationAuth(success: {message in
        }, failure: {alertString in
            self.mainVC!.alert(info: alertString)
        })
        print(ConsoleConstants.locationManagerSuccess)
    }
    /*/ initLocationDetails()
     Inits the locationDetails
     */
    func initLocationDetails(){
        self.locationDetailsSharedInstance?.reset()
        print(ConsoleConstants.locationDetailsSuccess)
    }
    /*/ initARSCNViewDelegate()
     Inits the initARSCNViewDelegate
     */
    private func initARSCNViewDelegate(){
        print(ConsoleConstants.ARSCNViewSuccess)
    }
    /*/ initNodeManager()
     Inits the initNodeManager
     */
    private func initNodeManager(){
        self.nodeManagerSharedInstance?.reset()
        print(ConsoleConstants.nodeManagerSuccess)
    }
    /*/ initDataStoreManager()
     Inits the initDataStoreManager
     */
    private func initDataStoreManager(){
        print(ConsoleConstants.dataStoreManagerSuccess)
    }
    /*/ resetNavigationToRestingState()
     Resets navigation to a resting state
     */
    func resetNavigationToRestingState(){
        getLocationDetails().reset()
        getNodeManager().reset()
        getARNSCNViewDelegate().reset()
    }
    
    //MARK: - Setter Functions
    
    /*/ setLocationManager(locationManager: LocationManager)
     Sets locationManagerSharedInstance to a LocationManager
     
     @param: locationManager - a LocationManager Object
     */
    func setLocationManager(locationManager: LocationManager){
        locationManagerSharedInstance = locationManager
        initLocationManager()
    }
    /*/ setLocationDetails(locationDetails: LocationDetails)
     Sets locationDetailsSharedInstance to a LocationDetails
     
     @param: locationDetails - a LocationDetails Object
     */
    func setLocationDetails(locationDetails: LocationDetails){
        locationDetailsSharedInstance = locationDetails
        initLocationDetails()
    }
    /*/ setDataStoreManager(dataStoreManager: DataStoreManager)
     Sets dataStoreManagerSharedInstance to a DataStoreManager
     
     @param: dataStoreManager - a DataStoreManager Object
     */
    func setDataStoreManager(dataStoreManager: DataStoreManager){
        dataStoreManagerSharedInstance = dataStoreManager
        initDataStoreManager()
    }
    /*/ setARSCNViewDelegate(ARSCNViewDelegate: ARSceneViewDelegate)
     Sets ARSCNViewDelegateSharedInstance to a ARSceneViewDelegate
     
     @param: ARSCNViewDelegate - a ARSceneViewDelegate Object
     */
    func setARSCNViewDelegate(ARSCNViewDelegate: ARSceneViewDelegate){
        ARSCNViewDelegateSharedInstance = ARSCNViewDelegate
        initARSCNViewDelegate()
    }
    /*/ setNodeManager(nodeManager: NodeManager)
     Sets nodeManagerSharedInstance to a NodeManager
     
     @param: nodeManager - a NodeManager Object
     */
    func setNodeManager(nodeManager: NodeManager){
        nodeManagerSharedInstance = nodeManager
        initNodeManager()
    }
    /*/ setMainVC(vc: ViewController)
     Sets mainVC to a ViewController
     
     @param: vc - a ViewController
     */
    func setMainVC(vc: ViewController) {
        self.mainVC = vc
    }
    /*/ setSceneView(view: ARSCNView)
     Sets sceneView to a ARSCNView
     
     @param: view - a ARSCNView
     */
    func setSceneView(view: ARSCNView) {
        self.sceneView = view
    }
    
    //MARK: - Getter Functions
    
    /*/ getLocationManager() -> LocationManager
     
     @return: locationManagerSharedInstance - a LocationManager object
     */
    func getLocationManager() -> LocationManager{
        return self.locationManagerSharedInstance!
    }
    /*/ getLocationDetails() -> LocationDetails
     returns locationDetailsSharedInstance
     
     @return: locationDetailsSharedInstance - a LocationDetails object
     */
    func getLocationDetails() -> LocationDetails{
        return self.locationDetailsSharedInstance!
    }
    /*/ getDataStoreManager() -> DataStoreManager
     returns dataStoreManagerSharedInstance
     
     @return: dataStoreManagerSharedInstance - a DataStoreManager object
     */
    func getDataStoreManager() -> DataStoreManager{
        return self.dataStoreManagerSharedInstance!
    }
    /*/ getARNSCNViewDelegate() -> ARSceneViewDelegate
     returns ARSCNViewDelegateSharedInstance
     
     @return: ARSCNViewDelegateSharedInstance - a ARSceneViewDelegate object
     */
    func getARNSCNViewDelegate() -> ARSceneViewDelegate{
        return self.ARSCNViewDelegateSharedInstance!
    }
    /*/ getNodeManager() -> NodeManager
     returns nodeManagerSharedInstance
     
     @return: nodeManagerSharedInstance - a NodeManager object
     */
    func getNodeManager() -> NodeManager{
        return self.nodeManagerSharedInstance!
    }
    /*/ getMainVC() -> ViewController
     returns mainVC
     
     @return: mainVC - a ViewController
     */
    func getMainVC() -> ViewController {
        return self.mainVC!
    }
    /*/ getSceneView() -> ARSCNView
     returns sceneView
     
     @return: sceneView - a ARSCNView
     */
    func getSceneView() -> ARSCNView {
        return self.sceneView!
    }
}
