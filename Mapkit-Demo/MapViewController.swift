//
//  ViewController.swift
//  Mapkit-Demo
//
//  Created by Laxmikanth Reddy on 24/11/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    private var userTrackingButton: MKUserTrackingButton!
    
    private let locationSession = CoreLocationSession()
    
    private var isShowingNewAnnotations: Bool = false
    
    private var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let's attempt to show the user's location
        mapView.showsUserLocation = true
        
        searchTextField.delegate = self
        
        // configure user tracking button
        userTrackingButton = MKUserTrackingButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
        mapView.addSubview(userTrackingButton)
        userTrackingButton.mapView = mapView
        
        // add annotations to map view
        loadMap()
        
        // setup mapview delegate to this
        mapView.delegate = self
    }

    private func makeAnnotations() -> [MKPointAnnotation]{
        var annotations = [MKPointAnnotation]()
        for location in Location.getLocations() {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.title
            annotations.append(annotation)
        }
        isShowingNewAnnotations = true
        self.annotations = annotations
        return annotations
    }
    
    private func loadMap() {
        let annotations = makeAnnotations()
        mapView.addAnnotations(annotations)
    }
    
    private func convertPlaceNameToCoordinate(_ placeName: String) {
        locationSession.convertPlacemarkToCoordinate(addressString: placeName) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print("geocoding error: \(error)")
            case .success(let coordinate):
                print("coordinate: \(coordinate)")
                // set map view at given coordinate
                // moves map to given coordinate
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1600, longitudinalMeters: 1600)
                self.mapView.setRegion(region, animated: true)
                
                
            }
        }
    }

}

extension MapViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        guard let searchText = textField.text,
              !searchText.isEmpty else {
            return true
        }
        
        convertPlaceNameToCoordinate(searchText)
        
        return true
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation else { return }
        
        guard let location = (Location.getLocations().filter{ $0.title == annotation.title }).first else { return }
        
        print("location \(location.title) was selected")
        
        guard let detailVC = storyboard?.instantiateViewController(identifier: "LocationDetailViewController", creator: { coder in
            return LocationDetailViewController(coder: coder, location: location)
        }) else {
            fatalError("could not downcast to LocationDetailViewController")
        }
        present(detailVC, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil}
        
        let identifier = "annotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.glyphTintColor = .systemYellow
            annotationView?.markerTintColor = .systemBlue
//            annotationView?.glyphText = "Marker"
            annotationView?.glyphImage = UIImage(named: "duck")
            
        }else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if isShowingNewAnnotations {
            mapView.showAnnotations(annotations, animated: false)
        }
        isShowingNewAnnotations = false
    }
    
}
