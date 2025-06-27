# Mobile Backend Information

## Authentication APIs

Authentication is handled via JWT (JSON Web Tokens).

### Register a new user
```
POST /api/auth/register
Body: {
  "name": "User Name",
  "email": "user@example.com",
  "phone": "0771234567",
  "password": "password123"
}
```

### Login
```
POST /api/auth/login
Body: {
  "email": "user@example.com",
  "password": "password123"
}
```

## Vehicle Management

### Get all user vehicles
```
GET /api/vehicles
Headers: {
  "Authorization": "Bearer {token}"
}
```

### Create a new vehicle
```
POST /api/vehicles
Headers: {
  "Authorization": "Bearer {token}"
}
Body: {
  "vehicleNumber": "ABC-1234",
  "make": "Toyota",
  "model": "Corolla",
  "year": 2022,
  "type": "Car",
  "color": "White",
  "fuelType": "Petrol",
  "transmission": "Automatic"
}
```

## Service Appointments

### Create a service appointment
```
POST /api/services
Headers: {
  "Authorization": "Bearer {token}"
}
Body: {
  "vehicleId": "vehicleId",
  "serviceType": "Regular Service",
  "appointmentDate": "2023-08-15T10:00:00Z",
  "notes": "Regular maintenance"
}
```

### Get all user appointments
```
GET /api/services
Headers: {
  "Authorization": "Bearer {token}"
}
```

## Backend Setup

1. Install dependencies:
   ```
   npm install
   ```

2. Start the server:
   ```
   npm run dev
   ```

3. Seed the database:
   ```
   node src/config/seeder.js -i
   ```

4. Access the API at:
   ```
   http://localhost:5000/api
   ```
