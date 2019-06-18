//
//  ViewController.swift
//  VirtualTourist
//
//  Created by aziz on 08/06/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let press = UILongPressGestureRecognizer(target: self, action: #selector(press(tap:)))
        mapView.addGestureRecognizer(press)
    }
    
    @objc func press(tap: UIGestureRecognizer) {
        
        guard tap.state == .began else { return }
        
        let pin = tap.location(in: mapView)
        let coordinate = mapView.convert(pin, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()

        annotation.coordinate = coordinate

        mapView.addAnnotation(annotation)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        performSegue(withIdentifier: "GoToPhotoAlbum", sender: nil)
    }
}

