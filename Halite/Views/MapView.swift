import MapKit
import RoadConditionsService
import SwiftUI
import UIKit

struct MapView: UIViewRepresentable {
    
    @Binding var region: MKCoordinateRegion
    @Binding var roadConditionsSegments: [RoadConditionsMultiPolyline]
    @Binding var isCenteredOnUser: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.showsTraffic = true
        mapView.showsBuildings = false
        mapView.isPitchEnabled = false

        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.userTrackingMode = isCenteredOnUser ? .follow : .none

        if context.coordinator.roadConditionsSegments != roadConditionsSegments {
            context.coordinator.roadConditionsSegments = roadConditionsSegments
            view.removeAllOverlays()
            view.addOverlays(roadConditionsSegments)
        }
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        private var parent: MapView
        var roadConditionsSegments: [RoadConditionsMultiPolyline] = []
        
        private let userLocationManager: UserLocationManager

        init(_ parent: MapView, userLocationManager: UserLocationManager = .shared) {
            self.parent = parent
            self.userLocationManager = userLocationManager
            super.init()
            userLocationManager.requestAuthorization()
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.region = mapView.region
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            polylineRenderer(for: overlay) ?? MKOverlayRenderer(overlay: overlay)
        }
        
        func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
            parent.isCenteredOnUser = mode == .follow
        }
        
        private func polylineRenderer(for overlay: MKOverlay) -> MKMultiPolylineRenderer? {
            guard let roadConditionsSegment = overlay as? RoadConditionsMultiPolyline else { return nil }

            let polylineRenderer = MKMultiPolylineRenderer(overlay: roadConditionsSegment)
            polylineRenderer.strokeColor = roadConditionsSegment.roadConditions.color
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var exampleCoodinate: CLLocationCoordinate2D = .init(latitude: 51.5, longitude: -0.13)
    static var exampleRegion: MKCoordinateRegion = .init(center: exampleCoodinate,
                                                         span: .init(latitudeDelta: 50, longitudeDelta: 50))
    
    static var previews: some View {
        MapView(region: .constant(exampleRegion),
                roadConditionsSegments: .constant([]),
                isCenteredOnUser: .constant(false))
    }
}
