//
//  AddressViewController.swift
//  DoorDash
//
//  Created by Saurabh Anand on 7/28/18.
//  Copyright © 2018 Saurabh Anand. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddressViewController: UIViewController {

    @IBOutlet weak var mapKitOutlet: MKMapView!
    
    @IBOutlet weak var addressLabelOutlet: UILabel!
    
    @IBOutlet weak var confirmAddress: UIButton!
    
    //setting up the lazy property to call when in use
    lazy var viewModel: DoorDashViewModel = {
        return DoorDashViewModel()
    }()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapKitOutlet.delegate = self
        mapKitOutlet.showsUserLocation = true
        mapKitOutlet.setUserTrackingMode(.follow, animated: true)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        confirmAddress.isEnabled = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDoorDashList" {
            let destinationVC = segue.destination as! DoorDashTabBarController
            destinationVC.viewModel = viewModel
        }
    }
    
    // MARK: - IBAction handling
    /***************************************************************/
    
    /// This function is called when Confirm Address button is pressed
    ///
    ///
    /// Usage:
    ///
    ///     Setting the latitude and longitude in the viewModel and perform segue to Explore tab
    
    @IBAction func confirmAddressPressed(_ sender: UIButton) {
        viewModel.latitude = mapKitOutlet.centerCoordinate.latitude
        viewModel.longitude = mapKitOutlet.centerCoordinate.longitude
        
        performSegue(withIdentifier: "goToDoorDashList", sender: self)
    }
    
    // MARK: - Error Handling
    /***************************************************************/

    func showAlert(errorMsg: String) {
        let alert = UIAlertController(title: "Alert", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Display Address
    /***************************************************************/
    
    /// This function displays the address when Pin is dropped in the Map view
    ///
    ///
    /// Usage:
    ///
    ///     Convert location from coordinates.
    ///     reverseGeocodeLocation from latitude and longitude, placemarks are returned with the name property.
    ///     Name property is being used to addressLabelOutlet text.
    ///
    /// - Parameter coordinate: Coordinate is passed from delegate methods of map view when Pin is dropped
    
    func displayAddress(coordinate : CLLocationCoordinate2D){

        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, err) in
            if (err != nil) {
                print("Reverse geocoder failed with error" + (err?.localizedDescription)!)
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0] as CLPlacemark
                DispatchQueue.main.async {
                    self.addressLabelOutlet.text = pm.name ?? ""
                    self.confirmAddress.isEnabled = true
                }
            } else {
                print("Problem with the data received from geocoder")
            }
        }
    }
    
    // MARK: - Update PIN Location
    /***************************************************************/
    
    /// This function updates Pin location and create annotation in the map.
    ///
    ///
    /// Usage:
    ///
    ///     Convert region from coordinates.
    ///     map view region is set
    ///     Create new instance of annotation and add to the map view
    ///
    /// - Parameter coordinate: Coordinate is passed from delegate methods of map view when Pin is dropped

    func updatePinLocation(coordinate : CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        mapKitOutlet.setRegion(region, animated: true)
        
        // Add new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapKitOutlet.addAnnotation(annotation)
        
        //call display address to show street name
        displayAddress(coordinate: coordinate)
    }
    
}


//MARK: - Map View Delegate methods
/***************************************************************/

extension AddressViewController: MKMapViewDelegate,CLLocationManagerDelegate {

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        locationManager.stopUpdatingLocation()
        updatePinLocation(coordinate: userLocation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        showAlert(errorMsg: error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView : MKPinAnnotationView?
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.isDraggable = true
            annotationView?.tintColor = UIColor.red
            annotationView?.animatesDrop = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch newState {
            case .starting:
                view.dragState = .dragging
            case .ending, .canceling:
                view.dragState = .none
            default: break
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Remove all annotations
        mapKitOutlet.removeAnnotations(mapView.annotations)
        // Call update pin location
        updatePinLocation(coordinate: mapView.region.center)
    }
}

