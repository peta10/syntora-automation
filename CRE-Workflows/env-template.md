# Environment Variables Template

Copy this file to `.env` in your n8n installation and fill in your actual API keys.

```bash
# OpenRouter API (Required)
# Get from: https://openrouter.ai
OPENROUTER_API_KEY=your-openrouter-api-key-here

# Firecrawl API (Required)
# Get from: https://firecrawl.dev
FIRECRAWL_API_KEY=your-firecrawl-api-key-here

# Google Maps API (Required)
# Get from: https://console.cloud.google.com
GOOGLE_MAPS_API_KEY=your-google-maps-api-key-here

# HTML to PDF API (Optional)
# Option 1: html2pdf.app
HTML2PDF_API_KEY=your-html2pdf-api-key-here

# Option 2: If self-hosting with Puppeteer, leave empty
# HTML2PDF_API_KEY=

# Website URL (Required for OpenRouter)
# Your website URL for OpenRouter referer header
WEBSITE_URL=https://your-website.com

# Supabase Configuration
# These are set in n8n credentials, not environment variables
# SUPABASE_URL=https://your-project.supabase.co
# SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

## How to Set Environment Variables in n8n

### Option 1: Self-Hosted n8n

**Docker:**
```bash
# In docker-compose.yml or .env file
environment:
  - OPENROUTER_API_KEY=your-key
  - FIRECRAWL_API_KEY=your-key
  - GOOGLE_MAPS_API_KEY=your-key
  - HTML2PDF_API_KEY=your-key
  - WEBSITE_URL=https://your-website.com
```

**NPM Installation:**
```bash
# In .env file in n8n directory
export OPENROUTER_API_KEY=your-key
export FIRECRAWL_API_KEY=your-key
export GOOGLE_MAPS_API_KEY=your-key
export HTML2PDF_API_KEY=your-key
export WEBSITE_URL=https://your-website.com
```

### Option 2: n8n Cloud

1. Go to Settings → Environment Variables
2. Add each variable:
   - Name: `OPENROUTER_API_KEY`
   - Value: `your-actual-key`
3. Repeat for all variables above

---

## API Key Setup Instructions

### 1. OpenRouter API Key

1. Sign up at https://openrouter.ai
2. Go to Keys section
3. Create new key
4. Copy key → Paste as `OPENROUTER_API_KEY`
5. Add credits to account (minimum $5)

**Cost:** Pay per use (~$0.01-0.05 per property)

---

### 2. Firecrawl API Key

1. Sign up at https://firecrawl.dev
2. Go to API Keys section
3. Create new key
4. Copy key → Paste as `FIRECRAWL_API_KEY`

**Cost:** Free tier: 100 scrapes/month, then $29/month

---

### 3. Google Maps API Key

1. Go to https://console.cloud.google.com
2. Create project or select existing
3. Enable "Geocoding API"
4. Go to Credentials → Create Credentials → API Key
5. Copy key → Paste as `GOOGLE_MAPS_API_KEY`
6. Restrict key to "Geocoding API" only

**Cost:** $5 per 1,000 requests (first $200 free/month)

---

### 4. HTML to PDF API Key (Optional)

**Option A: html2pdf.app**
1. Sign up at https://html2pdf.app
2. Get API key from dashboard
3. Copy key → Paste as `HTML2PDF_API_KEY`

**Option B: Self-hosted Puppeteer**
- No API key needed
- Requires Puppeteer setup in n8n
- Modify workflow to use local Puppeteer

**Cost:** html2pdf.app: $19/month for 1,000 PDFs

---

### 5. Website URL

Set to your website URL:
```bash
WEBSITE_URL=https://your-domain.com
```

Or if no website:
```bash
WEBSITE_URL=https://localhost:3000
```

---

## Testing Environment Variables

After setting all variables, test with:

```bash
# In n8n terminal (if self-hosted)
echo $OPENROUTER_API_KEY
echo $FIRECRAWL_API_KEY
echo $GOOGLE_MAPS_API_KEY
```

Or test in workflow:
1. Add Function node
2. Run: `$env.OPENROUTER_API_KEY`
3. Should return your key (not null)

---

## Security Notes

⚠️ **Never commit `.env` file to git**

Add to `.gitignore`:
```
.env
.env.local
*.env
```

✅ **Best Practices:**
- Use environment variables, not hardcoded keys
- Restrict API keys when possible
- Rotate keys regularly
- Use separate keys for dev/prod

