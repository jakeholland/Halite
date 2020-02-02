import MapKit

extension MKCoordinateRegion {
    var params: Parameters {
        let mapRect = self.mapRect
        return [
            "geometryType": "esriGeometryEnvelope",
            "geometry": [
                "xmin": mapRect.minX,
                "ymin": mapRect.minY,
                "xmax": mapRect.maxX,
                "ymax": mapRect.maxY
            ]
        ]
    }
    
    var mapRect: MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: center.latitude + (span.latitudeDelta / 2),
                                             longitude: center.longitude - (span.longitudeDelta / 2))
        let bottomRight = CLLocationCoordinate2D(latitude: center.latitude - (span.latitudeDelta / 2),
                                                 longitude: center.longitude + (span.longitudeDelta / 2))

        let a = MKMapPoint(topLeft)
        let b = MKMapPoint(bottomRight)

        return MKMapRect(origin: MKMapPoint(x: min(a.x,b.x), y: min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
}
