//  ARIndoorNav
//
//  ProfileController.swift
//  Class - ProfileController.swift
//  Extensions - loginControllerDelegate
//
//  Created by Allie Do on 7/23/20.
//  Modifed by Bryan Ung
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This class shows the user's profile. If user does not exist, it automatically pushes
//  the LoginController.swift to view.

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    //MARK: - Properties
    
    //Custom UIView - View/ProfileContainer.swift
    var profileView: ProfileView?
        
    //MARK: - Init
    
    /*/ viewDidLoad()
     Implementation of function that configures the view and checks user authentication.
     Depending on the result of the checkUserAuthentication() function, it will call a function handleResultsFromAuth() which handles both cases (user logged in, user not logged in)
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        view.backgroundColor = AppThemeColorConstants.white
        checkUserAuthentication() { boo in
            self.handleResultsFromAuth(result: boo, animated: false)
        }
    }
    /*/ viewWillAppear(_ animated: Bool)
     Implementation of function that sets the navigation bar to visible.
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    /*/ viewWillDisappear(_ animated: Bool)
     Implementatin of function that sets the navigation bar to hidden.
     */
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Handlers
    
    /*/ handleSignOut()
     Handles the user signning out of their account. When the sign out process begins, it will present an alertController to the user to confirm their action.
     */
    @objc func handleSignOut(){
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler:  { (_) in self.signOut()}))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    /*/ handleBack()
     Handles the back button being clicked from the ProfileController Navigation's Bar.
     Dismisses the ProfileController
     */
    @objc func handleBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Configurations
    
    /*/ configureView()
     Configures the view. Constructs a custom UIView - /View/ProfileContainer.swift and configures it to fit on the screen.
     */
    func configureView() {
        profileView = ProfileView()
        self.view.addSubview(profileView!)
        profileView!.setConstraints(top: self.view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    /*/ configureNavigationBar()
     Configures the navgation bar
     */
    func configureNavigationBar(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppThemeColorConstants.blue
        appearance.titleTextAttributes = [.foregroundColor: AppThemeColorConstants.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: AppThemeColorConstants.white]
        
        self.navigationController?.navigationBar.tintColor = AppThemeColorConstants.white
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance

        self.navigationItem.title = "Profile"
        self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleBack))
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setNeedsLayout()
    }
    
    //MARK: - Helper functions
    
    /*/ toggleSignOutButton(shouldShow: Bool)
     Toggles the signOut Button which appears on the navigation bar right item.
     
     @param: shouldShow - Bool - boolean value determining if button should show.
     */
    func toggleSignOutButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleSignOut))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    /*/ checkUserAuthentication(completion: @escaping(Bool) -> Void)
     Checks with Firebase whether or not the user is signed in.
     */
    func checkUserAuthentication(completion: @escaping(Bool) -> Void) {
        if Auth.auth().currentUser == nil {
            completion(false)
        } else {
            toggleSignOutButton(shouldShow: true)
            completion(true)
        }
    }
    /*/ handleResultsFromAuth(result: Bool, animated: Bool)
     Is called after the user authentication is checked. Depending on the scenario, different things happen.
     1. User is logged in, configures the ProfileController's view.
     2. User is not logged in, pushes the LoginController.swift VC.
     
     @param: result - Bool - boolean value determining status of authentication.
     @param: animated - Bool - animation of controller view switching.
     */
    func handleResultsFromAuth(result: Bool, animated: Bool){
        switch result {
        case true:
            self.configureView()
        case false:
            let loginController = LoginController()
            loginController.delegate = self
            self.navigationController?.pushViewController(loginController, animated: animated)
        }
    }
    /*/ signOut()
     handles the signing out of the user
     */
    func signOut(){
        do {
            try Auth.auth().signOut()
            checkUserAuthentication() { boo in
                self.handleResultsFromAuth(result: boo, animated: true)
            }
        } catch let error {
            print ("Failed to sign out with error ...", error)
        }
    }
}
/*/ Extension - loginControllerDelegate
 This extension allows the class to handle actions of the LoginController. It handles the login button being pressed from the LoginController.swift
 */
extension ProfileController: loginControllerDelegate {
    /*/ handleLoginButton()
     handles the login button being pressed from the LoginController.swift. It will check user authentication and depending on the results it will either dismiss the VC or call a helper function to handle population of the profileController.
     */
    func handleLoginButton() {
        checkUserAuthentication() { boo in
            switch boo {
            case true:
                self.handleResultsFromAuth(result: boo, animated: false)
            case false:
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
