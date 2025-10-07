# 🚀 Setup Guide - Financial Services Prospect Automation

## Prerequisites

- ✅ **n8n instance** (self-hosted or n8n Cloud)
- ✅ **Perplexity API key** (Free tier: https://www.perplexity.ai)
- ✅ **Your database** for storing prospects
- ⚠️ *Optional*: Hunter.io (free 25/month), EmailValidator.net (free 1000/month)

---

## Step-by-Step Setup

### **Step 1: Import Workflows**

1. Open your n8n instance
2. Navigate to **Workflows** → **Add Workflow** → **Import from File**
3. Import workflows in this order:

```
Priority 1 (Core System):
✅ 01-master-orchestrator.json
✅ 02-wealth-management-discovery.json
✅ 03-contact-enrichment-pipeline.json
✅ 04-linkedin-intelligence-pipeline.json

Priority 2 (Additional Industries):
✅ 05-accounting-firm-discovery.json
```

---

### **Step 2: Configure Perplexity API**

1. Get your free API key from: https://www.perplexity.ai/settings/api
2. In n8n, go to **Credentials** → **Add Credential**
3. Search for "Perplexity"
4. Add your API key
5. In workflow `04-linkedin-intelligence-pipeline.json`:
   - Find the "Perplexity: Company Research" node
   - Select your credential

---

### **Step 3: Connect Your Database**

Each workflow has placeholder nodes for database operations. Update these sections:

#### **In 03-contact-enrichment-pipeline.json:**
Find node: "Load Prospects for Enrichment"
```javascript
// Replace this with your actual database query
// Example for PostgreSQL:
SELECT * FROM prospects 
WHERE enrichment_status = 'pending'
LIMIT 50
```

#### **In 04-linkedin-intelligence-pipeline.json:**
Find node: "Load Prospects"
```javascript
// Replace with query to get enriched prospects
SELECT * FROM prospects
WHERE enrichment_status = 'completed'
AND linkedin_intelligence IS NULL
LIMIT 30
```

#### **At end of each workflow:**
Add database INSERT/UPDATE nodes to store results.

**Database Node Options in n8n:**
- PostgreSQL node
- MySQL node
- MongoDB node  
- HTTP Request (to your API)
- Custom function calling your database

---

### **Step 4: Configure Cron Schedule**

In `01-master-orchestrator.json`:

1. Open the workflow
2. Click on "Daily Discovery - 6 AM" node
3. Verify cron expression: `0 6 * * *` (6 AM daily)
4. Adjust to your preferred time:
   - `0 8 * * *` = 8 AM daily
   - `0 6 * * 1-5` = 6 AM weekdays only
   - `0 */12 * * *` = Every 12 hours

---

### **Step 5: Link Sub-Workflows**

In `01-master-orchestrator.json`, the "Execute Discovery Workflows" node needs to call your imported workflows:

1. Click "Execute Discovery Workflows" node
2. For each workflow type, set the **Workflow ID**:
   - `wealth_management_discovery` → Select workflow 02
   - `accounting_firm_discovery` → Select workflow 05
   - `contact_enrichment_pipeline` → Select workflow 03
   - `linkedin_intelligence_pipeline` → Select workflow 04

**Or use workflow IDs directly:**
```javascript
// In the Function node "Initialize Discovery Batches":
{
  workflow_type: 'wealth_management_discovery',
  workflowId: '123'  // Replace with actual n8n workflow ID
}
```

---

### **Step 6: Test Individual Workflows**

Before activating the full system, test each workflow:

#### **Test Discovery Workflow:**
1. Open `02-wealth-management-discovery.json`
2. Click **Execute Workflow** (play button)
3. Verify prospects are discovered
4. Check console logs for errors

#### **Test Enrichment Pipeline:**
1. Manually add a test prospect to your database
2. Open `03-contact-enrichment-pipeline.json`
3. Execute and verify enrichment works

#### **Test LinkedIn Intelligence:**
1. Use an enriched prospect from previous step
2. Open `04-linkedin-intelligence-pipeline.json`
3. Execute and verify LinkedIn data is collected

---

### **Step 7: Configure Rate Limiting**

To avoid being blocked by websites, add delays:

1. Between Google searches: Add `Wait` node with 5-10 seconds
2. Between website scrapes: Add `Wait` node with 2-3 seconds
3. Between LinkedIn lookups: Add `Wait` node with 10-15 seconds

**Add Wait Node:**
- Drag a "Wait" node between HTTP Request nodes
- Set "Resume After" to 5000ms (5 seconds)

---

### **Step 8: Activate Master Orchestrator**

Once everything is tested:

1. Open `01-master-orchestrator.json`
2. Toggle the **Inactive** switch to **Active**
3. The workflow will now run automatically at 6 AM daily

---

## Verification Checklist

Before going live, verify:

- [ ] All 5 workflows imported successfully
- [ ] Perplexity API credential configured
- [ ] Database connections working
- [ ] Sub-workflows linked correctly in orchestrator
- [ ] Individual workflows tested and working
- [ ] Rate limiting configured
- [ ] Cron schedule set correctly
- [ ] Error handling tested
- [ ] Data storage working

---

## Optional Enhancements

### **Add Email Verification (Free Tier):**

1. Sign up for EmailValidator.net (1000 free/month)
2. Get API key
3. In `03-contact-enrichment-pipeline.json`, add after "Validate Email Syntax":

```javascript
// HTTP Request Node
{
  "method": "GET",
  "url": "https://api.emailvalidator.net/domain/check",
  "qs": {
    "EmailAddress": "={{ $json.email }}",
    "APIKey": "YOUR_API_KEY"
  }
}
```

### **Add Hunter.io Email Discovery:**

1. Sign up for Hunter.io (25 free/month)
2. Get API key
3. In `03-contact-enrichment-pipeline.json`, add:

```javascript
// HTTP Request Node
{
  "method": "GET",
  "url": "https://api.hunter.io/v2/email-finder",
  "qs": {
    "domain": "={{ $json.company_domain }}",
    "first_name": "={{ $json.first_name }}",
    "last_name": "={{ $json.last_name }}",
    "api_key": "YOUR_API_KEY"
  }
}
```

---

## Troubleshooting Common Issues

### **Issue: Workflows not finding prospects**
**Solution:**
- Check Google search queries are specific enough
- Verify websites have public team/contact pages
- Update search patterns in discovery workflows

### **Issue: Database connection errors**
**Solution:**
- Verify database credentials in n8n
- Check database is accessible from n8n instance
- Test connection with simple SELECT query

### **Issue: Perplexity API errors**
**Solution:**
- Verify API key is correct
- Check you haven't exceeded free tier limits
- Add retry logic to API calls

### **Issue: Master orchestrator not triggering**
**Solution:**
- Ensure workflow is set to "Active"
- Check cron expression syntax
- Verify timezone settings in n8n

### **Issue: Sub-workflows not executing**
**Solution:**
- Check workflow IDs are correct
- Ensure sub-workflows are activated
- Verify Execute Workflow nodes are configured

---

## Monitoring Your System

### **Daily Checks:**
1. Open n8n **Executions** tab
2. Review today's orchestrator execution
3. Check success/failure status
4. Review prospect count discovered

### **Weekly Review:**
- Total prospects discovered
- Quality score distribution
- Success rates per workflow
- Any repeated errors

### **Performance Metrics:**
```javascript
// Expected daily output:
Prospects discovered: 50-100
Fully enriched: 30-50
Email discovery rate: 70-85%
LinkedIn success rate: 90-95%
Average quality score: 80-90
```

---

## Next Steps After Setup

1. **Week 1:** Monitor daily, adjust search queries
2. **Week 2:** Review quality scores, refine enrichment
3. **Week 3:** Optimize rate limiting and performance
4. **Week 4:** Scale up to target daily volumes

---

## Support Resources

- **n8n Documentation:** https://docs.n8n.io
- **n8n Community:** https://community.n8n.io
- **Perplexity API Docs:** https://docs.perplexity.ai
- **Workflow Logs:** n8n → Executions tab

---

**Setup Time: ~2-3 hours**
**Maintenance: ~30 minutes per week**
**Expected ROI: 30-50 qualified prospects daily**

