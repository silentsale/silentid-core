const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

// Platform detection patterns
const PLATFORM_PATTERNS = {
  vinted: {
    match: /vinted\.(com|co\.uk|fr|de|es|it|pl|lt|cz|nl|be|at|pt)/,
    reviewsTab: '[data-testid="profile-reviews-tab"], a[href*="reviews"]',
    bioSelector: '[data-testid="user-about"], .user-about, .profile-about'
  },
  ebay: {
    match: /ebay\.(com|co\.uk|de|fr|es|it|com\.au)/,
    feedbackTab: 'a[href*="feedback"]',
    bioSelector: '.str-seller-card__info, .seller-info'
  },
  depop: {
    match: /depop\.com/,
    reviewsTab: 'a[href*="reviews"], button[data-testid="reviews-tab"]',
    bioSelector: '[data-testid="seller-bio"], .seller-bio'
  },
  etsy: {
    match: /etsy\.com/,
    reviewsTab: 'a[href*="reviews"]',
    bioSelector: '.shop-info, .seller-about'
  },
  poshmark: {
    match: /poshmark\.com/,
    ratingsTab: 'a[href*="ratings"]',
    bioSelector: '.user-profile__bio'
  }
};

// Detect platform from URL
function detectPlatform(url) {
  for (const [name, config] of Object.entries(PLATFORM_PATTERNS)) {
    if (config.match.test(url)) {
      return { name, config };
    }
  }
  return { name: 'unknown', config: {} };
}

// Ensure screenshots directory exists
function ensureScreenshotsDir() {
  const dir = path.join(__dirname, '..', 'screenshots');
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  return dir;
}

// Main capture function
async function capture(url, mode, token, maxScreenshots, viewport) {
  const screenshotsDir = ensureScreenshotsDir();
  const platform = detectPlatform(url);
  const sessionId = `${Date.now()}-${Math.random().toString(36).substring(7)}`;
  const screenshots = [];

  const defaultViewport = { width: 1280, height: 800 };
  const finalViewport = viewport || defaultViewport;

  let browser;
  try {
    browser = await chromium.launch({
      headless: true,
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    const context = await browser.newContext({
      viewport: finalViewport,
      userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
    });

    const page = await context.newPage();

    // Navigate to profile URL
    await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });
    await page.waitForTimeout(2000); // Allow dynamic content to load

    // Screenshot 1: Main profile page
    const mainScreenshot = path.join(screenshotsDir, `${sessionId}-1-main.png`);
    await page.screenshot({ path: mainScreenshot, fullPage: false });
    screenshots.push({
      name: 'main_profile',
      path: mainScreenshot,
      timestamp: new Date().toISOString()
    });

    // Screenshot 2: Reviews/Feedback tab (if available and within limit)
    if (maxScreenshots >= 2 && platform.config.reviewsTab) {
      try {
        const reviewsSelector = platform.config.reviewsTab || platform.config.feedbackTab || platform.config.ratingsTab;
        const reviewsTab = await page.$(reviewsSelector);
        if (reviewsTab) {
          await reviewsTab.click();
          await page.waitForTimeout(2000);

          const reviewsScreenshot = path.join(screenshotsDir, `${sessionId}-2-reviews.png`);
          await page.screenshot({ path: reviewsScreenshot, fullPage: false });
          screenshots.push({
            name: 'reviews_tab',
            path: reviewsScreenshot,
            timestamp: new Date().toISOString()
          });
        }
      } catch (e) {
        console.log('Could not capture reviews tab:', e.message);
      }
    }

    // Screenshot 3: Scrolled view or bio section (if within limit)
    if (maxScreenshots >= 3) {
      try {
        // Go back to main profile if we navigated
        if (screenshots.length > 1) {
          await page.goto(url, { waitUntil: 'networkidle', timeout: 30000 });
          await page.waitForTimeout(1500);
        }

        // Scroll down to capture more content
        await page.evaluate(() => window.scrollBy(0, 500));
        await page.waitForTimeout(1000);

        const scrolledScreenshot = path.join(screenshotsDir, `${sessionId}-3-scrolled.png`);
        await page.screenshot({ path: scrolledScreenshot, fullPage: false });
        screenshots.push({
          name: 'scrolled_view',
          path: scrolledScreenshot,
          timestamp: new Date().toISOString()
        });
      } catch (e) {
        console.log('Could not capture scrolled view:', e.message);
      }
    }

    // Token verification (for TOKEN_IN_BIO mode)
    let tokenFound = false;
    let tokenLocation = null;

    if (mode === 'TOKEN_IN_BIO' && token) {
      const pageContent = await page.content();
      tokenFound = pageContent.includes(token);

      if (tokenFound && platform.config.bioSelector) {
        try {
          const bioElement = await page.$(platform.config.bioSelector);
          if (bioElement) {
            const bioText = await bioElement.textContent();
            if (bioText && bioText.includes(token)) {
              tokenLocation = 'bio';
            }
          }
        } catch (e) {
          // Token found in page but couldn't pinpoint location
          tokenLocation = 'page_content';
        }
      }
    }

    // Extract basic profile data
    let profileData = {};
    try {
      profileData = await page.evaluate(() => {
        const getText = (selectors) => {
          for (const sel of selectors) {
            const el = document.querySelector(sel);
            if (el) return el.textContent.trim();
          }
          return null;
        };

        return {
          pageTitle: document.title,
          url: window.location.href,
          username: getText([
            '[data-testid="username"]',
            '.username',
            '.profile-name',
            'h1',
            '.seller-name'
          ])
        };
      });
    } catch (e) {
      console.log('Could not extract profile data:', e.message);
    }

    await browser.close();

    return {
      success: true,
      sessionId,
      platform: platform.name,
      mode,
      screenshots: screenshots.map(s => ({
        name: s.name,
        filename: path.basename(s.path),
        timestamp: s.timestamp
      })),
      screenshotsDir,
      tokenVerification: mode === 'TOKEN_IN_BIO' ? {
        token,
        found: tokenFound,
        location: tokenLocation
      } : null,
      profileData,
      capturedAt: new Date().toISOString()
    };

  } catch (error) {
    if (browser) {
      await browser.close();
    }
    throw error;
  }
}

module.exports = { capture, detectPlatform };
