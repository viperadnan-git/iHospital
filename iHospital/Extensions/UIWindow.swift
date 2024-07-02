//
//  UIWindowScene.swift
//  iHospital
//
//  Created by Adnan Ahmad on 01/07/24.
//

import UIKit


let StoryboardMap = [
    "MainViewController": "Main",
    "AuthViewController": "Auth"
]

extension UIWindow {
    func showViewController(_ viewController: UIViewController) {
        self.rootViewController = viewController
        self.makeKeyAndVisible()
    }
    
    func showViewController(_ viewController: UIViewController, animated: Bool) {
        self.showViewController(viewController)
        if animated {
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
    func showViewController(_ viewController: String) {
        let storyboard = UIStoryboard(name: StoryboardMap[viewController]!, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewController)
        self.showViewController(vc)
    }
}
