# Carbon Saver - Sustainable Transportation Tracker

A comprehensive iOS application that encourages sustainable transportation by tracking user routes and calculating carbon emissions saved compared to driving a car.

## Features

### 🚶‍♂️ Transportation Tracking
- **Multiple Transportation Types**: Walking, Cycling, Bus, Train, Metro
- **Real-time Location Tracking**: GPS tracking every 5 seconds
- **Route Visualization**: Interactive map showing your journey
- **Distance Calculation**: Accurate distance measurement in kilometers

### 🌱 Carbon Emission Calculation
- **Smart Calculations**: Compares your transportation choice with car emissions
- **Real-time Updates**: See carbon saved during your journey
- **Points System**: Earn points based on carbon emissions saved (1 kg CO2 = 100 points)

### 🎁 Redemption System
- **Plant a Tree**: 2000 points - We'll plant a tree in your name
- **Environmental Donation**: 1500 points - Support conservation projects
- **Carbon Offset Certificate**: 3000 points - Receive a certificate

### 📊 User Profile & Statistics
- **Trip History**: View all your completed trips
- **Total Statistics**: Track total distance, carbon saved, and points earned
- **Personal Dashboard**: Monitor your environmental impact

## Carbon Emission Data

The app uses scientifically-based carbon emission factors:

| Transportation | CO2 per km | Points per km |
|----------------|------------|---------------|
| Walking/Cycling | 0.0 kg | 17 points |
| Bus | 0.105 kg | 6.6 points |
| Train | 0.041 kg | 13 points |
| Metro | 0.046 kg | 12.5 points |
| Car (baseline) | 0.171 kg | 0 points |

## Technical Implementation

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **Core Location**: GPS tracking and location services
- **MapKit**: Interactive map display and route visualization
- **UserDefaults**: Local data persistence
- **MVVM Pattern**: Clean separation of concerns

### Key Components
1. **LocationManager**: Handles GPS tracking and location updates
2. **UserData**: Manages user statistics and trip history
3. **ContentView**: Main app interface with map and controls
4. **Models**: Data structures for trips, locations, and redemptions

## Setup Instructions

### Prerequisites
- Xcode 14.0 or later
- iOS 16.0 or later
- iPhone with GPS capabilities

### Installation
1. Clone or download the project
2. Open `Carbon Saver.xcodeproj` in Xcode
3. Select your development team in project settings
4. Build and run on your device

### Permissions
The app requires location permissions to function:
- **When In Use**: For tracking your routes
- **Always**: For background tracking (optional)

## Usage Guide

### Starting a Trip
1. Open the Carbon Saver app
2. Select your transportation type from the dropdown
3. Press the "Start" button to begin tracking
4. The map will show your current location and track your route

### During Your Journey
- The map automatically centers on your current location
- Your route is drawn as a blue line on the map
- Real-time distance and carbon savings are displayed
- A green dot shows your start point, red dot shows current position

### Completing a Trip
1. Press the "Stop" button when you reach your destination
2. Review your trip summary:
   - Distance traveled
   - Duration
   - Carbon emissions saved
   - Points earned
3. Your trip is automatically saved to your profile

### Managing Points
- View your total points in the top-right corner
- Access the redemption menu via the "Redeem" button
- Choose from available redemption options
- Track your redemption history

### Profile & Statistics
- Tap the profile icon to view your statistics
- See total distance, carbon saved, and trip count
- Browse your recent trips
- Monitor your environmental impact over time

## Privacy & Data

- **Local Storage**: All data is stored locally on your device
- **No Cloud Sync**: Your location data never leaves your device
- **Optional Permissions**: You can deny location access and still use the app
- **Data Control**: You can reset your data at any time

## Environmental Impact

By using sustainable transportation, you're making a real difference:

- **Walking 1 km**: Saves 0.171 kg CO2 (17 points)
- **Cycling 1 km**: Saves 0.171 kg CO2 (17 points)
- **Taking the bus 1 km**: Saves 0.066 kg CO2 (6.6 points)
- **Taking the train 1 km**: Saves 0.13 kg CO2 (13 points)

## Future Enhancements

- Social features and leaderboards
- Integration with public transport APIs
- Carbon offset marketplace
- Achievement system
- Export trip data
- Apple Health integration

## Contributing

This project was created for the SYNCS Hackathon 2025. Feel free to contribute improvements and new features!

## License

This project is open source and available under the MIT License.

---

**Make every journey count for the planet! 🌍**
