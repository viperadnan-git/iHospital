//
//  LoginViewController.swift
//  iHospital
//
//  Created by Adnan Ahmad on 02/07/24.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButtonField: LoaderButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case emailTextField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField:
                onSignIn(loginButtonField)
            default:
                break
        }
        
        return true
    }
    
    @IBAction func onSignIn(_ sender: LoaderButton) {
        guard let email = emailTextField.text, email.isValidEmail else {
           UIAlertController.showAlert(title: "Invalid Email", message: "Please enter a valid email address", from: self)
            return
        }
        
        guard let password = passwordTextField.text, password.count >= 6 else {
            UIAlertController.showAlert(title: "Invalid Password", message: "Password must be at least 6 characters long", from: self)
            return
        }
        
        sender.isLoading = true
        
        Task {
            defer {
                sender.isLoading = false
            }
            
            do {
                if let user = try await User.login(email: email, password: password) {
                    User.shared = user
                    self.view.window?.showViewController("MainViewController")
                } else {
                    UIAlertController.showAlert(title: "Login Failed", message: "Invalid email or password", from: self)
                }
            } catch {
                handleSupabaseError(error: error, controller: self)
            }
        }
    }
}
