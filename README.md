# Location Alarm App

A Flutter-based mobile application that allows users to set a destination and receive an alarm when they get close to it.

## Features

- **Set Destination:** Users can long-press on the map to set their destination.
- **Search:** Users can search for a location using the search bar.
- **Real-time Location Tracking:** The app tracks the user's current location in real-time.
- **Routing:** The app displays a route from the user's current location to the destination.
- **Distance Calculation:** The app calculates and displays the distance to the destination.
- **Location-based Alarm:** The app triggers an alarm when the user is within a specified distance of the destination.
- **Customizable Alarm:** Users can customize the alarm settings, including the alert distance, vibration, and sound.



## Dependencies

- `flutter_map`: For the interactive map.
- `geolocator`: For tracking the user's location.
- `audioplayers`: For playing the alarm sound.
- `permission_handler`: For handling location and notification permissions.
- `http`: For making API requests to the geocoding and routing services.
- `latlong2`: For handling latitude and longitude data.

## Services Used

- **OpenStreetMap:** For the map tiles.
- **Nominatim:** For geocoding (searching for locations).
- **OSRM (Open Source Routing Machine):** For generating the route.

## How to Use

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/location-alarm-app.git
   ```
2. **Install dependencies:**
    ```bash
    flutter pub get
    ```
3. **Run the app:**
    ```bash
    flutter run
    ```

## Project Structure

The project is structured as follows:

- `lib/`: Contains the main source code of the application.
  - `main.dart`: The entry point of the application.
  - `models/`: Contains the data models for the application (e.g., `AlarmSettings`, `LocationData`).
  - `screens/`: Contains the UI screens of the application (e.g., `MapScreen`).
  - `services/`: Contains the services that handle the business logic of the application (e.g., `LocationService`, `AlarmService`).
  - `widgets/`: Contains the reusable UI widgets of the application (e.g., `ControlPanel`).
- `assets/`: Contains the assets of the application (e.g., images, sounds).
- `test/`: Contains the tests for the application.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
