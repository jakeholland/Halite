import MapKit
import RoadConditionsService
import SwiftUI
import UIKit

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var roadConditionsSegments: [RoadConditionsSegment]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let currentPolylines = view.overlays.compactMap { $0 as? MKPolyline }
        let polylines = roadConditionsSegments.polylines
        
        guard currentPolylines != polylines else { return }
        
        view.removeAllOverlays()
        view.addOverlays(polylines)
        view.zoom(to: polylines, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard
                let polyline = overlay as? MKPolyline,
                let roadConditionsSegment = roadConditionsSegment(for: polyline)
                else { return MKOverlayRenderer(overlay: overlay) }

            let polylineRenderer = MKPolylineRenderer(overlay: polyline)
            polylineRenderer.strokeColor = roadConditionsSegment.roadConditions.color
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        
        private func roadConditionsSegment(for polyline: MKPolyline) -> RoadConditionsSegment? {
            parent.roadConditionsSegments.first(where: { $0.multiPolyline.polylines.contains(polyline) })
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var exampleCoodinate: CLLocationCoordinate2D = .init(latitude: 51.5, longitude: -0.13)
    
    static var previews: some View {
        MapView(centerCoordinate: .constant(exampleCoodinate), roadConditionsSegments: .constant([]))
    }
}
