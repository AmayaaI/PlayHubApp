import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {

    static let shared = LocationService()

    let manager = CLLocationManager()

    @Published var latitude = 0.0
    @Published var longitude = 0.0

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else { return }

        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }

    func saveCurrentLocation() {

        UserDefaults.standard.set(latitude, forKey: "savedLatitude")
        UserDefaults.standard.set(longitude, forKey: "savedLongitude")

        print("Location Saved")
    }

    var savedCoordinate: CLLocationCoordinate2D? {

        let lat = UserDefaults.standard.double(forKey: "savedLatitude")
        let lon = UserDefaults.standard.double(forKey: "savedLongitude")

        if lat == 0 && lon == 0 {
            return nil
        }

        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    var currentCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
