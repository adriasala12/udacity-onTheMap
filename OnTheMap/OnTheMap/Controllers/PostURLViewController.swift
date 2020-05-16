//
//  PostURLViewController.swift
//  OnTheMap
//
//  Created by Adrià Sala Roget on 04/05/2020.
//  Copyright © 2020 Adrià Sala Roget. All rights reserved.
//

import UIKit
import MapKit

class PostURLViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        mapView.setCenter(User.userLocation!, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = User.userLocation!
        mapView.addAnnotation(annotation)
        
        let latitude:CLLocationDegrees = User.userLocation!.latitude
        let longitude:CLLocationDegrees = User.userLocation!.longitude
        let latDelta:CLLocationDegrees = 0.05
        let lonDelta:CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegion(center: location, span: span)

        mapView.setRegion(region, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    @IBAction func postAddressButtonTapped(_ sender: Any) {
        User.userURL = textField.text
        User.postLocationRequest(completion: { success in
            if !success {
                let alertVC = UIAlertController(title: "Post Failed", message: "The app could not post the location of the user to the server.", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
        })
        self.presentingViewController?
        .presentingViewController?
        .dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
//        User.userLocation = nil
        self.presentingViewController?
            .presentingViewController?
            .dismiss(animated: true, completion: nil)
    }
    
    
    
}
