//  ARIndoorNav
//
//  ContainerController.swift
//  Class - ContainerController
//  Extensions - ViewControllerDelegate, ManageMapsControllerDelegate

//  Created by Bryan Ung on 6/30/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  Class houses the main VC view, and the hamburger menu VC view. Controls when the views are shown/hidden, and helps serve as a central navigation handler to new VCs. Furthermore, it connects multiple VCs.

import UIKit

class ContainerController: UIViewController {
    
    // MARK: - Properties
    
    //Animation for the status bar on top
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    //Status bar boolean hidden value
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    //View Controller with ARSceneView
    var viewController: ViewController!
    //Top Level Controller
    var centerController: UIViewController!
    //View Controller with Hamburger Menu Bar
    var menuController: MenuController!
    var isExpanded = false
    var dataModelSharedInstance: DataModel!
    
    // MARK: - Init
    
    /*/ viewDidLoad()
     Initialization of View Controllers and Data Center.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureMenuController()
        initDataModel()
    }
    //MARK: - Helper Functions
    
    /*/ configureViewController()
     Configuration for the the centerController and viewController
     */
    private func configureViewController(){
        viewController = ViewController()
        centerController = UINavigationController(rootViewController: viewController)
        guard let navController = centerController as? UINavigationController else {return}
        navController.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    /*/ configureMenuController()
     Configuration for the the MenuController
     */
    private func configureMenuController(){
        if menuController == nil {
            menuController = MenuController()
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    /*/ initDataModel()
     Initialization of the centralized DataModel
     */
    private func initDataModel(){
        self.dataModelSharedInstance = DataModel.dataModelSharedInstance

        let ARSCNViewDelegateSharedInstance = ARSceneViewDelegate.ARSCNViewDelegateInstance
        let locationDetailsSharedInstance = LocationDetails.LocationDetailsSharedInstance
        let locationManagerSharedInstance = LocationManager.locationManagerInstance
        let nodeManagerSharedInstance = NodeManager.nodeManagerSharedInstance
        let dataStoreManagerSharedInstance = DataStoreManager.dataStoreManagerSharedInstance
        
        dataModelSharedInstance.setMainVC(vc: viewController)
        dataModelSharedInstance.setLocationDetails(locationDetails: locationDetailsSharedInstance)
        dataModelSharedInstance.setLocationManager(locationManager: locationManagerSharedInstance)
        dataModelSharedInstance.setARSCNViewDelegate(ARSCNViewDelegate: ARSCNViewDelegateSharedInstance)
        dataModelSharedInstance.setNodeManager(nodeManager: nodeManagerSharedInstance)
        dataModelSharedInstance.setDataStoreManager(dataStoreManager: dataStoreManagerSharedInstance)
        
        menuController.delegate = self
        viewController.delegateContainerController = self
        viewController.delegateARSceneViewDelegate = ARSCNViewDelegateSharedInstance
        ARSCNViewDelegateSharedInstance.delegate = viewController
        
        print(ConsoleConstants.dataModelSucces)
    }
    
    // MARK: - Handlers
    
    /*/ animatePanel(shouldExpand: Bool, menuOption: MenuOption?)
     Shows/Hides the menu VC from the main VC. Handles actions that is clicked on the menu VC.
     
     @param: shouldExpand - Bool - Value deciding whether or not the menu VC should be shown
     @param: menuOption - MenuOption - option on the menu VC that was selected
     */
    private func animatePanel(shouldExpand: Bool, menuOption: MenuOption?){
        if shouldExpand{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        //Decides if the status bar needs to be hidden/shown
        animateStatusBar()
    }
    /*/ didSelectMenuOption(menuOption: MenuOption)
     Handles what to do when a Menu Option is selected.
     
     @param: MenuOption - the menuOption selected
     */
    private func didSelectMenuOption(menuOption: MenuOption){
        switch menuOption {
            case .Profile:
                let profileController = ProfileController()
                let controller = UINavigationController(rootViewController: profileController)
                controller.navigationItem.hidesSearchBarWhenScrolling = false
                controller.modalPresentationStyle = .fullScreen
                present(controller, animated: true, completion: nil)
            case .Settings:
                let settingsController = SettingsController()
                let controller = UINavigationController(rootViewController: settingsController)
                controller.modalPresentationStyle = .fullScreen
                present(controller, animated: true, completion: nil)
            case .Maps:
                let mapsController = ManageMapsController()
                mapsController.manageMapsControllerDelegate = self
                let controller = UINavigationController(rootViewController: mapsController)
                controller.navigationItem.hidesSearchBarWhenScrolling = false
                controller.modalPresentationStyle = .fullScreen
                present(controller, animated: true, completion: nil)
        }
    }
    /*/ animateStatusBar ()
     Updates the Status Bar Appearance (hidden/shown)
     */
    func animateStatusBar (){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}
/*/ Extension - ViewControllerDelegate (Utils/Protocols)
 This extends the protocol created inside Utils/Protocols. This handles the action when the hamburger menu is clicked.
 */
extension ContainerController: ViewControllerDelegate{
    /*/ handleMenuButtonToggle(forMenuOption menuOption: MenuOption?)
     Handles what happens when the hamburger menu button is clicked.
     
     @param: MenuOption - the option the was chosen
     */
    func handleMenuButtonToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
                configureMenuController()
            }
            isExpanded = !isExpanded
            animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
        }
    func handleUndoButton() {}
    func handleAddButton() {}
    func handleEndButton() {}
    func handleSaveButton() {}
}
/*/ Extension - ManageMapsControllerDelegate (Utils/Protocols)
 This extends the protocol created inside Utils/Protocols. This handles the action when the user decides to create a custom map within the ManageMapsController VC. It links to the main VC and begins the process
 */
extension ContainerController: ManageMapsControllerDelegate {
    /*/ createCustomMapProcess ()
     Handles the button within ManageMapsController VC that begins creating a custom map
     */
    func createCustomMapProcess() {
        viewController.customMapEditingBegan()
    }
}
