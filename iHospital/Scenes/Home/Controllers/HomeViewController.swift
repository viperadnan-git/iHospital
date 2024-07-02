//
//  HomeViewController.swift
//  iHospital
//
//  Created by Adnan Ahmad on 02/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBAction func onLogOut(_ sender: Any) {
        Task {
            do {
                try await User.logOut()
                self.view.window?.showViewController("AuthViewController")
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
