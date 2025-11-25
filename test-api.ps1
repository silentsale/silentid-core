# SilentID API Test Script
# Tests Email OTP authentication flow end-to-end

$baseUrl = "http://localhost:5249"
$testEmail = "test@silentid.test"

Write-Host "=== SilentID API End-to-End Test ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Health Check
Write-Host "Test 1: Health Check" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/health" -Method GET
    Write-Host "  ✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "  ✓ Response: $($response.Content)" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 2: Request OTP
Write-Host "Test 2: Request OTP" -ForegroundColor Yellow
try {
    $body = @{
        email = $testEmail
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$baseUrl/v1/auth/request-otp" -Method POST `
        -Body $body -ContentType "application/json"

    Write-Host "  ✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "  ✓ Response: $($response.Content)" -ForegroundColor Green
    Write-Host "  ! Check backend logs for OTP code" -ForegroundColor Cyan
} catch {
    Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $responseBody = $reader.ReadToEnd()
        Write-Host "  ✗ Error details: $responseBody" -ForegroundColor Red
    }
}
Write-Host ""

# Test 3: Verify OTP (will fail without actual OTP from logs)
Write-Host "Test 3: Verify OTP (using test code 123456)" -ForegroundColor Yellow
Write-Host "  ! Note: This will fail unless you use the actual OTP from backend logs" -ForegroundColor Cyan
try {
    $body = @{
        email = $testEmail
        otp = "123456"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$baseUrl/v1/auth/verify-otp" -Method POST `
        -Body $body -ContentType "application/json"

    $result = $response.Content | ConvertFrom-Json
    Write-Host "  ✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "  ✓ Access Token: $($result.access_token.Substring(0,20))..." -ForegroundColor Green
    Write-Host "  ✓ Refresh Token: $($result.refresh_token.Substring(0,20))..." -ForegroundColor Green

    # Save tokens for next tests
    $global:accessToken = $result.access_token
    $global:refreshToken = $result.refresh_token

} catch {
    Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $reader.BaseStream.Position = 0
        $reader.DiscardBufferedData()
        $responseBody = $reader.ReadToEnd()
        Write-Host "  ✗ Error details: $responseBody" -ForegroundColor Red
    }
}
Write-Host ""

# Test 4: Get User Profile (requires valid token)
if ($global:accessToken) {
    Write-Host "Test 4: Get User Profile" -ForegroundColor Yellow
    try {
        $headers = @{
            Authorization = "Bearer $global:accessToken"
        }
        $response = Invoke-WebRequest -Uri "$baseUrl/v1/users/me" -Method GET -Headers $headers

        Write-Host "  ✓ Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "  ✓ Profile: $($response.Content)" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""

    # Test 5: Get TrustScore
    Write-Host "Test 5: Get TrustScore" -ForegroundColor Yellow
    try {
        $headers = @{
            Authorization = "Bearer $global:accessToken"
        }
        $response = Invoke-WebRequest -Uri "$baseUrl/v1/trustscore/me" -Method GET -Headers $headers

        Write-Host "  ✓ Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "  ✓ TrustScore: $($response.Content)" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""

    # Test 6: Refresh Token
    Write-Host "Test 6: Refresh Token" -ForegroundColor Yellow
    try {
        $body = @{
            refreshToken = $global:refreshToken
        } | ConvertTo-Json

        $response = Invoke-WebRequest -Uri "$baseUrl/v1/auth/refresh" -Method POST `
            -Body $body -ContentType "application/json"

        $result = $response.Content | ConvertFrom-Json
        Write-Host "  ✓ Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "  ✓ New Access Token: $($result.access_token.Substring(0,20))..." -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""

    # Test 7: Logout
    Write-Host "Test 7: Logout" -ForegroundColor Yellow
    try {
        $headers = @{
            Authorization = "Bearer $global:accessToken"
        }
        $response = Invoke-WebRequest -Uri "$baseUrl/v1/auth/logout" -Method POST -Headers $headers

        Write-Host "  ✓ Status: $($response.StatusCode)" -ForegroundColor Green
        Write-Host "  ✓ Logged out successfully" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
    Write-Host ""
}

# Test 8: Public Profile (no auth required)
Write-Host "Test 8: Public Profile" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/v1/public/profile/testuser" -Method GET
    Write-Host "  ✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "  ✓ Response: $($response.Content)" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 404) {
        Write-Host "  ✓ Expected 404 (user not found) - endpoint working" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}
Write-Host ""

# Test 9: Error Handling - Invalid Email
Write-Host "Test 9: Error Handling - Invalid Email" -ForegroundColor Yellow
try {
    $body = @{
        email = "invalid-email"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$baseUrl/v1/auth/request-otp" -Method POST `
        -Body $body -ContentType "application/json"

    Write-Host "  ✗ Should have failed with 400 Bad Request" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 400) {
        Write-Host "  ✓ Correctly returned 400 Bad Request" -ForegroundColor Green
    } else {
        Write-Host "  ~ Returned: $($_.Exception.Response.StatusCode)" -ForegroundColor Yellow
    }
}
Write-Host ""

Write-Host "=== Test Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Check backend logs for actual OTP codes" -ForegroundColor White
Write-Host "2. Re-run Test 3 with real OTP to complete authentication flow" -ForegroundColor White
Write-Host "3. Check database for created user records" -ForegroundColor White
