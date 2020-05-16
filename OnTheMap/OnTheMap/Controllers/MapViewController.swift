//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Adrià Sala Roget on 03/05/2020.
//  Copyright © 2020 Adrià Sala Roget. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.removeAnnotations(mapView.annotations)
        loadAnnotations()
    }
    
    func loadAnnotations() {
        var annotations = [MKPointAnnotation]()
        
        for student in Students.results {
            let lat = CLLocationDegrees(student.latitude)
            let lon = CLLocationDegrees(student.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = student.firstName + " " + student.lastName
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
        }
        
        if let location = User.userLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = User.userData!.first_name + " " + User.userData!.last_name
            annotation.subtitle = User.userURL!
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
    
    @IBAction func postLocationTapped(_ sender: Any) {
        
        if User.userLocation != nil {
            let alertVC = UIAlertController(title: "A Location Already Exists", message: "If you post a location, you will override your current location.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Override", style: .default, handler: { alert in
                User.postLocationRequest()
                let postLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "postLocation")
                postLocationVC.modalPresentationStyle = .fullScreen
                self.present(postLocationVC, animated: true, completion: nil)
            }))
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {alert in return}))
            self.present(alertVC, animated: true, completion: nil)
        }
        
        User.postLocationRequest()
        
        let postLocationVC = self.storyboard!.instantiateViewController(withIdentifier: "postLocation")
        postLocationVC.modalPresentationStyle = .fullScreen
        present(postLocationVC, animated: true, completion: nil)

    }
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        Students.reload()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        User.deleteSessionRequest()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


