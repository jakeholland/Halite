import MapKit

extension MKMapView {
    func zoom(to polylines: [MKPolyline], animated: Bool) {
        let boundingMapRects = polylines.map { $0.boundingMapRect }
        
        guard let firstMapRect = boundingMapRects.first else { return }
        
        let boundingMapRect = boundingMapRects.reduce(firstMapRect) { $0.union($1) }
        
        setVisibleMapRect(boundingMapRect,
                          edgePadding: UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0),
                          animated: animated)
    }
    
    func removeAllOverlays() {
        removeOverlays(overlays)
    }
}
