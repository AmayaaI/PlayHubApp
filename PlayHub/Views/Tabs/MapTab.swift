import SwiftUI
import MapKit

struct MapTab: View {

    @StateObject private var locationService = LocationService.shared

    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {

        VStack {

            Map(position: $cameraPosition) {

                // Current location
                Marker("You", coordinate: locationService.currentCoordinate)

                // Saved location
                if let saved = locationService.savedCoordinate {
                    Marker("Saved Location", coordinate: saved)
                }
            }
            .onAppear {

                cameraPosition = .region(
                    MKCoordinateRegion(
                        center: locationService.currentCoordinate,
                        span: MKCoordinateSpan(
                            latitudeDelta: 0.01,
                            longitudeDelta: 0.01
                        )
                    )
                )
            }

            Button {

                locationService.saveCurrentLocation()

            } label: {

                Label("Save My Location",
                      systemImage: "location.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

#Preview {
    MapTab()
}
