//
//  ViewController.swift
//  VirtualTourist
//
//  Created by aziz on 08/06/2019.
//  Copyright © 2019 Aziz. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController!
    
    var pins: [Pin] = []
    var annotations = [MKPointAnnotation]()
    
    var pinToNextVC: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPins()
        
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
    
    func loadPins() {
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            pins = result
        }
        fillAnotationArray()
    }
    
    func fillAnotationArray(){
        
        for dictionary in pins {
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longtitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
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
        
        pinToNextVC = Pin(context: dataController.viewContext)
        pinToNextVC.latitude = (view.annotation?.coordinate.latitude)!
        pinToNextVC.longtitude = (view.annotation?.coordinate.longitude)!
        
        try? dataController.viewContext.save()
        performSegue(withIdentifier: "GoToPhotoAlbum", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToPhotoAlbum" {
            let PhotoVC = segue.destination as! PhotoAlbumViewController

            PhotoVC.pin = self.pinToNextVC
            PhotoVC.dataController = self.dataController
        }
    }
}

