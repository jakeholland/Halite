import CoreLocation

final class UserLocationManager: NSObject {
 
    static let shared: UserLocationManager = UserLocationManager()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return locationManager
    }()

    func requestAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            // TODO: Show alert?
            return
        }
    }
}
