# MCP Server Automatic Reconnection Guide

**Date:** 2025-11-21
**Issue:** MCP servers (especially npx-based ones) failing to reconnect automatically

---

## 🔧 Immediate Solutions

### Option 1: Install MCP Servers Locally (RECOMMENDED)

Instead of using `npx` (which downloads each time), install servers locally for better stability.

**Benefits:**
- ✅ Faster startup (no download wait)
- ✅ More reliable reconnection
- ✅ Offline capability
- ✅ Consistent versions

**Commands to install problematic servers:**

```bash
# Create local MCP servers directory (if not exists)
mkdir -p C:\mcp-servers

# Install chrome-devtools locally
cd C:\mcp-servers
npm install -g @automatalabs/mcp-server-chrome

# Install other npx servers
npm install -g @modelcontextprotocol/server-github
npm install -g @modelcontextprotocol/server-sequential-thinking
npm install -g @modelcontextprotocol/server-puppeteer
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-postgres
npm install -g code-executor-mcp
```

---

### Option 2: Add Retry Logic to Config (SIMPLER)

Add environment variables to enable automatic retry for npx servers:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "@automatalabs/mcp-server-chrome"],
      "description": "Chrome DevTools integration",
      "env": {
        "MCP_RETRY_ATTEMPTS": "5",
        "MCP_RETRY_DELAY": "2000"
      }
    }
  }
}
```

---

### Option 3: Use Persistent Process Manager (ADVANCED)

Use PM2 or similar to keep MCP servers running as persistent processes:

```bash
# Install PM2
npm install -g pm2

# Start MCP server as persistent process
pm2 start npx --name chrome-devtools -- -y @automatalabs/mcp-server-chrome
pm2 save
pm2 startup
```

---

## 🎯 Recommended Fix for Your Setup

Based on your current configuration, here's the **best approach**:

### Step 1: Install Critical Servers Locally

Only install the servers you actually use frequently:

```bash
# Essential for SilentID development
cd C:\mcp-servers

# Install sequentia-thinking (you use this often)
npm install @modelcontextprotocol/server-sequential-thinking

# Install postgres (critical for database work)
npm install @modelcontextprotocol/server-postgres

# Keep chrome-devtools on npx (you rarely use it)
```

### Step 2: Update Configuration

**New configuration with local paths:**

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "node",
      "args": [
        "C:\\mcp-servers\\node_modules\\@modelcontextprotocol\\server-sequential-thinking\\dist\\index.js"
      ],
      "description": "Multi-step reasoning (LOCAL - auto-reconnects)"
    },
    "postgres": {
      "command": "node",
      "args": [
        "C:\\mcp-servers\\node_modules\\@modelcontextprotocol\\server-postgres\\dist\\index.js",
        "postgresql://postgres:password@localhost:5432/silentid_dev"
      ],
      "description": "PostgreSQL database (LOCAL - auto-reconnects)"
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "@automatalabs/mcp-server-chrome"],
      "description": "Chrome DevTools (NPX - may need manual restart)"
    }
  }
}
```

---

## 🚨 Why NPX Servers Don't Auto-Reconnect

**Technical Explanation:**

1. **NPX downloads packages temporarily** → Process lifecycle unclear
2. **No persistent PID** → System can't track/restart
3. **Network dependency** → Download failures = connection failures
4. **No retry built-in** → One failure = permanent disconnect

**Local installations solve all of these:**
- ✅ Known file path
- ✅ Persistent installation
- ✅ Faster startup
- ✅ Can be monitored by Claude Code

---

## 🔍 Diagnosing Connection Issues

**Check if MCP server is actually installed:**

```bash
# For npx servers (checks npm registry)
npm view @automatalabs/mcp-server-chrome

# For local servers (checks local installation)
dir "C:\mcp-servers\node_modules\@automatalabs\mcp-server-chrome"
```

**Test MCP server manually:**

```bash
# Test chrome-devtools
npx -y @automatalabs/mcp-server-chrome

# Test sequential-thinking
npx -y @modelcontextprotocol/server-sequential-thinking

# Should output: JSON-RPC communication or error message
```

**Check Claude Code MCP logs:**

```bash
# View recent MCP connection logs
type "C:\Users\Mr Smith\.claude\logs\mcp-connections.log"
```

---

## ⚡ Quick Fix (Right Now)

**If you just need chrome-devtools to work:**

```bash
# Manually restart the MCP server connection
# In Claude Code, type:
/mcp restart chrome-devtools
```

**Or restart all MCP servers:**

```bash
# Restart Claude Code completely
# Close all windows
# Reopen Claude Code
# Run: /mcp
```

---

## 🎯 Best Practice for SilentID Development

**Configure MCP servers by usage priority:**

### Tier 1: Install Locally (Always Available)
- `sequential-thinking` (complex reasoning)
- `postgres` (database access)
- `context7` (documentation)
- `playwright-mcp` (web scraping)

### Tier 2: Keep on NPX (Rarely Used)
- `chrome-devtools` (frontend debugging only)
- `puppeteer` (backup for playwright)
- `code-executor` (occasional testing)

### Tier 3: Remove if Unused
- `filesystem` (native tools work fine)
- `github` (use git CLI instead)

---

## 📋 Updated Configuration Template

**Save this as your new config:**

```json
{
  "mcpServers": {
    "code-index": {
      "command": "uv",
      "args": ["--directory", "C:\\mcp-servers\\code-index-mcp", "run", "code-index-mcp"],
      "description": "Codebase indexing and semantic search"
    },
    "context7": {
      "command": "node",
      "args": ["C:\\mcp-servers\\context7\\dist\\index.js"],
      "description": "Official documentation lookup"
    },
    "playwright-mcp": {
      "command": "node",
      "args": ["C:\\mcp-servers\\playwright-mcp\\index.js"],
      "description": "Browser automation and testing"
    },
    "sequential-thinking": {
      "command": "node",
      "args": ["C:\\mcp-servers\\node_modules\\@modelcontextprotocol\\server-sequential-thinking\\dist\\index.js"],
      "description": "Multi-step reasoning (LOCAL)"
    },
    "postgres": {
      "command": "node",
      "args": [
        "C:\\mcp-servers\\node_modules\\@modelcontextprotocol\\server-postgres\\dist\\index.js",
        "postgresql://postgres:password@localhost:5432/silentid_dev"
      ],
      "description": "PostgreSQL database (LOCAL)"
    }
  }
}
```

**Removed from config (use native tools instead):**
- ❌ `chrome-devtools` (use Chrome DevTools directly)
- ❌ `github` (use git CLI: `git`, `gh`)
- ❌ `code-executor` (use native bash or code execution)
- ❌ `puppeteer` (playwright covers this)
- ❌ `filesystem` (native file tools work)

---

## ✅ Action Plan

**Choose ONE approach:**

### Option A: Minimal Stable Setup (RECOMMENDED)
1. Install `sequential-thinking` and `postgres` locally
2. Remove rarely-used npx servers from config
3. Restart Claude Code
4. **Result:** 5 stable MCP servers, all auto-reconnect

### Option B: Keep Current Setup
1. Accept that npx servers may disconnect
2. Manually restart with `/mcp restart [server-name]`
3. **Result:** 10 MCP servers, some may need manual restart

### Option C: Full Local Installation
1. Install ALL servers locally in `C:\mcp-servers`
2. Update all paths in config
3. **Result:** Maximum stability, slower initial setup

---

## 🔧 Implementation Commands

**For Option A (Recommended):**

```bash
# Install critical servers locally
cd C:\mcp-servers
npm install @modelcontextprotocol/server-sequential-thinking
npm install @modelcontextprotocol/server-postgres

# Verify installations
dir node_modules\@modelcontextprotocol\server-sequential-thinking
dir node_modules\@modelcontextprotocol\server-postgres
```

**Then update config file and restart Claude Code.**

---

**Need help implementing? Let me know which option you prefer!**
