import MapKit
import SwiftUI

struct ContentView: View {
    
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    var body: some View {
        MapView(centerCoordinate: $centerCoordinate)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
