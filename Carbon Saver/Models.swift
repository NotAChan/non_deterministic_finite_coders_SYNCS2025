import Foundation
import CoreLocation

// MARK: - Transportation Types
enum TransportationType: String, CaseIterable, Codable {
    case walking = "Walking"
    case cycling = "Cycling"
    case bus = "Bus"
    case train = "Train"
    case metro = "Metro"
    
    var carbonEmissionPerKm: Double {
        switch self {
        case .walking, .cycling:
            return 0.0
        case .bus: //There are some discussions with this, no matter whether individual person take public transport or not, the public transport almost always go on, so it can be considered as 0 as well just like walking and cycling. However, we might can also choose to say each person is still responsible for parts of the carbon emission for public transport and therefore this could be extended to consider the exact amt of carbon emission for each public transport.
            return 0.0
        case .train:
            return 0.0
        case .metro:
            return 0.0
        }
    }
    
    var carEquivalentEmission: Double {
        return 0.171
    }
    
    var carbonSavedPerKm: Double {
        return carEquivalentEmission - carbonEmissionPerKm
    }
    
    var pointsPerKm: Int {
        return Int(carbonSavedPerKm * 10000) //We decided to make it become 1 kg CO2= 100 pts
    }
}

class UserData: ObservableObject {
    @Published var totalPoints: Int = 0
    @Published var totalDistance: Double = 0.0
    @Published var totalCarbonSaved: Double = 0.0
    @Published var trips: [Trip] = []
    @Published var redemptions: [Redemption] = []
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
    }
    
    func addPoints(_ points: Int) {
        totalPoints += points
        saveData()
    }
    
    func addTrip(_ trip: Trip) {
        trips.append(trip)
        totalDistance += trip.distance
        totalCarbonSaved += trip.carbonSaved
        totalPoints += trip.pointsEarned
        saveData()
    }
    
    private func saveData() {
        userDefaults.set(totalPoints, forKey: "totalPoints")
        userDefaults.set(totalDistance, forKey: "totalDistance")
        userDefaults.set(totalCarbonSaved, forKey: "totalCarbonSaved")
        
        if let tripsData = try? JSONEncoder().encode(trips) {
            userDefaults.set(tripsData, forKey: "trips")
        }
        
        if let redemptionsData = try? JSONEncoder().encode(redemptions) {
            userDefaults.set(redemptionsData, forKey: "redemptions")
        }
    }
    
    private func loadData() {
        totalPoints = userDefaults.integer(forKey: "totalPoints")
        totalDistance = userDefaults.double(forKey: "totalDistance")
        totalCarbonSaved = userDefaults.double(forKey: "totalCarbonSaved")
        
        if let tripsData = userDefaults.data(forKey: "trips"),
           let decodedTrips = try? JSONDecoder().decode([Trip].self, from: tripsData) {
            trips = decodedTrips
        }
        
        if let redemptionsData = userDefaults.data(forKey: "redemptions"),
           let decodedRedemptions = try? JSONDecoder().decode([Redemption].self, from: redemptionsData) {
            redemptions = decodedRedemptions
        }
    }
}

struct Trip: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let transportationType: TransportationType
    let distance: Double
    let carbonSaved: Double
    let pointsEarned: Int
    let locations: [LocationPoint]
    let duration: TimeInterval
    
    init(transportationType: TransportationType, distance: Double, locations: [LocationPoint], duration: TimeInterval) {
        self.date = Date()
        self.transportationType = transportationType
        self.distance = distance
        self.carbonSaved = distance * transportationType.carbonSavedPerKm
        self.pointsEarned = distance > 0 ? Int(distance * Double(transportationType.pointsPerKm)) : 0
        self.locations = locations
        self.duration = duration
    }
    
    enum CodingKeys: String, CodingKey {
        case date, transportationType, distance, carbonSaved, pointsEarned, locations, duration
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        transportationType = try container.decode(TransportationType.self, forKey: .transportationType)
        distance = try container.decode(Double.self, forKey: .distance)
        carbonSaved = try container.decode(Double.self, forKey: .carbonSaved)
        pointsEarned = try container.decode(Int.self, forKey: .pointsEarned)
        locations = try container.decode([LocationPoint].self, forKey: .locations)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(transportationType, forKey: .transportationType)
        try container.encode(distance, forKey: .distance)
        try container.encode(carbonSaved, forKey: .carbonSaved)
        try container.encode(pointsEarned, forKey: .pointsEarned)
        try container.encode(locations, forKey: .locations)
        try container.encode(duration, forKey: .duration)
    }
}

struct LocationPoint: Codable, Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let timestamp: Date
    
    init(coordinate: CLLocationCoordinate2D, timestamp: Date = Date()) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.timestamp = timestamp
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

enum RedemptionType: String, CaseIterable, Codable {
    case donate = "Donate to Environmental Cause"
    case plantTree = "Plant a Tree"
    
    var pointsRequired: Int {
        switch self {
        case .donate:
            return 1500
        case .plantTree:
            return 2000
        }
    }
    
    var description: String {
        switch self {
        case .donate:
            return "Your donation will support environmental conservation projects"
        case .plantTree:
            return "We'll plant a tree in your name to help combat climate change"
        }
    }
}

struct Redemption: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let type: RedemptionType
    let pointsSpent: Int
    let userName: String
    
    init(type: RedemptionType, pointsSpent: Int, userName: String) {
        self.date = Date()
        self.type = type
        self.pointsSpent = pointsSpent
        self.userName = userName
    }
    
    enum CodingKeys: String, CodingKey {
        case date, type, pointsSpent, userName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        type = try container.decode(RedemptionType.self, forKey: .type)
        pointsSpent = try container.decode(Int.self, forKey: .pointsSpent)
        userName = try container.decode(String.self, forKey: .userName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(type, forKey: .type)
        try container.encode(pointsSpent, forKey: .pointsSpent)
        try container.encode(userName, forKey: .userName)
    }
}
