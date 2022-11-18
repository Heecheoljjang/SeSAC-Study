//
//  CustomAnnotationView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/19.
//

import Foundation
import MapKit

final class CustomAnnotationView: MKAnnotationView {
    
    var identifier: String {
        return String(describing: self)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var imageNumber: Annotation
    
    init(coordinate: CLLocationCoordinate2D, imageNumber: Annotation) {
        self.coordinate = coordinate
        self.imageNumber = imageNumber
        super.init()
    }
}
