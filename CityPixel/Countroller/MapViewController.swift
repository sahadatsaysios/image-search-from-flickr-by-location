//
//  ViewController.swift
//  CityPixel
//
//  Created by Sahadat  Hossain on 28/11/18.
//  Copyright © 2018 Sahadat  Hossain. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadious : Double = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        // Call Location Manager Configure function
        configureLocationServices()
        // center on user location and zoom
        centerMapOnUserLocation()
        // dorp pin by double click
        addDoubleTap()
    }
    
    func addDoubleTap () {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
    }

    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
    
}

extension MapViewController : MKMapViewDelegate {
    
    func centerMapOnUserLocation () {
       
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadious * 2, longitudinalMeters: regionRadious * 2)
        
        mapView.setRegion(region, animated: true)
    }
    
    @objc func dropPin (sender : UIGestureRecognizer) {
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        print(touchCoordinate)
    }
}

extension MapViewController : CLLocationManagerDelegate {
    
    func configureLocationServices () {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else { return }
    }
}

