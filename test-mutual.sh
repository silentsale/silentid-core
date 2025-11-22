#!/bin/bash

# Extract token
TOKEN1="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI3NjA3NTBmNy02OTAwLTQ2YmUtYmI1Zi00YzM3ZWEzODBkYjgiLCJlbWFpbCI6Im11dHVhbC10ZXN0QHNpbGVudGlkLnRlc3QiLCJ1c2VybmFtZSI6Im11dHVhbHRlc3QxMDI0IiwiZGlzcGxheV9uYW1lIjoibXV0dWFsdGVzdDEwMjQiLCJhY2NvdW50X3R5cGUiOiJGcmVlIiwiYWNjb3VudF9zdGF0dXMiOiJBY3RpdmUiLCJlbWFpbF92ZXJpZmllZCI6IlRydWUiLCJqdGkiOiJlMzIyOTdhOS0wOTM0LTQ4ZjItYjA5NS1iYTFkM2FmOTY1MmUiLCJpYXQiOjE3NjM3OTcxODQsImV4cCI6MTc2Mzc5ODA4NCwiaXNzIjoic2lsZW50aWQtYXBpIiwiYXVkIjoic2lsZW50aWQtYXBwIn0.gZy6LUNmkugD_gxEDbFXjhsWnvT4z0kmKEI78wENnls"

echo "=== Testing Mutual Verification Endpoints ==="
echo ""

# Create second user
echo "1. Creating second test user..."
curl -s -X POST http://localhost:5249/v1/auth/request-otp \
  -H "Content-Type: application/json" \
  -d '{"email":"mutual-test2@silentid.test"}' > /dev/null

sleep 2
OTP2=$(tail -50 /tmp/silentid-api.log | grep "OTP CODE FOR mutual-test2" | tail -1 | awk '{print $(NF-3)}')

curl -s -X POST http://localhost:5249/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d "{
    \"email\":\"mutual-test2@silentid.test\",
    \"otp\":\"$OTP2\",
    \"deviceId\":\"test-device-2\",
    \"deviceModel\":\"Test Device 2\"
  }" > /tmp/auth2.json

echo "   User 2 created successfully"
echo ""

# Test 1: Create mutual verification
echo "2. Creating mutual verification request..."
curl -s -X POST http://localhost:5249/v1/mutual-verifications \
  -H "Authorization: Bearer $TOKEN1" \
  -H "Content-Type: application/json" \
  -d '{
    "otherUserIdentifier": "mutual-test2@silentid.test",
    "item": "Nike Air Max Shoes",
    "amount": 85.00,
    "currency": "GBP",
    "yourRole": 0,
    "date": "2025-11-20T00:00:00Z"
  }' | python3 -m json.tool

echo ""

# Test 2: Get all verifications
echo "3. Getting all verifications..."
curl -s http://localhost:5249/v1/mutual-verifications \
  -H "Authorization: Bearer $TOKEN1" | python3 -m json.tool

echo ""

# Test 3: Get incoming requests (as User 2)
TOKEN2=$(grep accessToken /tmp/auth2.json | grep -o 'eyJ[^"]*')
echo "4. Getting incoming requests (User 2)..."
curl -s http://localhost:5249/v1/mutual-verifications/incoming \
  -H "Authorization: Bearer $TOKEN2" | python3 -m json.tool

echo ""
echo "=== Tests Complete ===="
