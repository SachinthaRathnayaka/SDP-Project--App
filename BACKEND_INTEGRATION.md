# SachiR Vehicle Care - Mobile App Backend Integration

This document outlines how to set up and connect the SachiR Vehicle Care mobile application with the web application backend server.

## Project Structure

The project consists of two main components:

1. **Mobile App Frontend** (Flutter)
   - Path: `e:\Software Development Project -New\SachiR_Vehicle_Care`
   - Technologies: Flutter, Dart
   - Connects to the backend via REST API

2. **Web Application Backend** (Node.js)
   - Path: `e:\Software Development Project -New\Backend_Web`
   - Technologies: Node.js, Express, MySQL, Sequelize ORM
   - Provides REST API endpoints for both web and mobile applications via dedicated mobile routes

## Setup Instructions

### Web Backend Setup

1. Navigate to the web backend directory:
```
cd "e:\Software Development Project -New\Backend_Web"
```

2. Install dependencies:
```
npm install
```

3. Configure your MySQL database connection in `.env` file:
```
DB_HOST=localhost
DB_USER=your_username
DB_PASS=your_password
DB_NAME=sachir_vehicle_care
```

4. Run database migrations and seed data if needed (refer to web backend documentation for specific commands)

5. Start the backend server:
```
npm run dev
```

The web backend server will be running on `http://localhost:8000`.

### Frontend Setup

1. Navigate to the Flutter app directory:
```
cd "e:\Software Development Project -New\SachiR_Vehicle_Care"
```

2. Install Flutter dependencies:
```
flutter pub get
```

3. Ensure the web backend URL is correctly set in `lib/config/app_config.dart`:
```dart
// Backend API URLs
static const String devApiUrl = 'http://10.0.2.2:8000/api'; // For Android emulator
static const String prodApiUrl = 'https://api.sachir-vehicle-care.com/api';

// Mobile-specific routes
static const String mobileApiPrefix = '/mobile';
```

Note: `10.0.2.2` is the special IP that Android emulators use to connect to the host machine's localhost.

4. Ensure the mobile API key is correctly set in the API service:
```dart
// In api_service.dart
ApiService({
  required this.baseUrl,
  this.headers = const {
    'Content-Type': 'application/json',
    'X-Mobile-Api-Key': 'sachir_mobile_app_secret_key',
  },
});
```

5. Run the Flutter app:
```
flutter run
```

## API Documentation

See the web backend documentation for detailed API endpoints:
- `e:\Software Development Project -New\Backend_Web\README.md`

Mobile-specific API routes are available in:
- `e:\Software Development Project -New\Backend_Web\src\routes\mobile.routes.js`

## Mobile API Integration

### API Routes

The web backend provides dedicated routes for the mobile app under the `/mobile` prefix:

1. **Authentication**
   - The mobile app uses the same authentication endpoints as the web application
   - All mobile requests must include the `X-Mobile-Api-Key` header for security

2. **User Dashboard**
   - `GET /api/mobile/user-dashboard` - Get user dashboard data (vehicles, upcoming bookings)

3. **Vehicles**
   - `GET /api/mobile/vehicles` - Get user vehicles
   - `POST /api/mobile/vehicles` - Create a new vehicle
   - `GET /api/mobile/vehicles/:id` - Get vehicle details
   - `PUT /api/mobile/vehicles/:id` - Update vehicle
   - `DELETE /api/mobile/vehicles/:id` - Delete vehicle
   - `GET /api/mobile/vehicles/:id/service-history` - Get vehicle service history

4. **Services**
   - `GET /api/mobile/services` - Get available services

5. **Bookings/Appointments**
   - `GET /api/mobile/bookings` - Get user bookings
   - `POST /api/mobile/bookings` - Create a new booking
   - `GET /api/mobile/bookings/:id` - Get booking details
   - `PUT /api/mobile/bookings/:id` - Update booking
   - `PUT /api/mobile/bookings/:id/cancel` - Cancel booking
   - `GET /api/mobile/bookings/available-slots` - Get available booking slots

### Testing

For testing the mobile app with the web backend:

1. Use the test accounts configured in the web backend (refer to web backend documentation)
2. Or register a new account through the app
3. Verify that the X-Mobile-Api-Key is correctly configured in the app

## Important Notes

1. The standalone mobile backend at `e:\Software Development Project -New\SachiR_Vehicle_Care_Mobile_Backend` is no longer needed and can be deactivated.
2. All mobile app requests now go through the web backend's mobile-specific routes.
3. The data is shared between web and mobile applications through the common database.

## Understanding the Integration

The mobile app connects to the backend using:

1. **API Service** - Handles HTTP requests
2. **Auth Provider** - Manages authentication state
3. **Vehicle Provider** - Manages vehicle data
4. **Appointment Provider** - Manages service appointments

All API calls use the same backend that's shared with the web admin panel, ensuring data consistency across both platforms.
