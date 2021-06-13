//  ARIndoorNav
//
//  LoginController.swift
//  Class - LoginController.swift
//  Extensions - signUpControllerDelegate, UITextFieldDelegate
//
//  Created by Allie Do on 7/23/20.
//  Modified by Bryan Ung
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This class is responsible for the login process within the app.
//  Firebase is utilized for all authentication purposes.

import UIKit
import Firebase

class LoginController: UIViewController {
    
    //MARK: - Properties
    var errorLabel: UILabel?
    // Delegate = ProfileController.swift
    var delegate: loginControllerDelegate?
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
        label.text = "Sign In"
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
    lazy var passwordContainerView: UIView = {
        let view = UIView()
        let image = UIImage(systemName: "lock.fill")
        //Located in Extensions.swift
        return view.textContainerView(view: view, image!, passwordTextField, tintColor: AppThemeColorConstants.blue, addMiniText: false, miniText: nil, miniTextTintColor: nil)
    }()
    lazy var emailTextField: UITextField = {
        var tf = UITextField()
        //Located in Extensions.swift
        tf = tf.textField(withPlaceholder: "Email", isSecureTextEntry: false, tintColor: AppThemeColorConstants.blue)
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
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("LOG IN", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(AppThemeColorConstants.white, for: .normal)
        button.backgroundColor = AppThemeColorConstants.blue
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
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
        let attributedTitle = NSMutableAttributedString(string:"Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: AppThemeColorConstants.blue])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: AppThemeColorConstants.blue]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleMoveToSignUpButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    
    /*/ viewDidLoad()
     Implementation of function that initializes the view components and class properties.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //Located in Extensions.swift
        self.hideKeyboardWhenTappedAround()
        configureViewComponents()
    }
    /*/ viewWillAppear(_ animated: Bool)
     Implementation of function that sets the navigationBar to hidden.
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Selectors
    
    /*/ handleLogin()
     Handles the login when the login button is pressed
     */
    @objc func handleLogin(){
        if errorLabel != nil {
            errorLabel!.removeFromSuperview()
        }
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        logUserIn(withEmail: email, password: password, completion: { result in
            switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                    //ProfileController.swift handler
                    self.delegate!.handleLoginButton()
                case .failure(let error):
                    //Located in Exentsions.swift
                    self.errorLabel = self.view.errorLabel(text: error.localizedDescription)
                    DispatchQueue.main.async {
                        self.view.addSubview(self.errorLabel!)
                        self.errorLabel!.setConstraints(top: self.passwordContainerView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
                    }
                    return
            }
        })
    }
    /*/ handleCancel()
        handles pressing of the cancel button on the login page.
     */
    @objc func handleCancel(){
        navigationController?.popViewController(animated: false)
        self.delegate!.handleLoginButton()
    }
    /*/ handleMoveToSignUpButton()
     handles clicking the Sign Up button. Moves control over to the SignUpController.swift,
     assigns the delegate to this class, and pushes it into view.
     */
    @objc func handleMoveToSignUpButton(){
        let controller = SignUpController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - API
    
    /*/ logUserIn(withEmail email:String, password: String, completion: @escaping(Result<Bool, Error>) -> Void)
        Function logs a user in with provided email and password. It makes a call to the Firebase API to try and log the user in.
     
        @param: email - String - user's email
        @param: password - String - user's password
     */
    func logUserIn(withEmail email:String, password: String, completion: @escaping(Result<Bool, Error>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                completion(.success(true))
            }
        }
    }
    
    //MARK: - Helper functions
    
    /*/ configureViewComponents()
     Configures the view for the login controller.
     */
    func configureViewComponents(){
        view.backgroundColor = AppThemeColorConstants.white
        
        view.addSubview(logoImageView)
        logoImageView.setConstraints(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(formTitleView)
        formTitleView.setConstraints(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 48, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50
        )
        formTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(emailContainerView)
        emailContainerView.setConstraints(top: formTitleView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.setConstraints(top: emailContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(loginButton)
        loginButton.setConstraints(top: passwordContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(cancelButton)
        cancelButton.setConstraints(top: loginButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.setConstraints(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 32, paddingBottom: 12, paddingRight: 32, width: 0, height: 50)
    }
}
/*/ Extension - UITextFieldDelegate
 This extension allows the class to handle actions with the textFields.
 */
extension LoginController: UITextFieldDelegate{
    /*/ textFieldShouldReturn(_ textField: UITextField) -> Bool
     Implementation of function that ends editing when return is clicked while editing text
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
/*/ Extension - signUpControllerDelegate
 This extension allows the LoginController to handle the actions from the SignUpController
 */
extension LoginController: signUpControllerDelegate {
    /*/ handleSignUpButton(email: String, password: String)
     Handles the sign up button within the SignUpController. It will log a user in.
     */
    func handleSignUpButton(email: String, password: String){
        logUserIn(withEmail: email, password: password, completion: { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                self.alert(info: AlertConstants.randomError)
            }
        })
    }
    /*/ handleReloadOfProfile()
     function that handles the submission of a successful form from the FormController.swift when a user is signing up.
     Once the user confirms the correct information, there is a ghost press of the login button on the LoginController.Swift which passes responsibility to the ProfileController.swift
     */
    func handleReloadOfProfile() {
        self.delegate!.handleLoginButton()
    }
}
