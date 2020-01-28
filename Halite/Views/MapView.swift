import MapKit
import RoadConditionsService
import SwiftUI
import UIKit

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var region: MKCoordinateRegion
    @Binding var roadConditionsSegments: [RoadConditionsMultiPolyline]
    @Binding var roadConditionsRegions: [RoadConditionsMultiPolygon]
    
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
        context.coordinator.roadConditionsRegions = roadConditionsRegions
        
        let currentMultiPolylines = view.overlays.compactMap { $0 as? RoadConditionsMultiPolyline }
        let currentMultiPolygons = view.overlays.compactMap { $0 as? RoadConditionsMultiPolygon }
        
        guard currentMultiPolylines != roadConditionsSegments || currentMultiPolygons != roadConditionsRegions else { return }
        
        view.removeAllOverlays()
        view.addOverlays(roadConditionsSegments + roadConditionsRegions)
        view.zoom(to: roadConditionsSegments + roadConditionsRegions, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var roadConditionsSegments: [RoadConditionsMultiPolyline] = []
        var roadConditionsRegions: [RoadConditionsMultiPolygon] = []

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
            parent.region = mapView.region
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            polygonRenderer(for: overlay) ?? polylineRenderer(for: overlay) ?? MKOverlayRenderer(overlay: overlay)
        }
        
        private func polylineRenderer(for overlay: MKOverlay) -> MKMultiPolylineRenderer? {
            guard let roadConditionsSegment = overlay as? RoadConditionsMultiPolyline else { return nil }

            let polylineRenderer = MKMultiPolylineRenderer(overlay: roadConditionsSegment)
            polylineRenderer.strokeColor = roadConditionsSegment.roadConditions.lineColor
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        
        private func polygonRenderer(for overlay: MKOverlay) -> MKMultiPolygonRenderer? {
            guard let roadConditionsRegion = overlay as? RoadConditionsMultiPolygon else { return nil }
            
            let polygonRenderer = MKMultiPolygonRenderer(overlay: roadConditionsRegion)
            polygonRenderer.fillColor = roadConditionsRegion.roadConditions.regionColor
            return polygonRenderer
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var exampleCoodinate: CLLocationCoordinate2D = .init(latitude: 51.5, longitude: -0.13)
    static var exampleRegion: MKCoordinateRegion = .init(center: exampleCoodinate, span: .init(latitudeDelta: 50, longitudeDelta: 50))
    
    static var previews: some View {
        MapView(centerCoordinate: .constant(exampleCoodinate),
                region: .constant(exampleRegion),
                roadConditionsSegments: .constant([]),
                roadConditionsRegions: .constant([]))
    }
}
