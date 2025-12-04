const express = require('express');
const cors = require('cors');
const captureService = require('./services/captureService');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: 'silentid-playwright-capture',
    timestamp: new Date().toISOString()
  });
});

// Capture endpoint
app.post('/capture', async (req, res) => {
  try {
    const { url, mode, token, maxScreenshots = 3, viewport } = req.body;

    // Validate required fields
    if (!url) {
      return res.status(400).json({ error: 'url is required' });
    }

    if (!mode || !['PROFILE_EXTRACTION', 'TOKEN_IN_BIO'].includes(mode)) {
      return res.status(400).json({
        error: 'mode is required and must be PROFILE_EXTRACTION or TOKEN_IN_BIO'
      });
    }

    if (mode === 'TOKEN_IN_BIO' && !token) {
      return res.status(400).json({
        error: 'token is required for TOKEN_IN_BIO mode'
      });
    }

    // Enforce max screenshots limit
    const screenshotLimit = Math.min(maxScreenshots, 3);

    // Call capture service
    const result = await captureService.capture(url, mode, token, screenshotLimit, viewport);

    res.json(result);
  } catch (error) {
    console.error('Capture error:', error);
    res.status(500).json({
      error: 'Capture failed',
      message: error.message
    });
  }
});

app.listen(PORT, () => {
  console.log(`SilentID Playwright Capture Service running on port ${PORT}`);
});
