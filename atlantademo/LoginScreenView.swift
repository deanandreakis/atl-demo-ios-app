//
//  LoginScreenView.swift
//  atlantademo
//
//  Created by Dean Andreakis on 11/5/17.
//  Copyright © 2017 gisi. All rights reserved.
//

import Foundation
import UIKit

class LoginScreenView: UIView, UITextFieldDelegate {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonSelected(_ sender: Any) {
        delegate?.loginButtonSelected(username: userNameTextField.text)
    }
    
    weak var delegate: LoginScreenViewDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

protocol LoginScreenViewDelegate: class {
    func loginButtonSelected(username: String?)
}

extension UITextField {
    func loadDropdownData(data: [String]) {
        self.inputView = LoginPickerView(pickerData: data, dropdownField: self)
    }
}
