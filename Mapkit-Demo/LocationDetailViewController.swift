//
//  LocationDetailViewController.swift
//  Mapkit-Demo
//
//  Created by Laxmikanth Reddy on 25/11/22.
//

import UIKit

class LocationDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var location: Location
    
    init?(coder: NSCoder, location: Location) {
        self.location = location
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: location.imageName)
    }
    


}
