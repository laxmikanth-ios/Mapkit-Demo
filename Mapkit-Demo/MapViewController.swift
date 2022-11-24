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
    
    private let locationSession = CoreLocationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let's attempt to show the user's location
        mapView.showsUserLocation = true
        
        searchTextField.delegate = self
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
