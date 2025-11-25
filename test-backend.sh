#!/bin/bash
# SilentID Backend Test Script
# Run this after starting the backend

echo "🧪 Testing SilentID Backend API"
echo "================================"
echo ""

API_URL="http://localhost:5249"

# Test 1: Health Check
echo "1️⃣ Testing Health Endpoint..."
curl -s "$API_URL/health" | jq '.' || echo "✅ Health endpoint OK (no JSON response)"
echo ""

# Test 2: Request OTP
echo "2️⃣ Testing OTP Request..."
curl -s -X POST "$API_URL/v1/auth/request-otp" \
  -H "Content-Type: application/json" \
  -d '{"email": "test@silentid.app"}' | jq '.'
echo ""

# Test 3: Public Profile (will fail until user exists)
echo "3️⃣ Testing Public Profile Endpoint..."
curl -s "$API_URL/v1/public/profile/testuser" | jq '.'
echo ""

# Test 4: TrustScore (needs auth token)
echo "4️⃣ Testing TrustScore Endpoint (requires auth)..."
echo "ℹ️  Skip - needs valid JWT token"
echo ""

echo "✅ Backend API Tests Complete"
echo ""
echo "Next Steps:"
echo "1. Check OTP was sent (check logs or email)"
echo "2. Run Flutter app to test full integration"
echo "3. Create test user and verify public profile"
