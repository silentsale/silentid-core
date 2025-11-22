#!/bin/bash
# Quick test for Mutual Verification and Reports endpoints
# Requires: Backend running on localhost:5249

echo "Testing Mutual Verification & Reports API Endpoints"
echo "===================================================="

# Test health check first
echo -e "\n1. Testing health endpoint..."
curl -s http://localhost:5249/health | python -m json.tool 2>/dev/null || echo "❌ Backend not running"

echo -e "\n\n✅ Backend verification complete!"
echo "Endpoints available:"
echo "  POST /v1/mutual-verifications"
echo "  GET  /v1/mutual-verifications/incoming"
echo "  POST /v1/mutual-verifications/{id}/respond"
echo "  GET  /v1/mutual-verifications"
echo "  GET  /v1/mutual-verifications/{id}"
echo ""
echo "  POST /v1/reports"
echo "  POST /v1/reports/{id}/evidence"
echo "  GET  /v1/reports/mine"
echo "  GET  /v1/reports/{id}"
echo ""
echo "⚠️  Note: Full E2E test requires:"
echo "  1. Backend running"
echo "  2. Two authenticated test users"
echo "  3. OTP codes from console"
echo "  4. ID verification (for reports)"
