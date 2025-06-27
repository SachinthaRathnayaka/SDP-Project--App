# test_web_backend_connection.ps1
# Tests the connection between the mobile app and web backend

# Set variables
$WEB_BACKEND_URL = "http://localhost:8000/api"
$MOBILE_API_KEY = "sachir_mobile_app_secret_key"
$EMAIL = "test@example.com"
$PASSWORD = "password123"

Write-Host "===== TESTING WEB BACKEND CONNECTION =====" -ForegroundColor Cyan
Write-Host "Testing connection to: $WEB_BACKEND_URL"
Write-Host ""

# 1. Test basic connection
Write-Host "1. Testing basic connection..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$WEB_BACKEND_URL/health-check" -Method GET -ErrorAction Stop
    Write-Host "Status code: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "Failed to connect to backend. Status code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
}
Write-Host ""

# 2. Test mobile API key
Write-Host "2. Testing mobile API key validation..." -ForegroundColor Yellow
try {
    $headers = @{
        "X-Mobile-Api-Key" = $MOBILE_API_KEY
    }
    $response = Invoke-WebRequest -Uri "$WEB_BACKEND_URL/mobile/services" -Headers $headers -Method GET -ErrorAction Stop
    Write-Host "Status code: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "Mobile API key validation failed. Status code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
}
Write-Host ""

# 3. Test authentication
Write-Host "3. Testing user authentication..." -ForegroundColor Yellow
$authBody = @{
    email = $EMAIL
    password = $PASSWORD
} | ConvertTo-Json

try {
    $authResponse = Invoke-WebRequest -Uri "$WEB_BACKEND_URL/auth/login" -Method POST -Body $authBody -ContentType "application/json" -ErrorAction Stop
    $authData = $authResponse.Content | ConvertFrom-Json
    $token = $authData.token
    
    if ($token) {
        Write-Host "Authentication successful. Token retrieved." -ForegroundColor Green
        
        # 4. Test authenticated endpoint
        Write-Host ""
        Write-Host "4. Testing authenticated endpoint (user profile)..." -ForegroundColor Yellow
        $authHeaders = @{
            "Authorization" = "Bearer $token"
            "X-Mobile-Api-Key" = $MOBILE_API_KEY
        }
        
        try {
            $profileResponse = Invoke-WebRequest -Uri "$WEB_BACKEND_URL/auth/me" -Headers $authHeaders -Method GET -ErrorAction Stop
            Write-Host "Status code: $($profileResponse.StatusCode)" -ForegroundColor Green
        } catch {
            Write-Host "Failed to access authenticated endpoint. Status code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
        }
    } else {
        Write-Host "Authentication failed. Could not retrieve token." -ForegroundColor Red
    }
} catch {
    Write-Host "Authentication failed. Status code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
}

Write-Host ""
Write-Host "===== TEST COMPLETED =====" -ForegroundColor Cyan
