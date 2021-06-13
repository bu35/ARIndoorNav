//  ARIndoorNav
//
//  FormController.swift
//  Class - FormController.swift
//  Extensions - UITextFieldDelegate
//
//  Created by Bryan Ung on 9/15/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This class represents the form controller of the app. It is presented when a user
//  is signing up.

import UIKit
import Firebase
class FormController: UIViewController{
    
    //MARK: - Properties
    var widthOfScreen: CGFloat?
    var errorLabel: UILabel?
    //Delegate = LoginController.swift
    var delegate: signUpControllerDelegate?
    //Logo on the top of the form controller view
    let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        logo.image = UIImage(systemName: "book.fill")
        logo.tintColor = AppThemeColorConstants.blue
        return logo
    }()
    //Label that indicates the title of the view
    let formTitleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "Personal Information"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = AppThemeColorConstants.blue
        return label
    }()
    //View housing the first and last name input boxes
    lazy var nameContainerView: UIView = {
        let view = UIView()
        let image = UIImage(systemName: "person.fill")
        return view.firstLastNameView(view: view, image!, firstNameTextField, lastNameTextField, tintColor: AppThemeColorConstants.blue, width: widthOfScreen!)
    }()
    //View housing the birthday input box
    lazy var birthdayContainerView: UIView = {
        let view = UIView()
        let image = UIImage(systemName: "calendar")
        return view.textContainerView(view: view, image!, birthdayTextField, tintColor: AppThemeColorConstants.blue, addMiniText: true, miniText: "MM/DD/YYYY", miniTextTintColor: AppThemeColorConstants.gray)
    }()
    //View housing the phone number input box
    lazy var phoneNumberContainerView: UIView = {
        var view = UIView()
        let image = UIImage(systemName: "phone.fill")
        return view.textContainerView(view: view, image!, phoneNumberTextField, tintColor: AppThemeColorConstants.blue, addMiniText: false, miniText: nil, miniTextTintColor: nil)
    }()
    lazy var firstNameTextField: UITextField = {
        var tf = UITextField()
        tf = tf.textField(withPlaceholder: "First Name", isSecureTextEntry: false, tintColor: AppThemeColorConstants.blue)
        tf.delegate = self
        return tf
    }()
    lazy var lastNameTextField: UITextField = {
        var tf = UITextField()
        tf = tf.textField(withPlaceholder: "Last Name", isSecureTextEntry: false, tintColor: AppThemeColorConstants.blue)
        tf.delegate = self
        return tf
    }()
    lazy var birthdayTextField: UITextField = {
        var tf = UITextField()
        tf = tf.textField(withPlaceholder: "Birthday", isSecureTextEntry: false, tintColor: AppThemeColorConstants.blue)
        tf.keyboardType = UIKeyboardType.numberPad
        tf.delegate = self
        
        return tf
    }()
    lazy var phoneNumberTextField: UITextField = {
        var tf = UITextField()
        tf = tf.textField(withPlaceholder: "Phone Number", isSecureTextEntry: false, tintColor: AppThemeColorConstants.blue)
        tf.keyboardType = UIKeyboardType.numberPad
        tf.delegate = self
        return tf
    }()
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CONFIRM", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(AppThemeColorConstants.white, for: .normal)
        button.backgroundColor = AppThemeColorConstants.blue
        button.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    //MARK: - Init
    /*/ viewDidLoad()
     Implementation of function that configures the view and calls the UIViewController class method extension (Utils/Extensions.swift) hideKeyboardWhenTappedAround().
     */
    override func viewDidLoad() {
        configureUI()
        hideKeyboardWhenTappedAround()
    }
    /*/ viewWillAppear(_ animated: Bool)
     Implementation of function that sets the navigation bar to hidden.
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Configuration
    
    /*/ configureUI()
     Configures the View UI; adding all the necessary componenets and setting constraints,
     */
    private func configureUI(){
        self.widthOfScreen = self.view.frame.size.width
        
        view.backgroundColor = AppThemeColorConstants.white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(logoImageView)
        logoImageView.setConstraints(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(formTitleView)
        formTitleView.setConstraints(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 28, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50
        )
        formTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(nameContainerView)
        nameContainerView.setConstraints(top: formTitleView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
        
        view.addSubview(birthdayContainerView)
        birthdayContainerView.setConstraints(top: nameContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
        
        view.addSubview(phoneNumberContainerView)
        phoneNumberContainerView.setConstraints(top: birthdayContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 28, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 50)
        
        view.addSubview(confirmButton)
        confirmButton.setConstraints(top: phoneNumberTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 50)
    }
    
    //MARK: - Handlers
    
    /*/ handleConfirm()
     handles the comfirm button being clicked
     Does valid input checking, if passes, then updates user data in firebase.
     */
    @objc func handleConfirm(){
        if errorLabel != nil {
            errorLabel!.removeFromSuperview()
        }
        let first = firstNameTextField.text
        let last = lastNameTextField.text
        let birthday = birthdayTextField.text
        let phone = phoneNumberTextField.text
        
        //Format birthday checking
        if birthday!.count > 0 && birthday?.count != 10{
            self.errorLabel = self.view.errorLabel(text: "Please Format Birthday Correctly.")
            DispatchQueue.main.async {
                self.view.addSubview(self.errorLabel!)
                self.errorLabel!.setConstraints(top: self.phoneNumberContainerView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
            }
            return
            //Format phone # checking
        } else if phone!.count > 0 && phone?.count != 14{
            self.errorLabel = self.view.errorLabel(text: "Please Format Phone Number Correctly.")
            DispatchQueue.main.async {
                self.view.addSubview(self.errorLabel!)
                self.errorLabel!.setConstraints(top: self.phoneNumberContainerView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 8, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 0)
            }
            return
            //Both Birthday and Phone # looks good
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {
                self.alert(info: AlertConstants.randomError);
                return
            }
            let values = ["first_name": first,  "last_name": last, "birthday": birthday, "phone": phone]
            Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.alert(info: AlertConstants.randomError)
                    }
                    return
                } else {
                    self.navigationController!.popToRootViewController(animated: true)
                    self.delegate!.handleReloadOfProfile()
                }
            })
        }
    }
}
/*/ Extension - UITextFieldDelegate
 This extension allows the class to handle actions with the textFields.
 */
extension FormController: UITextFieldDelegate{
    /*/  textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
     Implementation of function that modifies the text within a textfield depending on the type
     This is mainly for UI purposes.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameTextField || textField == lastNameTextField {
            guard let text = textField.text else { return true }
            //capitalizingFirstLetter is located in Extensions.String
            textField.text = text.capitalizingFirstLetter()
            return true
        }
        if textField == birthdayTextField {
            guard let text = textField.text else { return true }
            //applyPatternOnNumbers is located in Extensions.String
            let num = text.applyPatternOnNumbers (pattern: "##/##/####", replacementCharacter: "#", maxNum: 9)
            textField.text = num
            return true
        }
        if textField == phoneNumberTextField {
            guard let text = textField.text else { return true }
            let num = text.applyPatternOnNumbers (pattern: "(###) ###-####", replacementCharacter: "#", maxNum: 13)
            textField.text = num
            return true
        }
        return true
    }
    /*/ textFieldShouldReturn(_ textField: UITextField) -> Bool
     Implementation of function that ends editing when return is clicked while editing text
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
