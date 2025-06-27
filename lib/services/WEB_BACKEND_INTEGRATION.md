# Migrating from Standalone Backend to Web Backend Integration

This document explains how the SachiR Vehicle Care mobile app has been migrated from its standalone backend to use the existing web backend.

## Backend Migration

### Previous Backend (Deprecated)
* Location: `e:\Software Development Project -New\SachiR_Vehicle_Care_Mobile_Backend`
* Technology: Node.js, Express, MongoDB
* Status: No longer used

### Current Web Backend 
* Location: `e:\Software Development Project -New\Backend_Web`
* Technology: Node.js, Express, MySQL, Sequelize ORM
* Status: Active - serving both web and mobile applications

## Services Updated for Migration

The following services have been updated to use the web backend:

1. **ApiService**: Updated with mobile API key header
   - Added: `X-Mobile-Api-Key` header required by web backend
   - Modified: Base URL points to web backend server

2. **AuthService**: Authentication uses web backend endpoints
   - Login: `/api/auth/login`
   - Registration: `/api/auth/register`
   - Get Profile: `/api/auth/me`

3. **VehicleService**: Migrated to mobile-specific endpoints
   - Get vehicles: `/api/mobile/vehicles`
   - Get vehicle details: `/api/mobile/vehicles/:id`
   - Create vehicle: `/api/mobile/vehicles`
   - Update vehicle: `/api/mobile/vehicles/:id`
   - Delete vehicle: `/api/mobile/vehicles/:id`
   - Get vehicle service history: `/api/mobile/vehicles/:id/service-history`

4. **AppointmentService**: Updated to use bookings endpoints
   - Get appointments: `/api/mobile/bookings`
   - Create appointment: `/api/mobile/bookings`
   - Update appointment: `/api/mobile/bookings/:id`
   - Cancel appointment: `/api/mobile/bookings/:id/cancel`
   - Get available slots: `/api/mobile/bookings/available-slots`

5. **ServiceService**: New service to handle workshop services
   - Get services: `/api/mobile/services`
   - Get service by ID: `/api/mobile/services/:id`
   - Get service categories: `/api/mobile/services/categories`

## Key Changes

### 1. Authentication Flow
- The authentication process remains similar but uses the web backend structure
- The JWT token handling is the same, but now includes the mobile API key header
- All authenticated requests include:
  - The JWT token in the `Authorization` header
  - The mobile API key in the `X-Mobile-Api-Key` header

### 2. Data Models Adjustment
- Previous: MongoDB document-style models
- Current: MySQL/Sequelize ORM models with structured schema 
- Model name changes:
  - `appointments` → `bookings`
  - Service records are now linked properly to the vehicles

### 3. Configuration Updates
- Updated `app_config.dart`:
  ```dart
  // Changed API URL to point to web backend
  static const String devApiUrl = 'http://10.0.2.2:8000/api';
  
  // Added mobile API prefix
  static const String mobileApiPrefix = '/mobile';
  ```

- Updated API service headers:
  ```dart
  // Added mobile API key header
  headers = const {
    'Content-Type': 'application/json',
    'X-Mobile-Api-Key': 'sachir_mobile_app_secret_key',
  }
  ```

## Advantages of Integration
1. **Shared Database**: Both web and mobile apps use the same data source
2. **Consistent Business Logic**: Service rules are applied consistently
3. **Simplified Maintenance**: Only one backend to maintain
4. **Synchronized Features**: New features are available on both platforms

## Testing the Integration
1. Test all authentication flows
2. Verify vehicle CRUD operations
3. Test appointment/booking creation and management
4. Ensure service listings are displayed correctly
3. Maintain backward compatibility for mobile API endpoints
4. Update mobile app configurations when API changes occur

## Security Considerations

1. The mobile API key (`MOBILE_APP_API_KEY`) should be properly secured in production
2. JWT authentication ensures users only access their own data
3. All requests should use HTTPS in production
