#!/bin/bash
# test_web_backend_connection.sh
# Tests the connection between the mobile app and web backend

# Set variables
WEB_BACKEND_URL="http://localhost:8000/api"
MOBILE_API_KEY="sachir_mobile_app_secret_key"
EMAIL="test@example.com"
PASSWORD="password123"

echo "===== TESTING WEB BACKEND CONNECTION ====="
echo "Testing connection to: $WEB_BACKEND_URL"
echo ""

# 1. Test basic connection
echo "1. Testing basic connection..."
curl -s -o /dev/null -w "%{http_code}\n" $WEB_BACKEND_URL/health-check
echo ""

# 2. Test mobile API key
echo "2. Testing mobile API key validation..."
curl -s -H "X-Mobile-Api-Key: $MOBILE_API_KEY" -o /dev/null -w "%{http_code}\n" $WEB_BACKEND_URL/mobile/services
echo ""

# 3. Test authentication
echo "3. Testing user authentication..."
AUTH_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}" $WEB_BACKEND_URL/auth/login)
TOKEN=$(echo $AUTH_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "Authentication failed. Could not retrieve token."
  echo "Response: $AUTH_RESPONSE"
else
  echo "Authentication successful. Token retrieved."
  
  # 4. Test authenticated endpoint
  echo ""
  echo "4. Testing authenticated endpoint (user profile)..."
  curl -s -H "Authorization: Bearer $TOKEN" -H "X-Mobile-Api-Key: $MOBILE_API_KEY" -o /dev/null -w "%{http_code}\n" $WEB_BACKEND_URL/auth/me
fi

echo ""
echo "===== TEST COMPLETED ====="
