//  ARIndoorNav
//
//  ProfileContainer.swift
//  class - ProfileView
//  Extensions - UITextFieldDelegate
//  
//  Created by Bryan Ung on 12/23/20.
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  This file serves as the profileView containner within ProfileController.swift

import Foundation
import UIKit
import Firebase
class ProfileView: UIView {
    
    //MARK: - Properties
    
    //var mainView: UIView?
    var firstName: String?
    var lastName: String?
    var birthday: String?
    var phoneNumber: String?
    var userName: String?
    var email: String?
    lazy var profileLabelView: UILabel = {
        let label = UILabel.getProfileCircle(initial: String(firstName!.prefix(1)), height: 120, width: 120)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppThemeColorConstants.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppThemeColorConstants.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var firstNameView = UIView()
    var firstNameTextField = UITextField()
    var lastNameView = UIView()
    var lastNameTextField = UITextField()
    var birthdayView = UIView()
    var birthdayTextField = UITextField()
    var phoneNumberView = UIView()
    var phoneNumberTextField = UITextField()
    var userNameView = UIView()
    var userNameTextField = UITextField()
    var emailView = UIView()
    var emailTextField = UITextField()
    
    //MARK: - Init
    
    /*/ init(frame: CGRect)
     initWithFrame to init view
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.mainView = mainView
        setupView()
    }
    /*/ init?(coder aDecoder: NSCoder)
     initWithCode to init view from xib or storyboard
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    /*/ setupView()
     Sets up the view.
     Checks user auth and populates container
     */
    private func setupView() {
        self.retrieveUserData() { boo in
            switch boo {
            case true:
                self.configureProfileCircle()
                self.configureView()
            case false:
                DataModel.dataModelSharedInstance.getMainVC().alert(info: "Error... User was not found.")
                DataModel.dataModelSharedInstance.getMainVC().dismiss(animated: true)
            }
        }
    }
    
    //MARK: - Helper Functions
    
    /*/ retrieveUserData(completion: @escaping(Bool) -> Void)
     Retrieves user data for the view
     */
    func retrieveUserData(completion: @escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            if (!snapshot.exists()) {
                completion(false)
            }
            self.firstName = snapshot.childSnapshot(forPath: DBKeyValues.firstName).value as? String
            self.lastName = snapshot.childSnapshot(forPath: DBKeyValues.lastName).value as? String
            self.birthday = snapshot.childSnapshot(forPath: DBKeyValues.birthday).value as? String
            self.phoneNumber = snapshot.childSnapshot(forPath: DBKeyValues.phoneNumber).value as? String
            self.userName = snapshot.childSnapshot(forPath: DBKeyValues.userName).value as? String
            self.email = snapshot.childSnapshot(forPath: DBKeyValues.email).value as? String
            completion(true)
        }
    }
    /*/ configureView()
     Configures the view and styles it
     */
    func configureView(){
        self.backgroundColor = AppThemeColorConstants.white
        addSubview(topContainerView)
        topContainerView.setConstraints(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 110)
        
        addSubview(bottomContainerView)
        bottomContainerView.setConstraints(top: topContainerView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addBottomViewTextFields()
        
        addSubview(profileLabelView)
        profileLabelView.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor).isActive = true
        profileLabelView.centerYAnchor.constraint(equalTo: topContainerView.bottomAnchor).isActive = true
        
    }
    /*/ addBottomViewTextFields()
     Function to add the appropriate text labels
     */
    func addBottomViewTextFields(){
        let height: CGFloat = 25
        let viewWidth: CGFloat = self.bounds.width
        let width: CGFloat = (viewWidth / 2) * (6/8)
        let padding: CGFloat = (viewWidth / 2) * (1/8)
        let fontSize: CGFloat = 20
        
        bottomContainerView.addSubview(firstNameView)
        configureInfoTextBox(view: firstNameView, tf: firstNameTextField, width: width, height: height, tintColor: UIColor.gray, text: "First Name", textColor: UIColor.gray)
        configureProfileViewTextField(tf: firstNameTextField, backgroundColor: AppThemeColorConstants.white, textColor: AppThemeColorConstants.blue, allowEditing: false, text: firstName!, fontSize: fontSize)
        firstNameView.setConstraints(top: bottomContainerView.topAnchor, left: bottomContainerView.leftAnchor, bottom: nil, right: nil, paddingTop: padding * 4, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: width, height: height)
        
        bottomContainerView.addSubview(lastNameView)
        configureInfoTextBox(view: lastNameView, tf: lastNameTextField, width: width, height: height, tintColor: UIColor.gray, text: "Last Name", textColor: UIColor.gray)
        configureProfileViewTextField(tf: lastNameTextField, backgroundColor: AppThemeColorConstants.white, textColor: AppThemeColorConstants.blue, allowEditing: false, text: lastName!, fontSize: fontSize)
        lastNameView.setConstraints(top: bottomContainerView.topAnchor, left: nil, bottom: nil, right: bottomContainerView.rightAnchor, paddingTop: padding * 4, paddingLeft: 0, paddingBottom: 0, paddingRight: padding, width: width, height: height)
        
        bottomContainerView.addSubview(userNameView)
        configureInfoTextBox(view: userNameView, tf: userNameTextField, width: width, height: height, tintColor: UIColor.gray, text: "Username", textColor: UIColor.gray)
        configureProfileViewTextField(tf: userNameTextField, backgroundColor: AppThemeColorConstants.white, textColor: AppThemeColorConstants.blue, allowEditing: false, text: userName!, fontSize: fontSize)
        userNameView.setConstraints(top: firstNameView.bottomAnchor, left: bottomContainerView.leftAnchor, bottom: nil, right: nil, paddingTop: padding * 4, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: width, height: height)
        
        bottomContainerView.addSubview(emailView)
        configureInfoTextBox(view: emailView, tf: emailTextField, width: width, height: height, tintColor: UIColor.gray, text: "Email", textColor: UIColor.gray)
        configureProfileViewTextField(tf: emailTextField, backgroundColor: AppThemeColorConstants.white, textColor: AppThemeColorConstants.blue, allowEditing: false, text: email!, fontSize: fontSize * (3/4))
        emailView.setConstraints(top: lastNameView.bottomAnchor, left: nil, bottom: nil, right: bottomContainerView.rightAnchor, paddingTop: padding * 4, paddingLeft: 0, paddingBottom: 0, paddingRight: padding, width: width, height: height)
        
        bottomContainerView.addSubview(phoneNumberView)
        configureInfoTextBox(view: phoneNumberView, tf: phoneNumberTextField, width: width, height: height, tintColor: UIColor.gray, text: "Phone Number", textColor: UIColor.gray)
        configureProfileViewTextField(tf: phoneNumberTextField, backgroundColor: AppThemeColorConstants.white, textColor: AppThemeColorConstants.blue, allowEditing: false, text: phoneNumber!, fontSize: fontSize)
        phoneNumberView.setConstraints(top: userNameView.bottomAnchor, left: bottomContainerView.leftAnchor, bottom: nil, right: nil, paddingTop: padding * 4, paddingLeft: padding, paddingBottom: 0, paddingRight: 0, width: width, height: height)

        bottomContainerView.addSubview(birthdayView)
        configureInfoTextBox(view: birthdayView, tf: birthdayTextField, width: width, height: height, tintColor: UIColor.gray, text: "Birthday", textColor: UIColor.gray)
        configureProfileViewTextField(tf: birthdayTextField, backgroundColor: AppThemeColorConstants.white, textColor: AppThemeColorConstants.blue, allowEditing: false, text: birthday!, fontSize: fontSize)
        birthdayView.setConstraints(top: emailView.bottomAnchor, left: nil, bottom: nil, right: bottomContainerView.rightAnchor, paddingTop: padding * 4, paddingLeft: 0, paddingBottom: 0, paddingRight: padding, width: width, height: height)
    }
    /*/ configureProfileViewTextField(tf: UITextField, backgroundColor: UIColor,textColor: UIColor, allowEditing: Bool, text: String, fontSize: CGFloat)
     Configures a generic UItextField which is standard in the container.
     
     @param: tf - UITextField - the textField to apply the style to
     @param: backgroundColor - UIColor - The color of the textField
     @param: textColor - UIColor - the color of the text
     @param: allowEditing - Bool - boolean value to determine if editing is allowed
     @param: text - String - the text within the textField
     @param: fontSize - CGFloat - the fontSize of the text
     */
    func configureProfileViewTextField(tf: UITextField, backgroundColor: UIColor,textColor: UIColor, allowEditing: Bool, text: String, fontSize: CGFloat){
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = backgroundColor
        tf.textColor = textColor
        tf.isUserInteractionEnabled = allowEditing
        tf.text = text
        tf.font = UIFont.systemFont(ofSize: fontSize)
        tf.textAlignment = .center
    }
    /*/ configureProfileCircle()
     Configures a circle to be displayed for the user's photo
     */
    func configureProfileCircle(){
        self.profileLabelView = {
            let label = UILabel.getProfileCircle(initial: String(firstName!.prefix(1)), height: 120, width: 120)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    }
    /*/ configureInfoTextBox(view: UIView, tf: UITextField, width: CGFloat, height: CGFloat, tintColor: UIColor, text: String, textColor: UIColor)
     Configures an UIView to be displayed with the appropriate Label
     
     */
    func configureInfoTextBox(view: UIView, tf: UITextField, width: CGFloat, height: CGFloat, tintColor: UIColor, text: String, textColor: UIColor) {
        view.addSubview(tf)
        tf.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tf.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tf.widthAnchor.constraint(equalToConstant: width).isActive = true
        tf.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        
        let separatorView = UIView()
        view.addSubview(separatorView)
        separatorView.backgroundColor = tintColor
        separatorView.setConstraints(top: tf.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: width, height: 0.75)
        separatorView.centerXAnchor.constraint(equalTo: tf.centerXAnchor).isActive = true
        
        let label = UILabel()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = AppThemeColorConstants.white
        label.setConstraints(top: separatorView.topAnchor, left: separatorView.leftAnchor, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: width, height: 0)
        label.text = text
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
    }
}
/*/ Extension - UITextFieldDelegate
 This extension allows the controller to handle the responsibility of the TextFields.
 */
extension ProfileView: UITextFieldDelegate{
    /*/ textFieldShouldReturn(_ textField: UITextField) -> Bool
     Implemented function that ends editing anytime the textfield retrieves a return input
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
