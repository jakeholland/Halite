import MapKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        RoadConditionsView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
