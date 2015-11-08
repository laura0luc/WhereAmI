//
//  Place.swift
//  WhereAmI
//
//  Created by LAURA LUCRECIA SANCHEZ PADILLA on 22/10/15.
//  Copyright © 2015 LAURA LUCRECIA SANCHEZ PADILLA. All rights reserved.
//

import UIKit
import MapKit

class Place: NSObject, MKAnnotation {
    let title : String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
