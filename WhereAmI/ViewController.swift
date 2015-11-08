//
//  ViewController.swift
//  WhereAmI
//
//  Created by LAURA LUCRECIA SANCHEZ PADILLA on 22/10/15.
//  Copyright © 2015 LAURA LUCRECIA SANCHEZ PADILLA. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var previousPoint: CLLocation?
    private var totalMovementDistance: CLLocationDistance = 0
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var horizontalAccuracyLabel: UILabel!
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var verticalAccuracyLabel: UILabel!
    @IBOutlet var distanceTraveledLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status{
        case .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        case .AuthorizedAlways:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        default:
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let errorType = error.code == CLError.Denied.rawValue ? "Access Denied" : "Error \(error.code)"
        let alertController = UIAlertController(title: "Location Manager Error", message: errorType, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "K", style: .Cancel, handler: { action in})
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last

        let latitudeString = String(format: "%g\u{00B0}", (newLocation?.coordinate.latitude)!)
        latitudeLabel.text = latitudeString
        
        let longitudeString = String(format: "%g\u{00B0}", (newLocation?.coordinate.longitude)!)
        longitudeLabel.text = longitudeString
        
        let horizontalAccuracy = String(format: "%gm", (newLocation?.horizontalAccuracy)!)
        horizontalAccuracyLabel.text = horizontalAccuracy
        
        let altitudeString = String(format: "%gm", (newLocation?.altitude)!)
        altitudeLabel.text = altitudeString
        
        let verticalAccuracyString = String(format: "%gm", (newLocation?.verticalAccuracy)!)
        verticalAccuracyLabel.text = verticalAccuracyString
        
        if newLocation?.horizontalAccuracy < 0{
            //Invalid accuracy
            return
        }
        
        if newLocation?.horizontalAccuracy > 100 || newLocation?.verticalAccuracy > 50{
            //accuracy radius is so large, we don't want to use it
            return
        }
        
        if previousPoint == nil{
            totalMovementDistance = 0
            let start = Place(title: "Start Point", subtitle: "This is where we start", coordinate: (newLocation?.coordinate)!)
            mapView.addAnnotation(start)
            let region = MKCoordinateRegionMakeWithDistance((newLocation?.coordinate)!, 100, 100)
            mapView.setRegion(region, animated: true)
            
        } else{
            print("movement distance: \(newLocation?.distanceFromLocation(previousPoint!))")
            totalMovementDistance += (newLocation?.distanceFromLocation(previousPoint!))!
        }

    }

}

