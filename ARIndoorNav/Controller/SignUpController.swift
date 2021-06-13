//  ARIndoorNav
//
//  SignUpController.swift
//  Class - SignUpController.swift
//  Extensions - UITextFieldDelegate
//
//  Created by Allie Do on 7/23/20.
//  Modified by Bryan Ung
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This class is responsible for Signing a User Up.

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    //MARK: - Properties
    
    //Delegate = LoginController.swift
    var delegate: signUpControllerDelegate?
    var errorLabel: UILabel?
    let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        logo.image = #imageLiteral(resourceName: "download.png")
        return logo
    }()
    let formTitleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Sign Up"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = AppThemeColorConstants.blue
        return label
    }()
    lazy var emailContainerView: UIView = {
        let view = UIView()
        let image = UIImage(systemName: "envelope.fill")
        //Located in Extensions.swift
        return view.textContainerView(view: view, image!, emailTextField, tintColor: AppThemeColorConstants.blue, addMiniText: false, miniText: nil, miniTextTintColor: nil)
    }()
    lazy var usernameContainerView: UIView = {
        let view = UIView()
        let image = UIImage(systemName: "person.fill")
        //Located in Extensions.swift
        return view.textContainerView(view: view, image!, usernameTextField, tintColor: AppThemeColorConstants.blue, addMiniText: false, miniText: nil, miniTextTintColor: nil)
    }()
    lazy var passwordContainerView: UIView = {
        var view = UIView()
        let image = UIImage(systemName: "lock.fill")
        //Located in Extensions.swift
        return view.textContainerView(view: view, image!, passwordTextField, tintColor: AppThemeColorConstants.blue, addMiniText: true, miniText: TextConstants.passwordRequirements, miniTextTintColor: AppThemeColorConstants.gray)
    }()
    lazy var emailTextField: UITextField = {
        var tf = UITextField()
        //Located in Extensions.swift
        tf = tf.textField(withPlaceholder: "Email", isSecureTextEntry: false, tintColor: AppThemeColorConstants.blue)
        tf.delegate = self
        return tf
    }()
    lazy var usernameTextField: UITextField = {
        var tf = UITextField()
        //Located in Extensions.swift
        tf = tf.textField(withPlaceholder: "Username", isSecureTextEntry: false, tintColor: AppThemeColorConstants.blue)
        tf.delegate = self
        return tf
    }()
    lazy var passwordTextField: UITextField = {
        var tf = UITextField()
        //Located in Extensions.swift
        tf = tf.textField(withPlaceholder: "Password", isSecureTextEntry: true, tintColor: AppThemeColorConstants.blue)
        tf.delegate = self
        return tf
    }()
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SIGN UP", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(AppThemeColorConstants.white, for: .normal)
        button.backgroundColor = AppThemeColorConstants.blue
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CANCEL", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(AppThemeColorConstants.red, for: .normal)
        button.backgroundColor = AppThemeColorConstants.white
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSMutableAttributedString(string:"Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: AppThemeColorConstants.blue])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: AppThemeColorConstants.blue]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleMoveToSignInButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    
    /*/ viewDidLoad()
     Implementation of function that configures view components and properties.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //located in Extensions.swift
        self.hideKeyboardWhenTappedAround()
        configureViewComponents()
    }
    /*/ viewWillAppear(_ animated: Bool)
     Implementation of function that hides the navigation bar.
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Handler
    
    /*/ handleSignUp()
     Handles the signup button being pressed.
     */
    @objc func handleSignUp(){
        if errorLabel != nil {
            errorLabel!.removeFromSuperview()
        }
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let username = usernameTextField.text else {return}
        
        createUser(withEmail: email, password: password, username: username)
    }
    /*/ handleMoveToSignInButton()
     handles clicking move to Sign In button which pops this VC to the LoginController.swift
     */
    @objc func handleMoveToSignInButton(){
        navigationController?.popViewController(animated: true)
    }
    /*/ handleCancel()
     handles the cancel button which pops the VC to the Logincontroller.swift
     */
    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Functions
    
    /*/configureViewComponents()
     configures the view components
     */
    func configureViewComponents(){
        view.backgroundColor = AppThemeColorConstants.white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.setConstraints(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(formTitleView)
        formTitleView.setConstraints(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 48, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50
        )
        formTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailContainerView)
        emailContainerView.setConstraints(top: formTitleView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(usernameContainerView)
        usernameContainerView.setConstraints(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.setConstraints(top: usernameContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 35, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(signUpButton)
        signUpButton.setConstraints(top: passwordContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(cancelButton)
        cancelButton.setConstraints(top: signUpButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.setConstraints(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 12, paddingRight: 32, width: 0, height: 50)
    }
    
    // MARK: - API
    
    /*/ createUser(withEmail email: String, password: String, username: String)
     Tries to create a base user, if successful, it will present a FormController to fill out additional information.
     This function refers to a Firebase API call.
     */
    func createUser(withEmail email: String, password: String, username: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            //Error creating user in FB
            if let error = error {
                self.errorLabel = self.view.errorLabel(text: error.localizedDescription)
                DispatchQueue.main.async {
                    self.view.addSubview(self.errorLabel!)
                    self.errorLabel!.setConstraints(top: self.passwordContainerView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
                }
                return
            } else {
                //Error with user's UID
                guard let uid = result?.user.uid else {
                    DispatchQueue.main.async {
                        self.alert(info: AlertConstants.randomError)
                    }
                    return
                }
                //User created, updating user's information
                let values = ["email": email,  "username": username]
                Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                    //If updating values failed.
                    if error != nil {
                        DispatchQueue.main.async {
                            self.alert(info: AlertConstants.randomError)
                        }
                        return
                    } else {
                        self.delegate!.handleSignUpButton(email: email, password: password)
                        let formController = FormController()
                        formController.delegate = self.delegate
                        self.navigationController?.pushViewController(formController, animated: true)
                    }
                })
            }
        }
    }
}
/*/ Extension - UITextFieldDelegate
 This extension allows the class to handle actions with the textFields.
 */
extension SignUpController: UITextFieldDelegate{
    /*/ textFieldShouldReturn(_ textField: UITextField) -> Bool
     Implementation of function that ends editing when return is clicked while editing text
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
