# SilentID Playwright Capture Service

Screenshot capture service for SilentID profile verification. Captures marketplace profiles for Token-in-Bio verification and profile extraction.

## Requirements

- Node.js 18+
- npm or yarn

## Installation

```bash
cd services/playwright-capture
npm install
npm run install-browsers
```

## Running the Service

### Development
```bash
npm run dev
```

### Production
```bash
npm start
```

## OS-Level Deployment (No Docker)

### macOS (launchd)

Create `/Library/LaunchDaemons/com.silentid.playwright-capture.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.silentid.playwright-capture</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/node</string>
        <string>/path/to/services/playwright-capture/index.js</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/var/log/silentid-capture.log</string>
    <key>StandardErrorPath</key>
    <string>/var/log/silentid-capture.error.log</string>
</dict>
</plist>
```

Then:
```bash
sudo launchctl load /Library/LaunchDaemons/com.silentid.playwright-capture.plist
```

### Linux (systemd)

Create `/etc/systemd/system/silentid-capture.service`:

```ini
[Unit]
Description=SilentID Playwright Capture Service
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/path/to/services/playwright-capture
ExecStart=/usr/bin/node index.js
Restart=on-failure
RestartSec=10
Environment=NODE_ENV=production
Environment=PORT=3000

[Install]
WantedBy=multi-user.target
```

Then:
```bash
sudo systemctl daemon-reload
sudo systemctl enable silentid-capture
sudo systemctl start silentid-capture
```

### Windows (NSSM)

1. Download NSSM from https://nssm.cc/
2. Run:
```cmd
nssm install SilentIDCapture "C:\Program Files\nodejs\node.exe" "C:\path\to\services\playwright-capture\index.js"
nssm start SilentIDCapture
```

### PM2 (Cross-platform)

```bash
npm install -g pm2
pm2 start index.js --name silentid-capture
pm2 save
pm2 startup
```

## API Endpoints

### GET /health

Health check endpoint.

**Response:**
```json
{
  "status": "healthy",
  "service": "silentid-playwright-capture",
  "timestamp": "2024-01-15T10:30:00.000Z"
}
```

### POST /capture

Capture screenshots from a marketplace profile.

**Request Body:**
```json
{
  "url": "https://www.vinted.co.uk/member/12345678",
  "mode": "TOKEN_IN_BIO",
  "token": "SILENTID-VERIFY-ABC12345",
  "maxScreenshots": 3,
  "viewport": { "width": 1280, "height": 800 }
}
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| url | string | Yes | Profile URL to capture |
| mode | string | Yes | `PROFILE_EXTRACTION` or `TOKEN_IN_BIO` |
| token | string | Conditional | Required for TOKEN_IN_BIO mode |
| maxScreenshots | number | No | Max screenshots (1-3, default 3) |
| viewport | object | No | Custom viewport dimensions |

**Response:**
```json
{
  "success": true,
  "sessionId": "1705312200000-abc123",
  "platform": "vinted",
  "mode": "TOKEN_IN_BIO",
  "screenshots": [
    {
      "name": "main_profile",
      "filename": "1705312200000-abc123-1-main.png",
      "timestamp": "2024-01-15T10:30:00.000Z"
    }
  ],
  "screenshotsDir": "/path/to/screenshots",
  "tokenVerification": {
    "token": "SILENTID-VERIFY-ABC12345",
    "found": true,
    "location": "bio"
  },
  "profileData": {
    "pageTitle": "User Profile | Vinted",
    "url": "https://www.vinted.co.uk/member/12345678",
    "username": "seller_name"
  },
  "capturedAt": "2024-01-15T10:30:02.000Z"
}
```

## Supported Platforms

- Vinted (.com, .co.uk, .fr, .de, .es, .it, .pl, .lt, .cz, .nl, .be, .at, .pt)
- eBay (.com, .co.uk, .de, .fr, .es, .it, .com.au)
- Depop
- Etsy
- Poshmark

## Screenshot Storage

Screenshots are stored in `./screenshots/` directory with naming convention:
- `{sessionId}-1-main.png` - Main profile view
- `{sessionId}-2-reviews.png` - Reviews/Feedback tab
- `{sessionId}-3-scrolled.png` - Scrolled content view

## Security Notes

- Service should only be accessible from your backend (localhost or internal network)
- Do not expose this service to the public internet
- Screenshots contain user data - handle with GDPR compliance
