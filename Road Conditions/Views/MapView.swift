import MapKit
import RoadConditionsService
import SwiftUI
import UIKit

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var roadConditionsSegments: [RoadConditionsSegment]
    @Binding var roadConditionsRegions: [RoadConditionsRegion]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let currentPolylines = view.overlays.compactMap { $0 as? MKPolyline }
        let polylines = roadConditionsSegments.polylines
        context.coordinator.roadConditionsSegments = roadConditionsSegments
        
        let currentPolygons = view.overlays.compactMap { $0 as? MKPolygon }
        let polygons = roadConditionsRegions.polygons
        context.coordinator.roadConditionsRegions = roadConditionsRegions
        
        guard currentPolylines != polylines || currentPolygons != polygons else { return }
        
        view.removeAllOverlays()
        view.addOverlays(polylines + polygons)
        view.zoom(to: polylines, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var roadConditionsSegments: [RoadConditionsSegment] = []
        var roadConditionsRegions: [RoadConditionsRegion] = []

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            polygonRenderer(for: overlay) ?? polylineRenderer(for: overlay) ?? MKOverlayRenderer(overlay: overlay)
        }
        
        private func polylineRenderer(for overlay: MKOverlay) -> MKPolylineRenderer? {
            guard
                let polyline = overlay as? MKPolyline,
                let roadConditionsSegment = roadConditionsSegment(for: polyline)
                else { return nil }

            let polylineRenderer = MKPolylineRenderer(overlay: polyline)
            polylineRenderer.strokeColor = roadConditionsSegment.roadConditions.color
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        
        private func polygonRenderer(for overlay: MKOverlay) -> MKPolygonRenderer? {
            guard
                let polygon = overlay as? MKPolygon,
                let roadConditionsRegion = roadConditionsRegion(for: polygon)
                else { return nil }
            
            let polygonRenderer = MKPolygonRenderer(overlay: polygon)
            polygonRenderer.fillColor = roadConditionsRegion.roadConditions.color.withAlphaComponent(0.3)
            
            return polygonRenderer
        }
        
        private func roadConditionsSegment(for polyline: MKPolyline) -> RoadConditionsSegment? {
            roadConditionsSegments.first(where: { $0.multiPolyline.polylines.contains(polyline) })
        }
        
        private func roadConditionsRegion(for polygon: MKPolygon) -> RoadConditionsRegion? {
            roadConditionsRegions.first(where: { $0.multiPolygon.polygons.contains(polygon) })
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var exampleCoodinate: CLLocationCoordinate2D = .init(latitude: 51.5, longitude: -0.13)
    
    static var previews: some View {
        MapView(centerCoordinate: .constant(exampleCoodinate),
                roadConditionsSegments: .constant([]),
                roadConditionsRegions: .constant([]))
    }
}
