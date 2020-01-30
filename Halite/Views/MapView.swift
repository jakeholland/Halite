import MapKit
import RoadConditionsService
import SwiftUI
import UIKit

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var region: MKCoordinateRegion
    @Binding var roadConditionsSegments: [RoadConditionsMultiPolyline]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.showsTraffic = true
        mapView.showsBuildings = false

        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        context.coordinator.roadConditionsSegments = roadConditionsSegments
        
        let currentMultiPolylines = view.overlays.compactMap { $0 as? RoadConditionsMultiPolyline }
        
        guard currentMultiPolylines != roadConditionsSegments else { return }
        
        view.removeAllOverlays()
        view.addOverlays(roadConditionsSegments)
        view.zoom(to: roadConditionsSegments, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var roadConditionsSegments: [RoadConditionsMultiPolyline] = []

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
            parent.region = mapView.region
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            polylineRenderer(for: overlay) ?? MKOverlayRenderer(overlay: overlay)
        }
        
        private func polylineRenderer(for overlay: MKOverlay) -> MKMultiPolylineRenderer? {
            guard let roadConditionsSegment = overlay as? RoadConditionsMultiPolyline else { return nil }

            let polylineRenderer = MKMultiPolylineRenderer(overlay: roadConditionsSegment)
            polylineRenderer.strokeColor = roadConditionsSegment.roadConditions.lineColor
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var exampleCoodinate: CLLocationCoordinate2D = .init(latitude: 51.5, longitude: -0.13)
    static var exampleRegion: MKCoordinateRegion = .init(center: exampleCoodinate, span: .init(latitudeDelta: 50, longitudeDelta: 50))
    
    static var previews: some View {
        MapView(centerCoordinate: .constant(exampleCoodinate),
                region: .constant(exampleRegion),
                roadConditionsSegments: .constant([]))
    }
}
