//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Adrià Sala Roget on 30/04/2020.
//  Copyright © 2020 Adrià Sala Roget. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func tapLogin(_ sender: Any) {
        activityIndicator.startAnimating()
        usernameField.isEnabled = false
        passwordField.isEnabled = false
        loginButton.isEnabled = false
        User.authenticationRequest(username: usernameField.text ?? "", password: passwordField.text ?? "", completionHandler: handleLogin(result:error:))
    }
    
    func handleLogin(result: Bool, error: Error?) {
//        print(error ?? "no error")
        
        
        if result {
            Students.getLocationsRequest(completion: {success in
                if success {
                    DispatchQueue.main.async {
                        let tabVC = self.storyboard!.instantiateViewController(identifier: "TabBarController")
                        tabVC.modalPresentationStyle = .fullScreen
                        self.present(tabVC, animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                        self.usernameField.isEnabled = true
                        self.passwordField.isEnabled = true
                        self.loginButton.isEnabled = true
    //                    self.usernameField.text = ""
                        self.passwordField.text = ""
                    }
                } else {
                    let alertVC = UIAlertController(title: "Retreive Failed", message: "Failed to retreive the users' locations.", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertVC, animated: true, completion: nil)
                }
            })
            
//            print(Authentication.authData!)
        } else {
            if let error = error as NSError? {
                if error.code == 4865 {
//                    print("ERROR IS: ----\(error.code)----")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
        //                self.usernameField.text = ""
                        self.passwordField.text = ""
                        self.usernameField.isEnabled = true
                        self.passwordField.isEnabled = true
                        self.loginButton.isEnabled = true
                        let alertVC = UIAlertController(title: "Failed Login", message: "The username or password are incorrect.", preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVC, animated: true, completion: nil)
                    }
                } else {
//                    print("ERROR IS: ----\(error.code)----")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
        //                self.usernameField.text = ""
//                        self.passwordField.text = ""
                        self.usernameField.isEnabled = true
                        self.passwordField.isEnabled = true
                        self.loginButton.isEnabled = true
                        let alertVC = UIAlertController(title: "Network Error", message: "An error ocurred with the network connection.", preferredStyle: .alert)
                        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alertVC, animated: true, completion: nil)
                    }
                }
                
            }
//            print(error ?? "error is nil")
            
        }
    }
    
    @IBAction func signinButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com")!, options: [:], completionHandler: nil)
    }
    
    
    
    
}



