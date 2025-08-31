//
//  ContentView.swift
//  Carbon Saver
//
//  Created by jiaao gu on 30/8/2025.
//
//
//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!!")
//        }
//        .padding()
//    }
//}
import SwiftUI
import CoreLocation
import MapKit

struct WelcomeView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.682, green: 0.894, blue: 0.502)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top spacing - approximately 1/8th of screen height
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.125)
                
                // Image section - takes up full horizontal space
                Image("e626ed09b33e679ed8262fb8df5ddae278ec6fde")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                
                // Text section
                VStack(spacing: 20) {
                    // Add space above the text
                    Spacer()
                        .frame(height: 30)
                    
                    Text("Your footsteps\ncarry the weight\nof change.")
                        .font(.custom("Georgia", size: 32))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .lineSpacing(12)
                    
                    Spacer()
                }
                .padding(.bottom, 60)
                .padding(.horizontal, 20)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 100 || value.translation.width > 100 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isShowing = false
                        }
                    }
                }
        )
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Swipe right to continue")
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.bottom, 20)
                    Spacer()
                }
            }
        )
    }
}



struct ContentView: View {
    let lightGreenColor = Color(red: 0.682, green: 0.894, blue: 0.502)
    @StateObject private var locationManager = LocationManager()
    @StateObject private var userData = UserData()
    @State private var selectedTransportType: TransportationType = .walking
    @State private var showingTripSummary = false
    @State private var showingProfile = false
    @State private var showingRedemption = false
    @State private var showingWelcome = true
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 0) {
                    headerSection
                    mapSection
                    controlSection
                }
                .background(lightGreenColor)
                .navigationBarHidden(true)
                .sheet(isPresented: $showingTripSummary) {
                    if let trip = locationManager.getCurrentTrip() {
                        TripSummaryView(trip: trip, userData: userData)
                            .onDisappear {
                                locationManager.clearTrackingData()
                            }
                    } else {
                        VStack {
                            Text("No Trip Data")
                                .font(.title)
                                .foregroundColor(.red)
                            Text("Unable to retrieve trip information")
                                .foregroundColor(.secondary)
                        }
                        .onDisappear {
                            locationManager.clearTrackingData()
                        }
                    }
                }
                .sheet(isPresented: $showingProfile) {
                    ProfileView(userData: userData)
                }
                .sheet(isPresented: $showingRedemption) {
                    RedemptionView(userData: userData)
                }
            }
            
            if showingWelcome {
                WelcomeView(isShowing: $showingWelcome)
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: { showingProfile.toggle() }) {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()
                Button(action: { showingRedemption.toggle() }) {
                    VStack {
                        Image(systemName: "leaf.fill")
                            .font(.title2)
                        Text("Redeem")
                            .font(.caption)
                    }
                    .foregroundColor(.green)
                    .frame(maxWidth: 0.15 * UIScreen.main.bounds.width)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                VStack(alignment: .trailing) {
                    Text("\(userData.totalPoints)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Points")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
            
            VStack(spacing: 4) {
                Text(locationManager.isTracking ? "Keep up the good work!" : "Let's reduce carbon emission while staying healthy.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                if locationManager.isTracking {
                    Text("Distance: \(String(format: "%.2f", locationManager.currentDistance)) km")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                }
            }
            .padding(.horizontal)
            
            Divider()
        }
        .padding(.top)
        .padding(.bottom, 8)
    }
    
    private var mapSection: some View {
        VStack {
            if !locationManager.isTracking {
                HStack {
                    Text("Transportation Type:")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    Spacer()
                    Menu {
                        ForEach(TransportationType.allCases, id: \.self) { type in
                            Button(type.rawValue) {
                                selectedTransportType = type
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedTransportType.rawValue)
                                .foregroundColor(.primary)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            
            ZStack {
                MapViewRepresentable(
                    region: $locationManager.region,
                    routePolyline: locationManager.routePolyline,
                    isTracking: locationManager.isTracking,
                    currentRouteCoordinates: locationManager.isTracking ? locationManager.routeCoordinates : []
                )
                .edgesIgnoringSafeArea(.horizontal)
                
                if locationManager.isTracking {
                    VStack {
                        Spacer()
                        
                        VStack {
                            Spacer()
                            HStack {
                                VStack(spacing: 8) {
                                    HStack {
                                        Image(systemName: "figure.walk")
                                            .foregroundColor(.green)
                                        Text("Live Route")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.green)
                                    }
                                    
                                    VStack(spacing: 4) {
                                        Text(String(format: "%.2f", locationManager.currentDistance))
                                            .font(.title2)
                                            .fontWeight(.bold)
                                        Text("km")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    if locationManager.trackingStartTime != nil {
                                        let duration = locationManager.currentDuration
                                        VStack(spacing: 4) {
                                            Text(formatDuration(duration))
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                            Text("Duration")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                                .shadow(radius: 3)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
        }
    }
    
    private var controlSection: some View {
        VStack(spacing: 16) {
            Divider()
            HStack(spacing: 20) {
                Button(action: handleStartStopAction) {
                    HStack {
                        Image(systemName: locationManager.isTracking ? "stop.fill" : "play.fill")
                            .font(.title2)
                        Text(locationManager.isTracking ? "Stop" : "Start")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(locationManager.isTracking ? Color.red : Color.black)
                    .cornerRadius(12)
                }
                
                if locationManager.isTracking {
                    Button(action: handleResetAction) {
                        HStack {
                            Image(systemName: "xmark")
                                .font(.title2)
                            Text("Cancel")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.orange)
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
    
    private func handleStartStopAction() {
        if locationManager.isTracking {
            if let trip = locationManager.getCurrentTrip() {
                let finalTrip = Trip(
                    transportationType: selectedTransportType,
                    distance: trip.distance,
                    locations: trip.locations,
                    duration: trip.duration
                )
                
                
                userData.addTrip(finalTrip)
                
                locationManager.stopTracking()
                showingTripSummary = true
            } else {
                print("No trip data available after stopping tracking")
                locationManager.stopTracking()
            }
        } else {
            locationManager.startTracking()
        }
    }
    
    private func handleResetAction() {
        locationManager.resetTracking()
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    let routePolyline: MKPolyline?
    let isTracking: Bool
    let currentRouteCoordinates: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        if isTracking {
            mapView.userTrackingMode = .follow
            DispatchQueue.main.async {
                mapView.setUserTrackingMode(.follow, animated: true)
            }
        } else {
            mapView.setRegion(region, animated: true)
        }
        
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        if let polyline = routePolyline {
            mapView.addOverlay(polyline)
        }
        
        if isTracking && currentRouteCoordinates.count >= 2 {
            let previewPolyline = MKPolyline(coordinates: currentRouteCoordinates, count: currentRouteCoordinates.count)
            mapView.addOverlay(previewPolyline)
        }
        
        if currentRouteCoordinates.count >= 2 {
            let startAnnotation = MKPointAnnotation()
            startAnnotation.coordinate = currentRouteCoordinates.first!
            startAnnotation.title = "Start"
            startAnnotation.subtitle = "Route beginning"
            mapView.addAnnotation(startAnnotation)
            
            if !isTracking {
                let endAnnotation = MKPointAnnotation()
                endAnnotation.coordinate = currentRouteCoordinates.last!
                endAnnotation.title = "End"
                endAnnotation.subtitle = "Route completion"
                mapView.addAnnotation(endAnnotation)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                
                if parent.isTracking && parent.currentRouteCoordinates.count >= 2 {
                    renderer.strokeColor = UIColor.systemRed
                    renderer.lineWidth = 3
                    renderer.alpha = 0.6
                    renderer.lineDashPattern = [5, 5]
                } else {
                    renderer.strokeColor = UIColor.systemBlue
                    renderer.lineWidth = 4
                    renderer.alpha = 0.8
                }
                
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let identifier = "RoutePoint"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            }
            
            if annotation.title == "Start" {
                annotationView?.image = UIImage(systemName: "flag.fill")
                annotationView?.tintColor = .systemGreen
            } else if annotation.title == "End" {
                annotationView?.image = UIImage(systemName: "flag.checkered")
                annotationView?.tintColor = .systemRed
            }
            
            return annotationView
        }
    }
}

struct RouteMapView: UIViewRepresentable {
    let locations: [LocationPoint]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = false
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeOverlays(mapView.overlays)
        
        let coordinates = locations.map { $0.coordinate }
        if coordinates.count >= 2 {
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
            
            fitMapToRoute(mapView: mapView, coordinates: coordinates)
        }
    }
    
    private func fitMapToRoute(mapView: MKMapView, coordinates: [CLLocationCoordinate2D]) {
        let minLat = coordinates.map { $0.latitude }.min() ?? 0
        let maxLat = coordinates.map { $0.latitude }.max() ?? 0
        let minLon = coordinates.map { $0.longitude }.min() ?? 0
        let maxLon = coordinates.map { $0.longitude }.max() ?? 0
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        
        let latDelta = (maxLat - minLat) * 1.3
        let lonDelta = (maxLon - minLon) * 1.3
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(
                latitudeDelta: max(latDelta, 0.005),
                longitudeDelta: max(lonDelta, 0.005)
            )
        )
        
        mapView.setRegion(region, animated: false)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RouteMapView
        
        init(_ parent: RouteMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.systemGreen
                renderer.lineWidth = 3
                renderer.alpha = 0.8
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

struct TripSummaryView: View {
    let trip: Trip
    let userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                
                VStack(spacing: 12) {
                    Text("Trip Completed!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 12) {
                        SummaryRow(title: "Transportation", value: trip.transportationType.rawValue)
                        SummaryRow(title: "Distance", value: String(format: "%.2f km", trip.distance))
                        SummaryRow(title: "Duration", value: formatDuration(trip.duration))
                        SummaryRow(title: "Carbon Saved", value: String(format: "%.4f kg CO2", trip.carbonSaved))
                        SummaryRow(title: "Points Earned", value: "\(trip.pointsEarned)")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                if trip.locations.count >= 2 {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Route")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        RouteMapView(locations: trip.locations)
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        
                        VStack(spacing: 8) {
                            if let startLocation = trip.locations.first,
                               let endLocation = trip.locations.last {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Start Location")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(String(format: "%.4f, %.4f", startLocation.latitude, startLocation.longitude))
                                            .font(.caption)
                                            .fontWeight(.medium)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("End Location")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(String(format: "%.4f, %.4f", endLocation.latitude, endLocation.longitude))
                                            .font(.caption)
                                            .fontWeight(.medium)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Route Points")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("\(trip.locations.count)")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Avg. Speed")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(String(format: "%.2f km/h", trip.distance / (trip.duration / 3600)))
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Trip Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}

struct SummaryRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct ProfileView: View {
    @ObservedObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section("Statistics") {
                    StatRow(title: "Total Points", value: "\(userData.totalPoints)")
                    StatRow(title: "Total Distance", value: String(format: "%.2f km", userData.totalDistance))
                    StatRow(title: "Carbon Saved", value: String(format: "%.4f kg CO2", userData.totalCarbonSaved))
                    StatRow(title: "Trips Completed", value: "\(userData.trips.count)")
                }
                
                Section("Recent Trips") {
                    ForEach(userData.trips.prefix(5)) { trip in
                        TripRow(trip: trip)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }
    }
}

struct TripRow: View {
    let trip: Trip
    @State private var showingRouteDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(trip.transportationType.rawValue)
                    .fontWeight(.semibold)
                Spacer()
                Text(trip.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text(String(format: "%.2f km", trip.distance))
                Spacer()
                Text("\(trip.pointsEarned) points")
                    .foregroundColor(.green)
            }
            .font(.caption)
            
            if trip.locations.count >= 2 {
                Button(action: { showingRouteDetail.toggle() }) {
                    HStack {
                        Image(systemName: "map")
                            .font(.caption)
                        Text("View Route")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
                .sheet(isPresented: $showingRouteDetail) {
                    RouteDetailView(trip: trip)
                }
            }
        }
        .padding(.vertical, 2)
    }
}

struct RedemptionView: View {
    @ObservedObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                Section("Available Redemptions") {
                    ForEach(RedemptionType.allCases, id: \.self) { redemptionType in
                        RedemptionRow(
                            redemptionType: redemptionType,
                            userPoints: userData.totalPoints,
                            onRedeem: { redeemItem(redemptionType) }
                        )
                    }
                }
                
                Section("Your Redemptions") {
                    ForEach(userData.redemptions) { redemption in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(redemption.type.rawValue)
                                .fontWeight(.semibold)
                            Text(redemption.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Redeem Points")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert("Redemption", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func redeemItem(_ type: RedemptionType) {
        guard userData.totalPoints >= type.pointsRequired else {
            alertMessage = "You need \(type.pointsRequired) points to redeem this item. You currently have \(userData.totalPoints) points."
            showingAlert = true
            return
        }
        
        let redemption = Redemption(type: type, pointsSpent: type.pointsRequired, userName: "User")
        userData.redemptions.append(redemption)
        userData.totalPoints -= type.pointsRequired
        
        alertMessage = "Successfully redeemed \(type.rawValue)! Thank you for helping the environment."
        showingAlert = true
    }
}

struct RedemptionRow: View {
    let redemptionType: RedemptionType
    let userPoints: Int
    let onRedeem: () -> Void
    
    var canRedeem: Bool {
        userPoints >= redemptionType.pointsRequired
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(redemptionType.rawValue)
                        .fontWeight(.semibold)
                    Text(redemptionType.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(redemptionType.pointsRequired) points")
                        .font(.caption)
                        .foregroundColor(canRedeem ? .green : .red)
                    
                    Button("Redeem") {
                        onRedeem()
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(canRedeem ? Color.blue : Color.gray)
                    .cornerRadius(8)
                    .disabled(!canRedeem)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct RouteDetailView: View {
    let trip: Trip
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text(trip.transportationType.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(trip.date, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text(String(format: "%.2f", trip.distance))
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("km")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text(formatDuration(trip.duration))
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Duration")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack {
                            Text("\(trip.pointsEarned)")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Points")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                RouteMapView(locations: trip.locations)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Route Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}

#Preview {
    ContentView()
}

