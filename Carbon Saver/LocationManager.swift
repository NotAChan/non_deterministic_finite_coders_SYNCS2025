import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var timer: Timer?
    private var durationTimer: Timer?
    @Published var trackingStartTime: Date?
    
    @Published var currentLocation: CLLocation?
    @Published var locations: [LocationPoint] = []
    @Published var isTracking = false
    @Published var currentDistance: Double = 0.0
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    @Published var routePolyline: MKPolyline?
    
    var currentDuration: TimeInterval {
        guard let startTime = trackingStartTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startTracking() {
        guard !isTracking else { return }
        
        isTracking = true
        trackingStartTime = Date()
        locations.removeAll()
        routeCoordinates.removeAll()
        routePolyline = nil
        currentDistance = 0.0
        
        locationManager.startUpdatingLocation()
        
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.locationManager.requestLocation()
        }
        
        durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.objectWillChange.send()
        }
        
        if let currentLocation = currentLocation {
            region.center = currentLocation.coordinate
        }
    }
    
    func stopTracking() {
        guard isTracking else { return }
        
        isTracking = false
        timer?.invalidate()
        timer = nil
        durationTimer?.invalidate()
        durationTimer = nil
        locationManager.stopUpdatingLocation()
        
        createRoutePolyline()
    }
    
    func getCurrentTrip() -> Trip? {
        guard let startTime = trackingStartTime,
              !locations.isEmpty else { 
            print("getCurrentTrip failed: startTime=\(trackingStartTime?.description ?? "nil"), locations.count=\(locations.count)")
            return nil 
        }
        
        let duration = Date().timeIntervalSince(startTime)
        let trip = Trip(
            transportationType: .walking,
            distance: currentDistance,
            locations: locations,
            duration: duration
        )
        
        print("getCurrentTrip success: distance=\(currentDistance), duration=\(duration), locations=\(locations.count)")
        
        return trip
    }
    
    func clearTrackingData() {
        trackingStartTime = nil
        locations.removeAll()
        routeCoordinates.removeAll()
        routePolyline = nil
        currentDistance = 0.0
    }
    
    private func createRoutePolyline() {
        guard routeCoordinates.count >= 2 else { return }
        
        let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        routePolyline = polyline
        
        fitMapToRoute()
    }
    
    private func fitMapToRoute() {
        guard !routeCoordinates.isEmpty else { return }
        
        let minLat = routeCoordinates.map { $0.latitude }.min() ?? 0
        let maxLat = routeCoordinates.map { $0.latitude }.max() ?? 0
        let minLon = routeCoordinates.map { $0.longitude }.min() ?? 0
        let maxLon = routeCoordinates.map { $0.longitude }.max() ?? 0
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        
        let latDelta = (maxLat - minLat) * 1.2
        let lonDelta = (maxLon - minLon) * 1.2
        
        let newRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(
                latitudeDelta: max(latDelta, 0.005),
                longitudeDelta: max(lonDelta, 0.005)
            )
        )
        
        region = newRegion
    }
    
    func resetTracking() {
        stopTracking()
        locations.removeAll()
        routeCoordinates.removeAll()
        routePolyline = nil
        currentDistance = 0.0
        durationTimer?.invalidate()
        durationTimer = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        currentLocation = newLocation
        
        if region.center.latitude == 0 && region.center.longitude == 0 {
            region.center = newLocation.coordinate
        }
        
        let locationPoint = LocationPoint(coordinate: newLocation.coordinate)
        
        if let previousLocation = self.locations.last {
            let previousCLLocation = CLLocation(latitude: previousLocation.latitude, longitude: previousLocation.longitude)
            let distance = newLocation.distance(from: previousCLLocation) / 1000.0
            currentDistance += distance
            
            if isTracking {
                print("Location update: +\(String(format: "%.3f", distance)) km, total: \(String(format: "%.3f", currentDistance)) km")
            }
        }
        
        self.locations.append(locationPoint)
        
        routeCoordinates.append(newLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    

}
