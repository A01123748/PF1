//
//  ViewController.swift
//  MapKit
//
//  Created by Eliseo Fuentes on 9/14/16.
//  Copyright © 2016 Eliseo Fuentes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomPointAnnotation: MKPointAnnotation {
    var photo = UIImageView()
}

class MapsVC: UIViewController, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var mapa: MKMapView!
    private let manejador = CLLocationManager()
    var annotation = CustomPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
        let uilgr = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(_:)))
        uilgr.minimumPressDuration = 1.0
        mapa.addGestureRecognizer(uilgr)
        mapa.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
            if(manager.location != nil){
                let span = MKCoordinateSpanMake(0.015, 0.015)
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!), span: span)
                mapa.setRegion(region, animated: true)
            }
        }
        else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    /*func insertPin( latitude: CLLocationDegrees, longitude: CLLocationDegrees,isUpdate:Bool, measuredDistance:Double){
       
        currentLocation = CLLocation.init(latitude: latitude, longitude: longitude)
        let pin = MKPointAnnotation()
        pin.coordinate.latitude = latitude
        pin.coordinate.longitude = longitude
        let latP = String(format: "%.3f", latitude)
        let longP = String(format: "%.3f", longitude)
        
        pin.title = "Long: \(longP)º, Lat: \(latP)º"
        if(isUpdate){
            distance+=measuredDistance
        }
        let distanceP = String(format: "%.3f", distance)
        pin.subtitle = "Ditancia recorrida: \(distanceP)m"
        mapa.addAnnotation(pin)
    }*/
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(mapa)
            let newCoordinates = mapa.convertPoint(touchPoint, toCoordinateFromView: mapa)
            annotation = CustomPointAnnotation()
            annotation.coordinate = newCoordinates
            
            self.performSegueWithIdentifier("details", sender: self)
        }
    }
    
    
    func mapView(mapView: MKMapView,
                 viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.detailCalloutAccessoryView = self.annotation.photo
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is PINDetailsVC{
            let dest = segue.destinationViewController as! PINDetailsVC
            dest.sourceViewController = self
            dest.customPin = annotation
        }
    }
    
    func obtenerRuta(origen:MKMapItem, destino:MKMapItem){
        let solicitud = MKDirectionsRequest()
        solicitud.source = origen
        solicitud.destination = destino
        solicitud.transportType = .Walking
        let indicaciones = MKDirections(request:solicitud)
        indicaciones.calculateDirectionsWithCompletionHandler({
            (response:MKDirectionsResponse?, error:NSError?) in
            if error != nil{
                print(error)
            }
            else{
                self.muestraRuta(response!)
            }
        })
    }
    func muestraRuta(resp:MKDirectionsResponse){
        for ruta in resp.routes{
            mapa.addOverlay(ruta.polyline,level: MKOverlayLevel.AboveRoads)
            for paso in ruta.steps{
                print(paso.instructions)
            }
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        return renderer
    }
}

