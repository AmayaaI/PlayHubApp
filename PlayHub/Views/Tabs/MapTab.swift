import SwiftUI
import MapKit
import CoreLocation

struct MapTab: View {

    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var placeNames: [UUID: String] = [:]
    @ObservedObject private var gameStorage = GameStorage.shared
    @ObservedObject private var playerStore = PlayerStore.shared

    private var gameLocations: [GameSession] {
        gameStorage.sessions(for: playerStore.selectedPlayerID)
            .filter { $0.latitude != 0 || $0.longitude != 0 }
            .sorted { $0.timestamp > $1.timestamp }
    }

    var body: some View {

        ZStack {
            premiumBackground

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Played Locations")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal)

                    Map(position: $cameraPosition) {
                        ForEach(gameLocations) { session in
                            Annotation(session.mode.rawValue, coordinate: CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude)) {
                                Image(systemName: "gamecontroller.fill")
                                    .foregroundStyle(.white)
                                    .padding(7)
                                    .background(.purple, in: Circle())
                            }
                        }
                    }
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(.horizontal)

                    if gameLocations.isEmpty {
                        ContentUnavailableView("No Saved Game Locations", systemImage: "map", description: Text("Finish a game with location access enabled to see it here."))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 48)
                    } else {
                        ForEach(gameLocations) { session in
                            locationCard(for: session)
                        }
                    }
                }
                .padding(.vertical)
            }
        }
        .onAppear {
            centerOnSavedGame()
        }
        .onChange(of: playerStore.selectedPlayerID) {
            placeNames.removeAll()
            centerOnSavedGame()
        }
        .task(id: gameLocations.map(\.id)) {
            await loadPlaceNames()
        }
        .navigationTitle("Played Locations")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Played Locations")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }
        }
    }

    private func locationCard(for session: GameSession) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundStyle(.cyan)

            VStack(alignment: .leading, spacing: 5) {
                Text(placeNames[session.id] ?? "Finding location…")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(session.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.68))
                Text(session.mode.rawValue)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.cyan)
                Text(String(format: "%.4f, %.4f", session.latitude, session.longitude))
                    .font(.caption2.monospaced())
                    .foregroundStyle(.white.opacity(0.46))
            }

            Spacer(minLength: 0)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.13), lineWidth: 1)
        }
        .padding(.horizontal)
    }

    private func loadPlaceNames() async {
        for session in gameLocations where placeNames[session.id] == nil {
            let location = CLLocation(latitude: session.latitude, longitude: session.longitude)
            let fallback = String(format: "%.4f, %.4f", session.latitude, session.longitude)

            do {
                let placemark = try await CLGeocoder().reverseGeocodeLocation(location).first
                let name = [placemark?.name, placemark?.locality, placemark?.administrativeArea]
                    .compactMap { $0 }
                    .joined(separator: ", ")
                placeNames[session.id] = name.isEmpty ? fallback : name
            } catch {
                placeNames[session.id] = fallback
            }
        }
    }

    private func centerOnSavedGame() {
        guard let session = gameLocations.first else { return }
        cameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }

    private var premiumBackground: some View {
        LinearGradient(
            colors: [Color(red: 0.05, green: 0.06, blue: 0.16), Color(red: 0.16, green: 0.08, blue: 0.34), Color(red: 0.03, green: 0.28, blue: 0.38)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    MapTab()
}
