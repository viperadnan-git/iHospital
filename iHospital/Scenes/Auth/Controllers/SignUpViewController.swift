//
//  SignUpViewController.swift
//  iHospital
//
//  Created by Adnan Ahmad on 01/07/24.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var dateOfBirthPicker: UIDatePicker!
    @IBOutlet var signUpButton: LoaderButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        dateOfBirthPicker.maximumDate = Date()
        dateOfBirthPicker.minimumDate = Calendar.current.date(byAdding: .year, value: -150, to: Date())
        
        dateOfBirthPicker.date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        nameTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            onSignUp(signUpButton)
        default:
            break
        }
        
        return true
    }
    
    @IBAction func onSignUp(_ sender: LoaderButton) {
        sender.isLoading = true
        
        guard let name = nameTextField.text, !name.isEmpty else {
            UIAlertController.showAlert(title: "Name Invalid", message: "Please enter a valid name", from: self)
            sender.isLoading = false
            return
        }
        
        guard let email = emailTextField.text, email.isValidEmail else {
            UIAlertController.showAlert(title: "Email Invalid", message: "Please enter a valid email", from: self)
            sender.isLoading = false
            return
        }
        
        guard let password = passwordTextField.text, password.count >= 6 else {
            UIAlertController.showAlert(title: "Password Invalid", message: "Password must be at least 6 characters long", from: self)
            sender.isLoading = false
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, confirmPassword == password else {
            UIAlertController.showAlert(title: "Password Mismatch", message: "Passwords do not match", from: self)
            sender.isLoading = false
            return
        }
        
        Task {
            defer {
                sender.isLoading = false
            }
            
            do {
                let user = User(id: UUID(), name: name, email: email, dateOfBirth: dateOfBirthPicker.date, gender: .male, phoneNumber: 3878438, role: .user)
                try await User.signUp(email: user.email, password: password)
               
                performSegue(withIdentifier: "AskOTPSegue", sender: user)
                sender.isLoading = false
            } catch {
                handleSupabaseError(error: error, controller: self)
            }
        }
    }

    @IBSegueAction func onAskOTP(_ coder: NSCoder, sender: Any?) -> AskOTPViewController? {
        guard let user = sender as? User else {
            return nil
        }

        return AskOTPViewController(coder: coder, user: user)
    }
}
