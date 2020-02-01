import MapKit

extension CLLocationCoordinate2D {
    var region: MKCoordinateRegion { .init(center: self, latitudinalMeters: 30000, longitudinalMeters: 30000) }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}
