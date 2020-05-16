//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Adrià Sala Roget on 03/05/2020.
//  Copyright © 2020 Adrià Sala Roget. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func findButtonTapped(_ sender: Any) {
        if let location = textField.text {
            activityIndicator.startAnimating()
            searchLocation(location: location, completion: { success in
                self.activityIndicator.stopAnimating()
                if success {
                    let urlVC = self.storyboard?.instantiateViewController(withIdentifier: "postAddress") as! PostURLViewController
                    self.present(urlVC, animated: true, completion: nil)
                } else {
                    let alertVC = UIAlertController(title: "Geocode Failed", message: "The app failed to geocode your position.", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertVC, animated: true, completion: nil)
                }
                
//                print(User.userLocation ?? "no user location")
            })
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchLocation(location: String, completion: ((Bool) -> Void)? = nil) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = location
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start {response, error in
            guard let response = response else {
//                print(error ?? "Unknown error")
                
                completion?(false)
                return
            }
            
            User.userLocation = response.mapItems[0].placemark.coordinate
            if User.userLocation != nil { completion?(true) }
        }
    }
}
