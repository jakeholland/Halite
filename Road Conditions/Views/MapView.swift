import MapKit
import SwiftUI
import UIKit

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    
    let viewModel = MapViewModel()
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let polylines = viewModel.roadConditionsSegments.polylines
        
        guard view.overlays.compactMap({ $0 as? MKPolyline }) != polylines else { return }
        
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
                let roadConditionsSegment = parent.viewModel.roadConditionsSegment(for: polyline)
                else { return MKOverlayRenderer(overlay: overlay) }

            let polylineRenderer = MKPolylineRenderer(overlay: polyline)
            polylineRenderer.strokeColor = roadConditionsSegment.roadConditions.color
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
    }
}

#if DEBUG
extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate))
    }
}
#endif
