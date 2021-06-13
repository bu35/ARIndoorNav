//  ARIndoorNav
//
//  ARSceneViewDelegate.swift
//  Class - ARSceneViewDelegate
//  Extensions - SCNGeometry, SCNNode, SCNVector3
//
//  Created by Bryan Ung on 5/13/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  Class is responsible for the adding/building of CustomMaps process
//  AND
//  Handling the node plotting of a Map from a marker to a destination
//  AND
//  Handling the rendering functions of the ARScene

import Foundation
import ARKit
import CoreLocation
class ARSceneViewDelegate: NSObject, ARSCNViewDelegate{
    //Singleton
    static let ARSCNViewDelegateInstance = ARSceneViewDelegate()
    //MARK: - Properties
    
    //Referenced beacon that is scanned. All beacons located inside Assets.xcassets/ARResources
    var beaconImageName: String?
    //Serves two functions. One as a helper to build custom maps. One as a tracker of all plotted nodes. It is either one or the other and is reinitialized depending on if the user is navigating or creating a custom map.
    var nodeList: Array<SCNNode>?
    //Delegate = ViewController.swift
    var delegate: ARScnViewDelegate?
    //Centralized datasource
    var dataModelSharedInstance: DataModel?
    
    //MARK: - Init
    override init() {
        super.init()
        self.dataModelSharedInstance = DataModel.dataModelSharedInstance
    }
    //MARK: - HelperFunctions
    
    /*/ resetNodeList()
     Reinitalizes nodeList into a new Array of SCNNodes
    */
    private func resetNodeList(){
        self.nodeList = Array<SCNNode>()
    }
    /*/ reset()
     Resets beaconImageName to nil
     Resets nodeList to nil
    */
    func reset(){
        self.beaconImageName = nil
        self.nodeList = nil
    }
    /*/ setUpNavigation (renderedBeaconNode: SCNNode) -> SCNNode
     Sets up navigation for when a marker is scanned and user is looking to go to a destination.
     
     @param: SCNNode - the SCNNode that contains the information about the marker scanned
     
     @return: SCNNode - node with a plotted route with the SCNNode at the center
     */
    func setUpNavigation(renderedBeaconNode: SCNNode) -> SCNNode{
        //Reinitializes nodeList = nil
        resetNodeList()
        //List of nodes to traverse
        let list = self.dataModelSharedInstance!.getNodeManager().getNodeList()
        
        //reference to origin node
        var buildingNode = renderedBeaconNode
        //Sets the last referenced node (source node) to the marker node
        dataModelSharedInstance!.getNodeManager().setLastReferencedNode(node: renderedBeaconNode)
        //Traverses nodeList, adding nodes to destination
        for (index, _) in list.enumerated() {
            buildingNode = self.placeNode(subNodeSource: renderedBeaconNode, to: list[index])
        }
        //Places arrows above the nodes within nodeList using the marker node as its origin
        self.placeArrowNodes(sourceNode: renderedBeaconNode)
        //Kicks off an async function to determine if user reached destination (camera node within a certain distance of the last node)
        //self.checkDestinationLoop()
        return buildingNode
    }
    /*/ placeNode(subNodeSource: SCNNode, to: Index) -> SCNNode
     
     @param: SCNNode - the source node which all new nodes are placed relative to.
     @param: Index(LocationInfo.Index) - Class object which houses information about the next node's x,y,z offset from the previous node.
     
     @return: SCNNode - returns marker node origin
     */
    private func placeNode(subNodeSource: SCNNode, to: Index) -> SCNNode{
        let sphere = SCNSphere(radius: 0.05)
        //Makes the AR Node a sphere
        let node = SCNNode(geometry: sphere)
        node.geometry?.firstMaterial?.diffuse.contents = AppThemeColorConstants.blue
        
        let xOffset = to.xOffset
        let yOffset = to.yOffset
        let zOffset = to.zOffset
        
        //builds an array with x,y,z in it
        let transformationArray = buildArray(x: xOffset, y: yOffset, z: zOffset)
        //Gets the last referencednode, this node is already plotted and its parent is the markernode source. Plotting a node against this lastReferencedNode will take into account the lastReferencedNode position, and add on any translations to the new node being created. Thus all translations to and from any node is from the marker node and the new node being created.
        let lastNode = dataModelSharedInstance!.getNodeManager().getLastReferencedNode()
        
        //Gets the 4x4 matrix float of the last referenced node
        let referenceNodeTransform = matrix_float4x4(lastNode!.transform)
        var translation = matrix_identity_float4x4
        
        translation.columns.3.x = transformationArray[0]
        translation.columns.3.y = transformationArray[1]
        translation.columns.3.z = transformationArray[2]
        
        //Multiplies the lastReferencedNode position by the translation to the new node being created. This sets the new node's position
        node.simdTransform = matrix_multiply(referenceNodeTransform, translation)
        
        //Adds the new node to the marker node source
        subNodeSource.addChildNode(node)
        
        //Checks to see if a line needs to be added. Adds a line above only if the new node is not a starting node. LocationInfo.NodeType
        if (to.type != NodeType.start.rawValue){
            placeLine(sourceNode: subNodeSource, from: lastNode!, to: node)
        }
        
        //Adds the new node created to the nodeList
        self.nodeList!.append(node)
        //Sets the last referenced node to the new node being created which enables the methodology above.
        dataModelSharedInstance!.getNodeManager().setLastReferencedNode(node: node)
        
        return subNodeSource
    }
    /* placeLine(sourceNode: SCNNode, from: SCNNode, to: SCNNode)
     places a new SCNObject, an line, within the scene bounded to the sourceNode. The line connects to the next node.
     
     @params: sourceNode - the source node where the line should be referenced from.
     @params: from - the node where the tail end of the line should be position at
     @params: to - the node where the line should be end at.
     */
    private func placeLine(sourceNode: SCNNode, from: SCNNode, to: SCNNode){
        let node = SCNGeometry.cylinderLine(from: from.position, to: to.position, segments: 5)
        sourceNode.addChildNode(node)
        //Checker to see if the user is building a custom map. If yes, then it refers to the singleton NodeManager.swift and adds a line node.
        if (dataModelSharedInstance!.getLocationDetails().getIsCreatingCustomMap()){
            dataModelSharedInstance!.getNodeManager().addLineNode(node: node)
        }
    }
    /*/ buildArray(x: Float, y: Float, z: Float) -> Array<Float>
     builds an array containning x,y,z float values
     
     @params: x - float of the x pos
     @params: y - float of the y pos
     @params: z - float of the z pos
     */
    private func buildArray(x: Float, y: Float, z: Float) -> Array<Float>{
        var returningArray = Array<Float>()
        returningArray.append(x)
        returningArray.append(y)
        returningArray.append(z)
        return returningArray
    }
    /*/ placeArrowNodes(sourceNode: SCNNode)
     places arrows from one node to the next node until the destination node is traversed.
     
     @params: sourceNode - the source node where the arrow should be referenced from.
     */
    private func placeArrowNodes(sourceNode: SCNNode){
        //the nodeList that needs to be traversed.
        let traverseList = self.nodeList
        let size = traverseList!.count - 1
        for (index, _) in traverseList!.enumerated() {
            if (index != size){
                let node1 = traverseList![index]
                let node2 = traverseList![index + 1]
                
                let referenceNodeTransform = matrix_float4x4(node1.transform)
                var translation = matrix_identity_float4x4
                
                translation.columns.3.x = 0
                translation.columns.3.y = 0
                //Raises the position of the arrow above the node (z value)
                translation.columns.3.z = Float(ArkitNodeDimension.arrowNodeXOffset) * -1
                
                //returns a clone of a SCNNode which was already initialized when NodeManager was initialized.
                let arrow = dataModelSharedInstance!.getNodeManager().getArrowNode()
                arrow.simdTransform = matrix_multiply(referenceNodeTransform, translation)
            
                sourceNode.addChildNode(arrow)
                //The way the arrow's x,y,z is setup in art.scnassets/arrow.scn allows the arrow to point perfectly towards node2.position when calling SCNNode.look.
                arrow.look(at: node2.position)
            }
        }
    }
    /*/ placeBuildingNode(sourceNode: SCNNode, lastNode: SCNNode, targetNode: Index)
     places a SCNNode when creating a custom map, modified depending on type of node (start,intermediate, destination)
     
     @param: sourceNode - the marker node where the new node will be plotted from.
     @param: lastNode - the last referenced node when plotting
     @param: targetNode - LocationInfo.Index - the new node's positions and values
     
     */
    private func placeBuildingNode(sourceNode: SCNNode, lastNode: SCNNode, targetNode: Index){
        let sphere = SCNSphere(radius: 0.03)
        let node = SCNNode(geometry: sphere)
        //Determines color of node
        switch targetNode.type{
        case NodeType.start.rawValue:
            node.geometry?.firstMaterial?.diffuse.contents = AppThemeColorConstants.white
        case NodeType.destination.rawValue:
            node.geometry?.firstMaterial?.diffuse.contents = AppThemeColorConstants.white
        case NodeType.intermediate.rawValue:
            node.geometry?.firstMaterial?.diffuse.contents = AppThemeColorConstants.blue
        default:
            break
        }
        
        let referenceNodeTransform = matrix_float4x4(lastNode.transform)
        var translation = matrix_identity_float4x4
        translation.columns.3.x = targetNode.xOffset
        translation.columns.3.y = targetNode.yOffset
        translation.columns.3.z = targetNode.zOffset
        //sets the new node position to the lastReferencedNode.transform multiplied by the translation.
        node.simdTransform = matrix_multiply(referenceNodeTransform, translation)
        
        //Sets the last referened node to the new node.
        dataModelSharedInstance!.getNodeManager().setLastReferencedNode(node: node)
        //Adds a ScnNode to the NodeManager.scnNodeList
        dataModelSharedInstance!.getNodeManager().addScnNode(node: node)
        //Adds the new node to the marker node.
        sourceNode.addChildNode(node)
    }
    
    /*/ resetToCustomMapStartNode()
     If the undo button is pressed while creating a custom map all the way to the beginning, it will reset the scene to the start state.
     */
    private func resetToCustomMapStartNode(){
        //Sets the NodeManager.startingNodeIsSet = false, which indicates that the user needs to place the start node when building a custom map.
        dataModelSharedInstance!.getNodeManager().setStartingNodeIsSet(isSet: false)
        //Instructs the user with instructions on how to create  custom map. Text is located at Constants.TextConstants
        DispatchQueue.main.async {
            self.dataModelSharedInstance?.getMainVC().setBottomLabelText(text: TextConstants.beaconFoundAddStartNode)
        }
    }
    /*/ getNodeDataAndPlotBuildingNode(type: NodeType)
     Function called when building a custom map. It will get the cameranode, source (marker) node, and last referenced node to construct the necessary information for a new node wherever in the world the user added a new node.
     
     @param: type - LocationInfo.NodeType - type of node being placed
     */
    private func getNodeDataAndPlotBuildingNode(type: NodeType){
        //Gets current position using the camera as a reference
        let cameraTransform = dataModelSharedInstance!.getSceneView().session.currentFrame!.camera.transform
        let cameraPosition = SCNVector3Make(cameraTransform.columns.3.x,
                                            cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        //The source marker node
        let sourceNode = dataModelSharedInstance!.getNodeManager().getReferencedBeaconNode()
        
        var referencedNode: SCNNode
        //Determines what node to use as a reference to plot new node
        if (type == NodeType.start){
            referencedNode = sourceNode!
        } else {
            referencedNode = dataModelSharedInstance!.getNodeManager().getLastReferencedNode()!
        }
        //position of the reference (last traversed) node
        let referencedPosition = referencedNode.position
        
        //Finds the delta from the last referenced node and the camera node.
        let xDist = cameraPosition.x - referencedPosition.x
        let yDist = cameraPosition.y - referencedPosition.y
        let zDist = cameraPosition.z - referencedPosition.z
        
        var newNode: Index
        //Constructs a new node depending on the type.
        if (type == NodeType.destination || type == NodeType.intermediate) {
            if (type == NodeType.destination){
                newNode = Index(type: NodeType.destination.rawValue, xOffset: xDist, yOffset: yDist, zOffset: zDist)
            } else {
                newNode = Index(type: NodeType.intermediate.rawValue, xOffset: xDist, yOffset: yDist, zOffset: zDist)
            }
            //Adds a new SCNNode to the screen when the user added a new node.
            placeBuildingNode(sourceNode: sourceNode!, lastNode: referencedNode, targetNode: newNode)
            //Get the last referenced SCNNode. the function above this "placeBuildingNode" adds its newly created SCNNode to the NodeManager.scnNodeList. getting this node allows for the next function to work.
            let currentNode = dataModelSharedInstance!.getNodeManager().getLastScnNode()
            //Places a line referenced to the marker node, from the lastReferencedNode, to the new SCNNode just created.
            placeLine(sourceNode: sourceNode!, from: referencedNode, to: currentNode!)
        } else {
            // Constructs a new Node of type NodeType.Start
            newNode = Index(type: NodeType.start.rawValue, xOffset: xDist, yOffset: yDist, zOffset: zDist)
            placeBuildingNode(sourceNode: sourceNode!, lastNode: referencedNode, targetNode: newNode)
        }
        //Adds to NodeManager.nodeList the new SCNNode Created
        dataModelSharedInstance!.getNodeManager().addNode(node: newNode)
    }
    
    //MARK: - Handler Functions
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print("Detected UPdate")
    }
    /*/ renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?
     Implemented Function. Everytime a new marker is scanned with the camera, it will run this function.
     */
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node: SCNNode?
        //Checks to see if either the user is creating a custom map or started up navigation and if the marker root node has not been scanned yet.
        if (dataModelSharedInstance!.getLocationDetails().getIsNavigating() || dataModelSharedInstance!.getLocationDetails().getIsCreatingCustomMap() &&
            !dataModelSharedInstance!.getLocationDetails().getIsBeaconRootNodeFound()){
            
            //Locks the WorldOrigin to the first beacon scanned
            if (!dataModelSharedInstance!.getLocationDetails().isWorldOriginSet) {
                dataModelSharedInstance!.getSceneView().session.setWorldOrigin(relativeTransform: anchor.transform)
                dataModelSharedInstance!.getSceneView().debugOptions = [ARSCNDebugOptions.showWorldOrigin]
                //Notifies inside the centralized datahub that the world origin is set to the marker node
                dataModelSharedInstance!.getLocationDetails().setIsWorldOriginSet(isSet: true)
            }
            
            //If a marker is scanned and recognized, this function is ran. It checks to see if user is navigating already and if so, will do the proper setup to kickoff navigation
            if (dataModelSharedInstance!.getLocationDetails().getIsNavigating()){
                let mainVC = self.dataModelSharedInstance!.getMainVC()
                var loadingIndicator: UIViewController?
                
                DispatchQueue.main.async {
                    loadingIndicator = ViewController.getLoadingIndicator()
                    mainVC.present(loadingIndicator!, animated: false, completion: nil)
                }
                
                //Returns a node with an AR Object indicating the marker location
                node = returnBeaconHighlightNode(anchor: anchor)
                
                //Initial call to the nodejs server with a request for navigation instructions. If the request returns something that is decodable into an Array<LocationInfo.Index>, it continues, else, the process is cancelled and the user is alerted navigation failed.
                dataModelSharedInstance!.getNodeManager().generateNodeList { bool in
                    if !bool {
                        DispatchQueue.main.async {
                            loadingIndicator!.dismiss(animated: false, completion: {
                                mainVC.cancelButtonClicked()
                                mainVC.alert(info: AlertConstants.serverRequestFailed)
                            })
                        }
                    } else {
                        DispatchQueue.main.async{
                            loadingIndicator!.dismiss(animated: false, completion: {
                                mainVC.beaconFoundInitiateDisappear()
                            })
                        }
                        //Sets up navigation using the marker node as the origin for all other nodes.
                        node = self.setUpNavigation(renderedBeaconNode: node!)
                        //Sets world node for intermediate nodes
                        self.dataModelSharedInstance!.getNodeManager().setReferencedBeaconNode(node: node!)
                    }
                }
            } else {
                //If user is building a custom map, the process to start is kicked off here.
                let mainVC = dataModelSharedInstance!.getMainVC()
                DispatchQueue.main.async {
                    mainVC.setBottomLabelText(text: TextConstants.beaconFoundAddStartNode)
                    mainVC.toggleAddButton(shouldShow: true)
                }
                //Returns the marker node with an AR Object highlighted to show its position
                node = returnBeaconHighlightNode(anchor: anchor)
                //Sets world node for intermediate nodes
                dataModelSharedInstance!.getNodeManager().setReferencedBeaconNode(node: node!)
            }
        } else {
            //If the user is not building a custom map or navigating, returns just the marker node with an AR Object bound to its location
            node = returnBeaconHighlightNode(anchor: anchor)!
        }
        return node
    }
    
    //MARK: - Helper Handler Functions
    
    /*/ returnBeaconHighlightNode(anchor: ARAnchor) -> SCNNode?
     Takes in an ARAnchor of a scanned image, validates the marker, returns the marker node with an ARObject bound to its position.
     
     @param: anchor - ARAnchor - the marker anchor that was scanned by the camera
     
     @return: SCNNode? - the marker node that has an AR Object bound to the position
     */
    private func returnBeaconHighlightNode(anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        //Validates the marker that was scanned.
        if let imageAnchor = anchor as? ARImageAnchor{
            let size = imageAnchor.referenceImage.physicalSize
            let plane = SCNPlane(width: size.width, height: size.height)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0)
            plane.cornerRadius = 0.005
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            //Assumes that the image is upright on a vertical surface.
            node.addChildNode(planeNode)
            
            var shapeNode : SCNNode?
            //Retrieves the referenceName inside the Assets.xcassets/ARResources
            beaconImageName = imageAnchor.referenceImage.name
            
            //If the marker node has not been scanned while navigating or creating a custom map, this function will run
            if (!dataModelSharedInstance!.getLocationDetails().getIsBeaconRootNodeFound()){
                if (dataModelSharedInstance!.getLocationDetails().getIsNavigating() || dataModelSharedInstance!.getLocationDetails().getIsCreatingCustomMap()){
                    self.dataModelSharedInstance!.getNodeManager().setReferencedBeaconName(name: beaconImageName)
                    dataModelSharedInstance!.getLocationDetails().setIsBeaconRootNodeFound(isFound: true)
                }
            }
            
            //This is the area where you are able to choose what markers you want to use. The way this is setup right now is that every marker returns the same uniform AR Object.
            if imageAnchor.referenceImage.name == "pi" || imageAnchor.referenceImage.name == "1"{
                shapeNode = dataModelSharedInstance!.getNodeManager().getbeaconNode()
            }
            guard let shape = shapeNode else {return nil}
            //Adds the ARObject to the marker position
            node.addChildNode(shape)
        }
        return node
    }
    
    //MARK: - Timer Functions
    
    /*/ checkDestinationLoop()
     This is called when the user is currently navigating. It continously and asyncrhonomously checks to see if the user has reached within an acceptable range of the destination node. If so, it will notify the user.
     
     */
    private func checkDestinationLoop() {
        //Gets the last node, destination node
        let lastNode = dataModelSharedInstance!.getNodeManager().getLastReferencedNode()
        let lastNodePosition = lastNode!.position
        
        var cameraTransform = dataModelSharedInstance!.getSceneView().session.currentFrame!.camera.transform
        var cameraPosition = SCNVector3Make(cameraTransform.columns.3.x,
        cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        
        var distance = lastNodePosition.distance(receiver: cameraPosition)

        //Allows the asycnrhonous portion of this function
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .default).async {
            while distance > 1.5 && self.dataModelSharedInstance!.getLocationDetails().getIsNavigating(){
                    cameraTransform = self.dataModelSharedInstance!.getSceneView().session.currentFrame!.camera.transform
                    cameraPosition = SCNVector3Make(cameraTransform.columns.3.x,
                    cameraTransform.columns.3.y, cameraTransform.columns.3.z)
                    
                    distance = lastNodePosition.distance(receiver: cameraPosition)
                    usleep(500000)
            }
            group.leave()
        }
        //Handles the completion of the group.leave() function call when the destination is within range
        group.notify(queue: .main) {
            self.delegate!.destinationReached()
        }
    }
    
}
/*/ Extension - ViewControllerDelegate (Utils/Protocols)
 This extends the protocol created inside Utils/Protocols. This handles the delegate functions when creating a custom map.
 */
extension ARSceneViewDelegate: ViewControllerDelegate {
    func handleMenuButtonToggle(forMenuOption menuOption: MenuOption?) {}
    /*/ handleEndButton()
     Handles the end button while creating a custom map. This does the necessary cleanup on screen
     */
    func handleEndButton() {
        DispatchQueue.main.async {
            self.dataModelSharedInstance?.getMainVC().setBottomLabelText(text: TextConstants.endNodePlaced)
        }
        //Sets within the data center that the destination node when creating a custom map is set.
        dataModelSharedInstance!.getNodeManager().setDestinationNodeIsSet(isSet: true)
        //Plots the destination node at the current camera position.
        getNodeDataAndPlotBuildingNode(type: NodeType.destination)
        
        //Removes/Adds necessary buttons on the root VC.
        delegate!.toggleEndButton(shouldShow: false)
        delegate!.toggleAddButton(shouldShow: false)
        delegate!.toggleSaveButton(shouldShow: true)
    }
    /*/ handleEndButton()
     Handles the undo button while creating a custom map. This does the necessary changes to revert the actions done to the prior step.
     */
    func handleUndoButton() {
        //Gets all necessary nodes that were added from the last add button.
        let scnNode = dataModelSharedInstance!.getNodeManager().getLastScnNode()
        let node = dataModelSharedInstance!.getNodeManager().getLastNode()
        let lineNode = dataModelSharedInstance!.getNodeManager().getLastLineNode()
        
        //Checks to see if the last node added was type NodeType.destination. If so, it will remove the save button and toggle the Add & End button.
        if (node!.type == NodeType.destination.rawValue) {
            DispatchQueue.main.async {
                self.dataModelSharedInstance?.getMainVC().setBottomLabelText(text: TextConstants.startNodeAddedAddIntermediate)
            }
            delegate!.toggleEndButton(shouldShow: true)
            delegate!.toggleAddButton(shouldShow: true)
            delegate!.toggleSaveButton(shouldShow: false)
        }
        //Checks to see if the node is not nil. Ensures that it will only remove the recent node.
        if (scnNode != nil && node != nil){
            dataModelSharedInstance!.getNodeManager().removeLastScnNode()
            dataModelSharedInstance!.getNodeManager().removeLastNode()
            scnNode!.removeFromParentNode()
        }
        //Checks to see if the lineNode added is not nil.
        if (lineNode != nil) {
            dataModelSharedInstance!.getNodeManager().removeLastLineNode()
            lineNode!.removeFromParentNode()
        }
        //Retrieves the sizes of the scnNodeList and nodeList within NodeManager.
        let sizeOfScnNodeList = dataModelSharedInstance!.getNodeManager().getLengthOfScnNodeList()
        let sizeOfNodeList = dataModelSharedInstance!.getNodeManager().getLengthOfNodeList()
        
        //If both sizes are 0, then it will reset to the start state of creating a custom map.
        if (sizeOfNodeList == 0 && sizeOfScnNodeList == 0){
            resetToCustomMapStartNode()
        }
        
        //Handles the proper pointer towards the last node.
        let lastReferenced = dataModelSharedInstance!.getNodeManager().getLastScnNode()
        if (lastReferenced != nil ){
            dataModelSharedInstance!.getNodeManager().setLastReferencedNode(node: lastReferenced!)
        }
    }
    /*/ handleEndButton()
     Handles the add button while creating a custom map. This does the necessary changes to add a new node and prepare for the next step.
     */
    func handleAddButton() {
        //Checks to see if the starting node is already set. If not, it will do the changes to enable the user to place intermediate/destination nodes.
        if (!dataModelSharedInstance!.getNodeManager().getStartingNodeIsSet()){
            DispatchQueue.main.async {
                self.dataModelSharedInstance!.getMainVC().setBottomLabelText(text: TextConstants.startNodeAddedAddIntermediate)
            }
            dataModelSharedInstance!.getNodeManager().setStartingNodeIsSet(isSet: true)

            //Plots the starting node, adds it to the data center, plots on the screen
            getNodeDataAndPlotBuildingNode(type: NodeType.start)
            
            delegate!.toggleEndButton(shouldShow: true)
            delegate!.toggleUndoButton(shouldShow: true)
        } else {
            //Plots the intermediate/destination node, adds it to the data center, plots on the screen
            getNodeDataAndPlotBuildingNode(type: NodeType.intermediate)
        }
    }
}
/*/ Extension - SCNVector3
 This extends SCNVector3. This is used to find the distance from one SCNVector3 to anther SCNVector3.
 */
extension SCNVector3 {
    /*/ distance(receiver: SCNVector3) -> Float
     returns the distance from one SCNVector3 to another SCNVector3
     
     @param: SCNVector3 - the position of the other SCNVector3
     
     @return: Float - the distance between the two SCNVector3
     */
    func distance(receiver: SCNVector3) -> Float {
        let xd = self.x - receiver.x
        let yd = self.y - receiver.y
        let zd = self.z - receiver.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        if distance < 0 {
            return distance * -1
        } else {
            return distance
        }
    }
}
/*/ Extension - SCNNode
 This extends SCNNode. This is used to find the distance from one SCNNode to anther SCNNode.
 */
extension SCNNode {
    /*/ distance(receiver: SCNNode) -> Float
     returns the distance from one SCNNode to another SCNNode
     
     @param: SCNNode - the position of the other SCNNode
     
     @return: Float - the distance between the two SCNNode
     */
    func distance(receiver: SCNNode) -> Float {
        let node1Pos = self.position
        let node2Pos = receiver.position
        let xd = node2Pos.x - node1Pos.x
        let yd = node2Pos.y - node1Pos.y
        let zd = node2Pos.z - node1Pos.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        if distance < 0 {
            return distance * -1
        } else {
            return distance
        }
    }
}
/*/ Extension - SCNGeometry
 This extends SCNGeometry. This is used to create a line from one SCNVector3 to another SCNVector3, and return that line as a node.
 */
extension SCNGeometry {
    /*/ cylinderLine(from: SCNVector3, to: SCNVector3, segments: Int) -> SCNNode
     returns a SCNNode which represents a line from one SCNVector3 to another SCNVector3
     
     @param: from - the position of the other SCNNode
     @param: to - the position of the other SCNNode
     @param: segments - the number of segments
     
     @return: SCNNode - the SCNNode containning the line
     */
    class func cylinderLine(from: SCNVector3, to: SCNVector3, segments: Int) -> SCNNode{
        let x1 = from.x
        let x2 = to.x
        
        let y1 = from.y
        let y2 = to.y
        
        let z1 = from.z
        let z2 = to.z
        
        let distance = sqrtf((x2 - x1) * (x2 - x1) +
            (y2 - y1) * (y2 - y1) +
            (z2 - z1) * (z2 - z1))
        
        //Creates a SCNCylinder with the height of it being the distance from the two SCNVector3
        let cylinder = SCNCylinder(radius: 0.005,
                                   height: CGFloat(distance))
        
        cylinder.radialSegmentCount = segments
        cylinder.firstMaterial?.diffuse.contents = AppThemeColorConstants.white
        
        let lineNode = SCNNode(geometry: cylinder)
        
        //Sets the position of the lineNode's center to the inbetween of the first SCNVector3 and second SCNVector3. This accounts fo the proper size of the line segment when added to the source node (marker node).
        lineNode.position = SCNVector3(((from.x + to.x)/2),
                                       ((from.y + to.y)/2),
                                       ((from.z + to.z)/2))
        
        //Handles the orientation of the line
        lineNode.eulerAngles = SCNVector3(Float.pi/2,
                                          acos((to.z - from.z)/distance),
                                          atan2(to.y - from.y, to.x - from.x))
        
        return lineNode
    }
}
