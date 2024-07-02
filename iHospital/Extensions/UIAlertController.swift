//
//  UIAlertController.swift
//  iHospital
//
//  Created by Adnan Ahmad on 02/07/24.
//

import UIKit


public extension UIAlertController {
    static func showAlert(title: String, message: String?, from viewController: UIViewController) {
        self.showAlert(alert: UIAlertController(title: title, message: message, preferredStyle: .alert), from: viewController)
    }
    
    static func showAlert(title: String, from viewController: UIViewController) {
        self.showAlert(alert: UIAlertController(title: title, message: nil, preferredStyle: .alert), from: viewController)
    }
    
    static func showAlert(alert: UIAlertController, from viewController: UIViewController) {
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        viewController.present(alert, animated: true)
    }
}
