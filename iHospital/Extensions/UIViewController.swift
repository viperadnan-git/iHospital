//
//  UIViewController.swift
//  iHospital
//
//  Created by Adnan Ahmad on 01/07/24.
//

import UIKit


fileprivate var SpinnerView: [UIView: UIView] = [:]

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showSpinner(onView: UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        SpinnerView[onView] = spinnerView
    }
    
    func removeSpinner(onView: UIView) {
        DispatchQueue.main.async {
            if let spinnerView = SpinnerView[onView] {
                spinnerView.removeFromSuperview()
                SpinnerView.removeValue(forKey: onView)
            }
        }
    }
}
