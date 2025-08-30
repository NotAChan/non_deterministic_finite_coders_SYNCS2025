# Carbon Saver - Sustainable Transportation Tracker

- A comprehensive iOS application that encourages sustainable transportation by tracking user routes and calculating carbon emissions saved compared to driving a car. 
- You are able to collect the points that are proportional to the carbon emissions saved for each trip. 
- The collected points can be used to plant a real tree or donate to support projects under your name. 

## Features

### 🚶‍♂️ Transportation Tracking
- **Multiple Transportation Types**: Walking, Cycling, Bus, Train, Metro, Driving(Car)
- **Real-time Location Tracking**: Real-time location tracking every 5 seconds
- **Route Visualization**: Interactive map showing your journey
- **Distance Calculation**: Accurate distance measurement in kilometers (In the future, we might improve this to be distance measured in meters when it's smaller than 1km - should be a better visualisation to see 50m rather than 0.05km)

### 🌱 Carbon Emission Calculation
- **Smart Calculations**: Compares your transportation choice with car emissions
- **Points System**: Earn points based on carbon emissions saved (1 kg CO2 = 100 points)

### 🎁 Redemption System
- **Plant a Tree**: 2000 points - We'll plant a tree in your name
- **Environmental Donation**: 1500 points - Support conservation projects
- **Carbon Offset Certificate**: 3000 points - Receive a certificate

### 📊 User Profile & Statistics
- **Trip History**: View all your completed trips
- **Total Statistics**: Track total distance, carbon saved, and points earned
- **Personal Dashboard**: Monitor your environmental impacts!

## Carbon Emission Data

The app uses scientifically-based carbon emission factors:

| Transportation | CO2 per km | Points per km |
|----------------|------------|---------------|
| Walking/Cycling | 0.0 kg | 17 points |
| Bus | 0.0 kg | 17 points |
| Train | 0.0 kg | 17 points |
| Metro | 0.0 kg | 17 points |
| Car (baseline) | 0.171 kg | 0 points |

## Technical Implementation

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **Core Location**: GPS tracking and location services
- **MapKit**: Interactive map display and route visualization
- **UserDefaults**: Local data persistence (Future work to integrate database to ensure user information security)

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
- **Data Control**: In the future versions, you can reset your data at any time

## Environmental Impact

By using sustainable transportation, you're making a real difference:

- **Walking 1 km**: Saves 0.171 kg CO2 (17 points)
- **Cycling 1 km**: Saves 0.171 kg CO2 (17 points)
- **Taking the bus 1 km**: Saves 0.171 kg CO2 (17 points)
- **Taking the train 1 km**: Saves 0.171 kg CO2 (17 points)

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
