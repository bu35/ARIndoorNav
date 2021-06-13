//  ARIndoorNav
//
//  Extensions.swift
//  Extensions - UIView, UITextField, UIViewController, String, Label
//
//  Created by Allie Do on 8/3/20.
//  Modifed by Bryan Ung
//  Copyright © 2021 Bryan Ung. All rights reserved.
//
//  Generalized Class for extensions related to components used in many classes

import UIKit

/*/ Extension - UIView
 Extension of UIView. Provided features include constraint setting, custom UIView/UILabel creation
 */
extension UIView {
    /*/ setConstraints(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat)
     
     This is used to programatically set the constraints of any UIView given they provide the following parameters.
     
     @param: top: NSLayoutYAxisAnchor - UIView binding top anchor
     @param: left: NSLayoutXAxisAnchor - UIView binding left anchor
     @param: bottom: NSLayoutYAxisAnchor - UIView binding right anchor
     @param: right: NSLayoutXAxisAnchor - UIView binding bottom anchor
     @param: paddingTop - CGFloat - top padding
     @param: paddingLeft - CGFloat - left padding
     @param: paddingBottom - CGFloat - bottom padding
     @param: paddingRight - CGFloat - right padding
     @param: width - CGFloat - width of UIView
     @param: height - CGFloat - height of UIView
     */
    func setConstraints(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat,
        width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    /*/ firstLastNameView(view: UIView, _ image: UIImage, _ textField1: UITextField, _ textField2: UITextField, tintColor: UIColor, width: CGFloat) -> UIView
     
     This  is used to create a UIView consiting of two textfields for the purpose of creating a neat looking first & last name view.
     
     @param: view - UIView - the view to be modified and returned
     @param: image - UIImage - image put next to the textfields
     @param: textField1 - UITextField - first textField
     @param: textField2 - UITextField - second textField
     @param: tingColor - UIColor - tint color of the UIImage, and separatorViews
     @param: width - CGFloat - width of the the Parent UIView
     */
    func firstLastNameView(view: UIView, _ image: UIImage, _ textField1: UITextField, _ textField2: UITextField, tintColor: UIColor, width: CGFloat) -> UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        let constantWidth = width/2-56
        
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.tintColor = tintColor
        view.addSubview(imageView)
        imageView.setConstraints(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 28, height: 28)
        
        view.addSubview(textField1)
        textField1.setConstraints(top: nil, left: imageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: constantWidth, height: 0)
        textField1.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let separatorView1 = UIView()
        view.addSubview(separatorView1)
        separatorView1.backgroundColor = tintColor
        separatorView1.setConstraints(top: textField1.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 6, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: constantWidth, height: 0.75)
        separatorView1.centerXAnchor.constraint(equalTo: textField1.centerXAnchor).isActive = true
        
        view.addSubview(textField2)
        textField2.setConstraints(top: nil, left: textField1.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 8, width: constantWidth, height: 0)
        textField2.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let separatorView2 = UIView()
        view.addSubview(separatorView2)
        separatorView2.backgroundColor = tintColor
        separatorView2.setConstraints(top: textField2.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 6, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: constantWidth, height: 0.75)
        separatorView2.centerXAnchor.constraint(equalTo: textField2.centerXAnchor).isActive = true
        return view
    }
    /*/ textContainerView(view: UIView, _ image: UIImage, _ textField: UITextField, tintColor: UIColor, addMiniText: Bool, miniText: String?, miniTextTintColor: UIColor?) -> UIView
     
     This  is used to create a UIView consiting of a textfield, image, and option to have mini text underneath textfield
     
     @param: view - UIView - the view to be modified and returned
     @param: image - UIImage - image put next to the textfield
     @param: textField - UITextField - textField to be added
     @param: tingColor - UIColor - tint color of the UIImage, and separator view
     @param: addMiniText - Bool - boolean value determining if the UIView needs minitext
     @param: miniTextTintColor - UIColor - optional value of tint color for miniText
     */
    func textContainerView(view: UIView, _ image: UIImage, _ textField: UITextField, tintColor: UIColor, addMiniText: Bool, miniText: String?, miniTextTintColor: UIColor?) -> UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = image
        imageView.tintColor = tintColor
        view.addSubview(imageView)
        imageView.setConstraints(top: nil, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 28, height: 28)
        imageView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        view.addSubview(textField)
        textField.setConstraints(top: nil, left: imageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        let separatorView = UIView()
        separatorView.backgroundColor = tintColor
        view.addSubview(separatorView)
        if (!addMiniText) {
            separatorView.setConstraints(top: textField.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 6, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.75)
        } else {
            separatorView.setConstraints(top: textField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 6, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.75)
            
            let miniTextLabel = UILabel()
            view.addSubview(miniTextLabel)
                
            miniTextLabel.backgroundColor = .clear
            miniTextLabel.text = miniText
            miniTextLabel.textColor = miniTextTintColor?.withAlphaComponent(0.75)
            miniTextLabel.font = UIFont.systemFont(ofSize: 10)
            
            miniTextLabel.setConstraints(top: separatorView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 2, paddingLeft: 50, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        }
        
        return view
    }
    /*/ errorLabel (text: String) -> UILabel
     This creates an error UILabel with the given text provided.
    
     @param: text - String - the text of the label.
     */
    func errorLabel (text: String) -> UILabel{
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = AppThemeColorConstants.red
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = text
        return label
    }
}

/*/ Extension - UITextField
 Extension of UITextField. Provides ability to create a custom textfield.
 */
extension UITextField {
    /*/textField(withPlaceholder placeholder:String, isSecureTextEntry: Bool, tintColor: UIColor) -> UITextField
     
     Creates a TextField with placeHolder text, ability to determine secureEntry, and tintColor
     TextField for the Login/Sign-Up Pages
     
     @param: placeholder - String - placeholder Text for the textfield
     @param: isSecureTextEntry - Bool - secure Entry flag
     @param: tintColor - UIColor - color of the text.
    */
    func textField(withPlaceholder placeholder:String, isSecureTextEntry: Bool, tintColor: UIColor) -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = tintColor
        tf.isSecureTextEntry = isSecureTextEntry
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: tintColor])
        return tf
    }
}
/*/ Extension - UIViewController
 Extension of UIViewController. Provides ability to escape textField input mode, present alert controllers, and retrieve a loading indicator, 
 */
extension UIViewController {
    /*
     If hideKeyboardWhenTappedAround() is called, anywhere on the screen tapped when keyboard is showing
     will remove the keyboard from view.
    */
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    /*
     Alert to be generated on current screen
    */
    func alert(info: String) {
        let alert = UIAlertController(title: "Alert", message: info, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /*
     Returns an Alert Controller embedded within a UIActivityIndictorView
    */
    static func getLoadingIndicator() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        return alert
    }
}
/*/ Extension - String
 Extension of String. Provides ability to apply patterns on numbers
 */
extension String {
    /*/applyPatternOnNumbers(pattern: String, replacmentCharacter: Character, maxNum: Int) -> String
     
     @param: pattern - String - takes in a pattern to be applied
     @param: replacementCharacter - Character - the character to be replaced in the pattern
     @param: maxNum - Int - max # of characters allowed
     
     @return String - the formatted string
     */
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character, maxNum: Int) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return String(pureNumber.prefix(maxNum)) }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return String(pureNumber.prefix(maxNum))
    }
    /*/capitalizingFirstLetter() -> String
     returns the String back capitalizing the first letter
     */
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
/*/ Extension - String
 Extension of UILabel. Provides function to return a circle label which is used in the profileController.
 */
extension UILabel {
    /*/static func getProfileCircle(initial: String, height: CGFloat, width: CGFloat) -> UILabel
     Returns a profile circle UILabel
     
     @param: initial - String - the user's initials
     @param: height - CGFloat - the height of the UILabel
     @param: width - CGFloat - the width of the UILabel
     
     @return - UILabel - Profile Circle UILabel
     */
    static func getProfileCircle(initial: String, height: CGFloat, width: CGFloat) -> UILabel{
        let iv = UILabel()
        
        iv.clipsToBounds = true
        iv.textColor = AppThemeColorConstants.white
        iv.font = UIFont.systemFont(ofSize: 48)
        iv.textAlignment = .center
        iv.text = initial
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = AppThemeColorConstants.gray
        iv.heightAnchor.constraint(equalToConstant: height).isActive = true
        iv.widthAnchor.constraint(equalToConstant: width).isActive = true
        iv.layer.cornerRadius = width/2
        
        return iv
    }
}
