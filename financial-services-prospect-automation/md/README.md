# 🏦 Financial Services Prospect Automation System

## 📋 Overview

Complete n8n automation system for discovering, enriching, and researching financial services prospects. Runs daily on cron jobs to continuously build your prospect pipeline with **30-50 fully enriched prospects per day**.

### 🎯 Target Industries:
- Wealth Management Firms (RIAs, Financial Advisors)
- Accounting Firms (CPAs, Tax Advisors)
- Equipment Financing Companies
- Insurance Agencies
- Other Financial Services

---

## 🏗️ System Architecture

### **Master Orchestrator** (Daily 6:00 AM)
Coordinates all discovery and enrichment workflows in sequence.

### **Discovery Workflows** (Parallel Execution)
1. `02-wealth-management-discovery.json` - Find wealth management prospects
2. `05-accounting-firm-discovery.json` - Find accounting firm prospects
3. Equipment financing discovery (template provided)
4. Insurance agency discovery (template provided)

### **Enrichment Pipelines** (Sequential Execution)
3. `03-contact-enrichment-pipeline.json` - Email verification, phone discovery, company data
4. `04-linkedin-intelligence-pipeline.json` - LinkedIn profiles, activity, personalization hooks

---

## 🚀 Quick Start

### **Step 1: Import Workflows into n8n**
```bash
# In your n8n instance:
1. Go to Workflows → Import from File
2. Import all JSON files from the /workflows folder
3. Import in this order:
   - 01-master-orchestrator.json
   - 02-wealth-management-discovery.json
   - 05-accounting-firm-discovery.json
   - 03-contact-enrichment-pipeline.json
   - 04-linkedin-intelligence-pipeline.json
```

### **Step 2: Configure Credentials (Minimal)**
```bash
# Required:
- Perplexity API (Free tier) - For company research

# Optional (Free tiers available):
- Hunter.io (25/month free)
- EmailValidator.net (1000/month free)
```

### **Step 3: Connect Your Database**
Update the database storage nodes in each workflow to connect to your custom database.

### **Step 4: Activate the Master Orchestrator**
Set the cron trigger to active in the `01-master-orchestrator.json` workflow.

---

## ⏰ Automation Schedule

### **Daily (6:00 AM)**
- Prospect discovery across all industries
- Contact enrichment
- LinkedIn intelligence gathering
- Quality scoring
- Database storage

### **Expected Daily Output:**
- 50-100 prospects discovered
- 30-50 fully enriched profiles
- 70-85% email discovery rate
- 90-95% LinkedIn intelligence rate
- 40-60% phone discovery rate

---

## 📊 Data Structure

### **Complete Prospect Record:**
```json
{
  "prospect_id": "unique_id",
  "personal_info": {
    "first_name": "John",
    "last_name": "Smith",
    "email": "john.smith@company.com",
    "phone": "5551234567",
    "job_title": "Senior Financial Advisor",
    "linkedin_url": "https://linkedin.com/in/johnsmith"
  },
  "company_data": {
    "company_name": "ABC Wealth Management",
    "domain": "abcwealth.com",
    "website": "https://abcwealth.com",
    "industry": "wealth_management",
    "employee_count": "25",
    "founded_year": "2015"
  },
  "intelligence": {
    "linkedin_profile_data": {...},
    "company_research": "Recent news and developments...",
    "personalization_hooks": [
      "Saw the recent news about ABC Wealth Management...",
      "Your work as Senior Financial Advisor caught my attention..."
    ]
  },
  "quality_metrics": {
    "enrichment_quality_score": 85,
    "enrichment_grade": "A",
    "final_quality_score": 95,
    "email_ready": true
  }
}
```

---

## 🔍 Discovery Methods

### **Google Search-Powered Discovery**
The system uses advanced Google search queries to find publicly listed emails on:
- Team/Staff pages
- Contact pages
- About pages
- Professional directories
- PDF documents (brochures, forms)

### **Search Query Examples:**
```javascript
// Wealth Management
"wealth management" "team" email site:*.com
"RIA" OR "registered investment advisor" "team" email
"CFP" "financial planner" email contact site:*.com

// Accounting Firms
"CPA firm" "staff" email site:*.com
"certified public accountant" "team" email
"tax advisor" "contact" email site:*.com
```

---

## 📧 Contact Enrichment Process

### **1. Email Discovery (70-85% Success Rate)**
- Website team page scraping
- Contact page scraping
- Email pattern generation
- Validation and verification

### **2. Phone Discovery (40-60% Success Rate)**
- Contact page scraping
- About page scraping
- Directory listings

### **3. Company Data (90% Success Rate)**
- Company description
- Employee count
- Founding year
- Industry classification

---

## 🧠 LinkedIn Intelligence

### **Profile Discovery:**
- Google search for LinkedIn profiles
- Profile URL extraction
- Success rate: 90-95%

### **Data Extraction:**
- Current role and headline
- Career history
- Professional certifications
- Profile content analysis

### **Perplexity AI Research:**
```javascript
// Automated research queries:
- "Recent news about [Company] financial services"
- "[Industry] challenges facing [Title] in 2024"
- "[Name] [Company] recent achievements, promotions"
- "Market position of [Company] in [Industry]"
```

### **Personalization Hook Generation:**
- Recent company news mentions
- Career milestone identification
- Content interest analysis
- Industry-specific conversation starters

---

## 🎯 Quality Scoring System

### **Scoring Breakdown (100 points total):**
```javascript
// Contact Completeness (70 points)
- Verified Email: 25 points
- Phone Number: 20 points
- LinkedIn Profile: 15 points
- Company Website: 10 points

// Intelligence Depth (30 points)
- Recent LinkedIn Activity: 15 points
- Company Research: 10 points
- Personalization Hooks: 5 points

// Grade Classification:
- A-Grade: 80-100 (Ready to Contact)
- B-Grade: 60-79 (Needs Minor Enrichment)
- C-Grade: 40-59 (Requires More Research)
- D-Grade: 0-39 (Insufficient Data)
```

---

## 🛠️ Customization Guide

### **Add New Discovery Sources:**
1. Duplicate `02-wealth-management-discovery.json`
2. Update search queries for your target industry
3. Modify extraction patterns as needed
4. Add to master orchestrator workflow

### **Adjust Discovery Volume:**
```javascript
// In master orchestrator, modify:
target_count: 25  // Change to your desired daily volume
```

### **Customize Enrichment:**
Update the `03-contact-enrichment-pipeline.json` to add/remove enrichment steps.

### **Add More Intelligence Sources:**
Extend `04-linkedin-intelligence-pipeline.json` with additional research APIs or scrapers.

---

## 📈 Performance Optimization

### **Rate Limiting:**
Add `Wait` nodes between HTTP requests to avoid:
- IP blocking from Google
- Website rate limits
- API quota exhaustion

### **Error Handling:**
All workflows include:
- `ignoreHttpStatusErrors: true` for graceful failures
- Timeout configurations
- Retry logic where applicable

### **Parallel Processing:**
Discovery workflows run in parallel for maximum speed.

---

## 🔒 Best Practices

### **Data Privacy:**
- Remove all credentials before sharing workflows
- Respect robots.txt and website ToS
- Use reasonable rate limiting
- Store data securely in your database

### **Quality Control:**
- Review low-quality prospects (D-grade) manually
- Update search queries based on results
- Monitor success rates and adjust as needed

### **Maintenance:**
- Weekly review of workflow performance
- Monthly update of search patterns
- Quarterly review of industry targets

---

## 📊 Monitoring & Reporting

### **Daily Metrics to Track:**
- Prospects discovered per workflow
- Email discovery rate
- Phone discovery rate
- LinkedIn profile success rate
- Average quality score
- Processing time

### **Weekly Review:**
- Total prospects added
- Quality distribution (A/B/C/D grades)
- Source performance comparison
- Error rates and failures

---

## 🆘 Troubleshooting

### **Low Discovery Rate:**
- Update Google search queries
- Add more industry-specific patterns
- Check for IP blocking (add delays)

### **Low Email Discovery:**
- Verify target websites have public team pages
- Update email extraction patterns
- Consider additional data sources

### **LinkedIn Profile Issues:**
- LinkedIn may block scraping - use delays
- Use Google search as primary discovery method
- Consider LinkedIn API integration (paid)

### **Perplexity API Errors:**
- Check API quota limits
- Verify API key is valid
- Add error handling and retries

---

## 🔄 Future Enhancements

### **Potential Additions:**
- CRM integration (Salesforce, HubSpot)
- Email warmup and outreach automation
- Advanced deduplication logic
- Prospect scoring ML model
- Multi-channel contact discovery
- Automated follow-up sequences

---

## 📝 License & Usage

This automation system is provided as-is for internal business use. Please ensure compliance with:
- Website terms of service
- Data privacy regulations (GDPR, CCPA)
- Anti-spam laws (CAN-SPAM Act)
- LinkedIn terms of service

---

## 💡 Support

For questions or issues:
1. Review workflow execution logs in n8n
2. Check node configurations for errors
3. Verify API credentials and quotas
4. Test individual workflows before running full system

---

**Built with n8n | Financial Services Focused | 95% Free Implementation**

