//
//  UIViewController.swift
//  JavaKeywords
//
//  Created by Gabriel Conte on 28/02/20.
//  Copyright © 2020 Gabriel Conte. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, type: UIAlertController.Style = .alert, buttonMessage: String = "Ok", action: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: type)
        alertController.addAction(UIAlertAction(title: buttonMessage, style: .default, handler: {action in
            
        }))
        alertController.view.layoutIfNeeded()
        self.present(alertController, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
