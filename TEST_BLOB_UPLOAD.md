# Azure Blob Storage Upload Test Guide

## Quick Test Instructions

### Test 1: Verify Service Works (Local Storage Mode)

**Prerequisites:**
- SilentID API running
- User authenticated (have JWT token)

**Test Steps:**

1. **Start the API:**
   ```bash
   cd C:/SILENTID/src/SilentID.Api
   dotnet run
   ```

2. **Create a test image file:**
   - Create any small PNG/JPEG image (e.g., screenshot.png)
   - File should be < 10MB

3. **Upload via API:**
   ```bash
   curl -X POST http://localhost:5000/v1/evidence/screenshots \
     -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     -F "file=@path/to/screenshot.png" \
     -F "platform=Vinted" \
     -F "ocrText=Test OCR text"
   ```

4. **Expected Response:**
   ```json
   {
     "id": "some-guid",
     "fileUrl": "local://[guid]_screenshot.png",
     "platform": "Vinted",
     "integrityScore": 85,
     "evidenceState": "Valid",
     "createdAt": "2025-11-23T..."
   }
   ```

5. **Verify File Saved:**
   ```bash
   ls C:/SILENTID/src/SilentID.Api/LocalStorage/evidence/
   ```

   You should see a file like: `[guid]_screenshot.png`

### Test 2: Verify Receipt Upload

```bash
curl -X POST http://localhost:5000/v1/evidence/receipts/manual \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "platform": "Vinted",
    "orderId": "TEST123",
    "item": "Vintage Jacket",
    "amount": 45.99,
    "currency": "GBP",
    "role": "Buyer",
    "date": "2025-11-20T10:00:00Z"
  }'
```

### Test 3: Retrieve Screenshot

```bash
curl -X GET http://localhost:5000/v1/evidence/screenshots/{screenshot-id} \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Expected Behavior

### Local Storage Mode (Default)
- Files saved to: `src/SilentID.Api/LocalStorage/evidence/`
- File URLs: `local://[guid]_[filename]`
- Console logs: "📁 FILE: Saved to local storage: [path]"

### Azure Mode (When Configured)
- Files uploaded to Azure Blob Storage
- File URLs: `https://[storage].blob.core.windows.net/evidence/[guid]_[filename]`
- Console logs: "File uploaded to Azure Blob Storage: [blobname]"

## Troubleshooting

### Issue: "Invalid user ID in token"
- **Cause:** Not authenticated or invalid JWT
- **Solution:** Ensure you have a valid JWT token from login

### Issue: "Invalid file type"
- **Cause:** Trying to upload non-image file
- **Solution:** Use only JPEG, PNG, or WebP images

### Issue: "File too large"
- **Cause:** File exceeds 10MB limit
- **Solution:** Use a smaller file

### Issue: LocalStorage directory not found
- **Cause:** Directory not created yet
- **Solution:** Normal! Directory is created on first upload automatically

## Testing with Postman

1. Create a new POST request to: `http://localhost:5000/v1/evidence/screenshots`
2. Set Authorization: Bearer Token (use your JWT)
3. Set Body type: form-data
4. Add fields:
   - `file` (type: File) - select an image
   - `platform` (type: Text) - value: `Vinted`
   - `ocrText` (type: Text, optional) - value: `Test text`
5. Send request
6. Verify response contains `fileUrl` field

## Production Setup (Azure)

When deploying to production:

1. Create Azure Storage Account
2. Get connection string
3. Update production configuration:
   ```json
   "AzureStorage": {
     "ConnectionString": "DefaultEndpointsProtocol=https;AccountName=...",
     "EvidenceContainer": "evidence"
   }
   ```
4. Restart API
5. Verify logs show: "Azure Blob Storage service initialized"

## Success Indicators

✅ Build completes without errors
✅ API starts successfully
✅ File upload returns 201 Created
✅ Response contains valid fileUrl
✅ File exists in LocalStorage/evidence/ (local mode)
✅ Screenshot can be retrieved via GET endpoint
✅ No error logs in console

---

**Status:** Ready for testing
**Mode:** Local storage (no Azure required for development)
**Next Step:** Test upload with a real authenticated user
