//
//  AskOTPViewController.swift
//  iHospital
//
//  Created by Adnan Ahmad on 02/07/24.
//

import UIKit

class AskOTPViewController: UIViewController {
    @IBOutlet var otpTextField: UITextField!
    @IBOutlet var resendOTPButton: UIButton!
    
    let user:User
    
    init?(coder: NSCoder, user: User) {
        self.user = user
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resendOTPTimeout()
    }
    
    func resendOTPTimeout() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: {
            self.resendOTPButton.isEnabled = true
        })
    }
    
    @IBAction func onVerifyOTP(_ sender: LoaderButton) {
        guard let otp = otpTextField.text else {
            UIAlertController.showAlert(title: "OTP Invalid", message: "Please enter a valid OTP", from: self)
            print("invalidotp")
            return
        }
        sender.isLoading = true
        
        Task {
            defer {
                sender.isLoading = false
            }
            
            do {
                let user = try await User.verify(user: user, otp: otp)
                User.shared = user
                
                self.view.window?.showViewController("MainViewController")
            } catch {
                handleSupabaseError(error: error, controller: self)
            }
        }
    }
    
    @IBAction func onResendOTP(_ sender: UIButton) {
        Task {
            do {
                resendOTPButton.isEnabled = false
                try await User.sendOTP(email: user.email)
                resendOTPTimeout()
            } catch {
                resendOTPButton.isEnabled = true
                handleSupabaseError(error: error, controller: self)
            }
        }
    }
    
}
