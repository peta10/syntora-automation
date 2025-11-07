# ⚙️ Configuration Template

## API Credentials

### **Perplexity AI (Required)**
```yaml
Provider: Perplexity AI
API Key: YOUR_PERPLEXITY_API_KEY
Free Tier: Yes (limited queries/day)
Usage: Company research and market intelligence
Sign Up: https://www.perplexity.ai/settings/api
```

### **Hunter.io (Optional - 25 free/month)**
```yaml
Provider: Hunter.io
API Key: YOUR_HUNTER_API_KEY
Free Tier: 25 searches/month
Usage: Email discovery enhancement
Sign Up: https://hunter.io/users/sign_up
```

### **EmailValidator.net (Optional - 1000 free/month)**
```yaml
Provider: EmailValidator.net
API Key: YOUR_EMAILVALIDATOR_API_KEY
Free Tier: 1000 verifications/month
Usage: Email validation and verification
Sign Up: https://www.emailvalidator.net/register
```

---

## Workflow IDs

**Update these after importing workflows into n8n:**

```javascript
const WORKFLOW_IDS = {
  master_orchestrator: 'WORKFLOW_ID_001',
  wealth_management_discovery: 'WORKFLOW_ID_002',
  contact_enrichment: 'WORKFLOW_ID_003',
  linkedin_intelligence: 'WORKFLOW_ID_004',
  accounting_firm_discovery: 'WORKFLOW_ID_005'
};
```

---

## Database Configuration

### **Option 1: PostgreSQL**
```javascript
{
  host: 'your-database-host',
  port: 5432,
  database: 'prospects_db',
  user: 'your_username',
  password: 'your_password',
  ssl: true
}
```

### **Option 2: MySQL**
```javascript
{
  host: 'your-database-host',
  port: 3306,
  database: 'prospects_db',
  user: 'your_username',
  password: 'your_password'
}
```

### **Option 3: MongoDB**
```javascript
{
  connectionString: 'mongodb://username:password@host:27017/prospects_db'
}
```

### **Option 4: Custom API**
```javascript
{
  baseUrl: 'https://your-api.com/api',
  apiKey: 'your_api_key',
  endpoints: {
    getProspects: '/prospects',
    createProspect: '/prospects',
    updateProspect: '/prospects/:id'
  }
}
```

---

## Search Query Customization

### **Wealth Management Queries**
```javascript
const wealthManagementQueries = [
  'site:*.com "wealth management" "team" email',
  'site:*.com "financial advisor" "RIA" email',
  'site:*.com "investment management" "advisors" email',
  'site:*.com "private wealth" "team" email contact',
  'site:*.com "fee-only" "financial planner" email',
  // Add your custom queries here
];
```

### **Accounting Firm Queries**
```javascript
const accountingFirmQueries = [
  'site:*.com "CPA firm" "team" email',
  'site:*.com "accounting firm" "staff" email',
  'site:*.com "certified public accountant" "contact" email',
  'site:*.com "tax advisor" "team" email',
  // Add your custom queries here
];
```

### **Equipment Financing Queries**
```javascript
const equipmentFinancingQueries = [
  'site:*.com "equipment financing" "team" email',
  'site:*.com "commercial lending" "staff" email',
  'site:*.com "business financing" "advisors" email',
  // Add your custom queries here
];
```

---

## Target Volume Configuration

```javascript
const dailyTargets = {
  wealth_management: 25,      // prospects per day
  accounting_firms: 25,        // prospects per day
  equipment_financing: 15,     // prospects per day
  insurance_agencies: 15,      // prospects per day
  total_daily_target: 80       // total prospects per day
};
```

---

## Rate Limiting Settings

```javascript
const rateLimits = {
  google_search_delay: 5000,        // 5 seconds between searches
  website_scrape_delay: 2000,       // 2 seconds between scrapes
  linkedin_lookup_delay: 10000,     // 10 seconds between LinkedIn
  api_call_delay: 1000,             // 1 second between API calls
  max_concurrent_requests: 3        // max parallel requests
};
```

---

## Quality Score Thresholds

```javascript
const qualityThresholds = {
  grades: {
    A: 80,  // Ready to contact
    B: 60,  // Needs minor enrichment
    C: 40,  // Requires more research
    D: 0    // Insufficient data
  },
  minimum_contact_score: 60,        // Min score to use for outreach
  minimum_linkedin_score: 40,       // Min score for LinkedIn intelligence
  email_verification_required: true // Require email verification
};
```

---

## Cron Schedule Configuration

```javascript
const schedules = {
  daily_discovery: '0 6 * * *',          // 6 AM daily
  weekly_refresh: '0 2 * * 0',           // 2 AM Sundays
  monthly_cleanup: '0 1 1 * *',          // 1 AM 1st of month
  
  // Alternative schedules:
  // '0 8 * * 1-5'  = 8 AM weekdays only
  // '0 */12 * * *' = Every 12 hours
  // '0 6,18 * * *' = 6 AM and 6 PM daily
};
```

---

## Industry-Specific Configuration

### **Wealth Management Focus**
```javascript
const wealthManagementConfig = {
  target_titles: [
    'Financial Advisor',
    'Wealth Manager',
    'Senior Partner',
    'Managing Director',
    'Portfolio Manager',
    'Financial Planner'
  ],
  target_designations: ['CFP', 'CFA', 'ChFC', 'RICP'],
  min_aum: 100000000,  // $100M minimum AUM
  business_models: ['fee_only', 'fee_based', 'hybrid']
};
```

### **Accounting Firm Focus**
```javascript
const accountingFirmConfig = {
  target_titles: [
    'CPA',
    'Managing Partner',
    'Tax Manager',
    'Audit Manager',
    'Controller',
    'Tax Advisor'
  ],
  target_designations: ['CPA', 'EA', 'CMA'],
  firm_sizes: ['solo', 'small (2-10)', 'medium (11-50)', 'large (51+)']
};
```

---

## Personalization Settings

```javascript
const personalizationConfig = {
  max_hooks_per_prospect: 5,
  hook_priorities: [
    'recent_company_news',
    'career_milestones',
    'linkedin_activity',
    'industry_challenges',
    'professional_achievements'
  ],
  perplexity_research_depth: 'comprehensive', // 'basic' | 'standard' | 'comprehensive'
  include_competitive_intel: true
};
```

---

## Error Handling Configuration

```javascript
const errorConfig = {
  max_retries: 3,
  retry_delay: 5000,        // 5 seconds
  timeout: 30000,           // 30 seconds
  ignore_http_errors: true,
  log_level: 'info',        // 'error' | 'warn' | 'info' | 'debug'
  alert_on_failure: true,
  alert_threshold: 0.5      // Alert if >50% failure rate
};
```

---

## Notification Settings

```javascript
const notificationConfig = {
  daily_summary: {
    enabled: true,
    channel: 'slack',       // 'slack' | 'email' | 'webhook'
    webhook_url: 'YOUR_SLACK_WEBHOOK_URL',
    time: '15:00'           // 3 PM daily summary
  },
  error_alerts: {
    enabled: true,
    channel: 'slack',
    immediate: true
  },
  weekly_report: {
    enabled: true,
    channel: 'email',
    recipients: ['your-email@company.com'],
    day: 'monday'
  }
};
```

---

## Data Retention Policy

```javascript
const dataRetention = {
  keep_raw_html: false,              // Don't store raw HTML
  keep_failed_prospects: 30,         // Keep for 30 days
  archive_old_prospects: 180,        // Archive after 180 days
  delete_duplicates: true,           // Auto-delete duplicates
  anonymize_after_days: 365          // Anonymize after 1 year
};
```

---

## Geographic Targeting

```javascript
const geographicConfig = {
  target_countries: ['US', 'CA'],
  target_states: [
    'CA', 'NY', 'TX', 'FL', 'IL',    // Top 5 states
    // Add more states as needed
  ],
  target_cities: [
    'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'
  ],
  exclude_regions: [],                 // Regions to exclude
  timezone_considerations: true
};
```

---

## Performance Optimization

```javascript
const performanceConfig = {
  batch_size: 10,                      // Process 10 at a time
  parallel_workers: 3,                 // 3 parallel discovery streams
  cache_duration: 86400,               // 24 hours cache
  use_cdn: false,                      // CDN for static assets
  compress_responses: true,            // Gzip compression
  memory_limit: '2GB'                  // Max memory per workflow
};
```

---

## Compliance & Privacy

```javascript
const complianceConfig = {
  gdpr_compliant: true,
  ccpa_compliant: true,
  respect_robots_txt: true,
  honor_do_not_contact: true,
  data_encryption: true,
  audit_logging: true,
  consent_tracking: true
};
```

---

## Copy & Update Instructions

1. Copy this file to `CONFIG.md`
2. Replace all `YOUR_*` placeholders with actual values
3. Update workflow IDs after importing to n8n
4. Customize search queries for your specific needs
5. Adjust rate limits based on your requirements
6. Set notification preferences
7. **Never commit CONFIG.md with real credentials to git**

---

**Security Note:** Keep your actual CONFIG.md file private and never share credentials publicly.

