# 📥 Complete Workflow Import Instructions

## 🎯 Quick Start: Import All Workflows to n8n

Your n8n instance: **https://n8n-ptb2.onrender.com**

---

## ✅ **What's Ready to Import**

### **Production-Ready Firecrawl Workflows:**
1. ✅ `02-wealth-management-discovery-firecrawl.json`
2. ✅ `05-accounting-firm-discovery-firecrawl.json`
3. ✅ `11-financial-advisors-discovery-firecrawl.json`
4. ✅ `09-equipment-financing-discovery-firecrawl.json`
5. ✅ `10-insurance-agency-discovery-firecrawl.json`
6. ✅ `12-real-estate-discovery-firecrawl.json`
7. ✅ `14-venture-capital-discovery-firecrawl.json`

### **Regulatory Discovery Workflows:**
8. ✅ `15-sec-iapd-regulatory-discovery.json` (no Firecrawl needed)
9. ✅ `16-finra-brokercheck-discovery.json` (no Firecrawl needed)

### **Master Orchestrator:**
10. ⏳ `01-master-orchestrator.json` (needs workflow IDs updated)

---

## 🔐 **STEP 1: Add API Credentials to n8n**

### **1.1 Firecrawl API Credential**

1. Log into n8n: `https://n8n-ptb2.onrender.com`
2. Click **"Settings"** (gear icon) → **"Credentials"**
3. Click **"Add Credential"**
4. Search: **"HTTP Header Auth"**
5. Fill in:
   ```
   Name: Firecrawl API
   Header Name: Authorization
   Header Value: Bearer YOUR_FIRECRAWL_API_KEY
   ```
   **Example:** `Bearer fc-abc123xyz...`
6. Click **"Save"**
7. **Note the credential name** (you'll select it from dropdown when importing)

### **1.2 Brave Search API Credential**

1. In n8n → **"Settings"** → **"Credentials"**
2. Click **"Add Credential"**
3. Search: **"HTTP Header Auth"**
4. Fill in:
   ```
   Name: Brave Search API
   Header Name: X-Subscription-Token
   Header Value: YOUR_BRAVE_API_KEY
   ```
5. Click **"Save"**

### **1.3 Verify Supabase Credential**

1. Check if you already have: **"Supabase - Syntora"** credential
2. If yes, skip this step
3. If no:
   - Add **"Supabase"** credential type
   - Name: `Supabase - Syntora`
   - Host: `https://qcrgacxgwlpltdfpwkiz.supabase.co`
   - Service Role Key: (your key)

---

## 📥 **STEP 2: Import Workflows (One by One)**

### **Import Process (repeat for each workflow):**

1. In n8n, click **"Workflows"** (left sidebar)
2. Click **"Add workflow"** (top right, blue button)
3. Click **"⋮"** menu (3 dots, top right) → **"Import from File"**
4. Navigate to: `financial-services-prospect-automation/workflows/`
5. Select the workflow JSON file (e.g., `02-wealth-management-discovery-firecrawl.json`)
6. Click **"Open"**
7. The workflow loads in the editor

---

## 🔗 **STEP 3: Link Credentials (CRITICAL)**

After importing each workflow, you MUST link the credentials:

### **For Discovery Workflows (02, 05, 09, 10, 11, 12, 14):**

**A. Link Brave Search API:**
1. Click the **"Brave Search API"** node
2. Look for **"Credentials"** section (in node panel)
3. Click the dropdown
4. Select **"Brave Search API"** (the credential you created)
5. Click away to save

**B. Link Firecrawl API:**
1. Click the **"Firecrawl: Scrape Website"** node
2. Look for **"Credentials"** section
3. Click the dropdown
4. Select **"Firecrawl API"** (the credential you created)
5. Click away to save

**C. Link Supabase:**
1. Click the **"Save to Supabase"** node
2. Look for **"Credentials"** section
3. Click the dropdown
4. Select **"Supabase - Syntora"**
5. Click away to save

### **For Regulatory Workflows (15, 16):**

**Only need Supabase:**
1. Click the **"Save to Supabase"** node
2. Link **"Supabase - Syntora"** credential

---

## 💾 **STEP 4: Save and Activate**

After linking all credentials for a workflow:

1. Click **"Save"** (top right, floppy disk icon)
2. Toggle **"Active"** switch to **ON** (top right)
3. The workflow is now live!

---

## 🧪 **STEP 5: Test Each Workflow**

### **Manual Test:**

1. Open the workflow in n8n editor
2. Click **"Execute workflow"** (play button, top right)
3. Watch the execution in real-time:
   - Green = success
   - Red = error
4. Click any node to see its output
5. Verify prospects in Supabase

### **Expected Results (per workflow):**

| Workflow | Expected Prospects | Firecrawl Credits |
|----------|-------------------|-------------------|
| Wealth Management | 15-25 | 60-72 |
| Accounting Firms | 12-20 | 48-60 |
| Financial Advisors | 15-22 | 60-72 |
| Equipment Financing | 10-18 | 40-48 |
| Insurance Agency | 12-20 | 48-60 |
| Real Estate | 10-18 | 40-48 |
| VC/PE | 8-15 | 32-48 |
| SEC IAPD Regulatory | 30-50 | 0 (free API) |
| FINRA BrokerCheck | 40-60 | 0 (free API) |
| **TOTAL DAILY** | **150-200** | **328-408** |

**Firecrawl Cost:** 328-408 credits/day = ~10,000/month = **$29-49/month**

---

## 🎯 **STEP 6: Get Workflow IDs**

After importing all workflows, collect their IDs for the orchestrator:

1. In n8n → **"Workflows"** (left sidebar)
2. Click on a workflow (e.g., "02 - Wealth Management Discovery (Firecrawl)")
3. Look at the URL: `https://n8n-ptb2.onrender.com/workflow/ABC123`
4. The ID is `ABC123`
5. **Write down all workflow IDs:**

```
Wealth Management (02): _____________
Accounting Firms (05): _____________
Equipment Financing (09): _____________
Insurance Agency (10): _____________
Financial Advisors (11): _____________
Real Estate (12): _____________
VC/PE (14): _____________
SEC IAPD (15): _____________
FINRA BrokerCheck (16): _____________
```

---

## 🔄 **STEP 7: Update Master Orchestrator**

### **7.1 Import the Orchestrator**

1. Import: `01-master-orchestrator.json` (same process as before)
2. Don't activate yet!

### **7.2 Update Workflow IDs**

You need to update the `workflowId` parameter in each "Execute Workflow" node:

**Find these nodes and update their `workflowId`:**

1. **"1. Wealth Management Discovery"**
   - Click node
   - Find parameter: `workflowId`
   - Replace with: (your ID from Step 6)

2. **"2. Accounting Firm Discovery"**
   - Update `workflowId` with ID from Step 6

3. **"3. Equipment Financing Discovery"**
   - Update `workflowId`

4. **"4. Insurance Agency Discovery"**
   - Update `workflowId`

5. **"5. Financial Advisors Discovery"**
   - Update `workflowId`

6. **"6. Real Estate Discovery"**
   - Update `workflowId`

7. **"7. VC/PE Discovery"**
   - Update `workflowId`

8. **"8. SEC IAPD Regulatory"**
   - Update `workflowId`

9. **"9. FINRA BrokerCheck Regulatory"**
   - Update `workflowId`

### **7.3 Link Supabase Credential**

1. Find nodes that need Supabase:
   - "Initialize Daily Batch"
   - "Save Summary to Supabase"
2. Link **"Supabase - Syntora"** credential to each

### **7.4 Save and Test**

1. Click **"Save"**
2. Click **"Execute workflow"**
3. Watch it trigger all 9 discovery workflows in parallel
4. Check execution time: should complete in 3-5 minutes

---

## 🚀 **STEP 8: Set Up Daily Automation**

### **8.1 Add Schedule Trigger**

1. Open the Master Orchestrator
2. Find the **"Schedule Trigger"** node (top left)
3. Configure:
   ```
   Trigger Interval: Custom Cron
   Cron Expression: 0 6 * * *
   ```
   This runs at 6:00 AM daily (adjust to your timezone)

### **8.2 Activate**

1. Toggle **"Active"** switch to **ON**
2. The system now runs automatically every day at 6 AM

---

## ✅ **STEP 9: Verify Everything Works**

### **Daily Automation Checklist:**

- [ ] Master orchestrator active
- [ ] All 9 discovery workflows active
- [ ] Credentials linked to all nodes
- [ ] Schedule trigger set to 6:00 AM
- [ ] Test execution successful
- [ ] Prospects appearing in Supabase
- [ ] Firecrawl credits not exceeding plan

### **Monitor Daily:**

1. Check n8n **"Executions"** page
2. Look for:
   - ✅ Green = success
   - ❌ Red = failure (check error logs)
3. Check Supabase for new prospects:
   ```sql
   SELECT COUNT(*), discovery_source
   FROM fs_prospects
   WHERE discovered_at::date = CURRENT_DATE
   GROUP BY discovery_source;
   ```

---

## 🎉 **Success Indicators**

### **You know it's working when:**

1. ✅ All 9 discovery workflows show green checkmarks
2. ✅ Supabase `fs_prospects` table grows by 150-200 rows/day
3. ✅ `discovery_source` shows multiple sources:
   - `brave_firecrawl` (web scraping)
   - `sec_iapd_regulatory` (SEC database)
   - `finra_brokercheck` (FINRA database)
4. ✅ Firecrawl dashboard shows 300-400 credits used/day
5. ✅ Brave dashboard shows 40-50 queries used/day
6. ✅ No red errors in n8n execution history

---

## 🆘 **Troubleshooting Common Issues**

### **Issue: 401 Unauthorized (Firecrawl)**
**Solution:**
- Check API key in credential
- Verify "Bearer " prefix
- Check Firecrawl account status

### **Issue: 401 Unauthorized (Brave)**
**Solution:**
- Check API key in credential
- Verify header name is `X-Subscription-Token`
- Check Brave account status

### **Issue: No emails extracted**
**Solution:**
- Check Firecrawl node output (did it return content?)
- Some sites genuinely have no emails
- This is normal - not all sites have contact info

### **Issue: Supabase errors**
**Solution:**
- Check credential is linked
- Verify `fs_prospects` table exists
- Check Supabase logs for schema errors

### **Issue: Workflows not triggering from orchestrator**
**Solution:**
- Verify workflow IDs are correct
- Check workflows are **Active**
- Look at orchestrator execution logs

---

## 📊 **Expected Daily Performance**

### **With All Workflows Active:**

```
Daily Stats:
- Workflows triggered: 9
- Companies scraped: 80-100
- Firecrawl credits used: 320-400
- Brave queries used: 45-54
- Prospects discovered: 150-200
- Execution time: 3-5 minutes
- Cost per day: $1.60-2.00
- Cost per prospect: $0.01-0.02
```

### **Monthly Stats:**

```
- Total prospects: 4,500-6,000
- Firecrawl credits: 9,600-12,000 (fits Starter plan)
- Brave queries: 1,350-1,620 (fits free tier)
- Total cost: ~$48-60/month (Firecrawl only)
- Cost per prospect: $0.01
```

---

## 🎯 **Next Steps After Import**

1. ✅ Import all 9 discovery workflows
2. ✅ Link credentials to all nodes
3. ✅ Test each workflow manually
4. ✅ Import and configure master orchestrator
5. ✅ Set up daily schedule (6 AM)
6. ✅ Monitor first 3 days
7. 🔄 Review data quality
8. 🔄 Optimize search queries if needed
9. 🔄 Add more industries (optional)

---

## 📚 **Related Documentation**

- **`FIRECRAWL-N8N-DEPLOYMENT-GUIDE.md`** - Detailed setup guide
- **`BRAVE-AND-REGULATORY-SETUP.md`** - API setup instructions
- **`DATABASE-DRIVEN-TESTING-GUIDE.md`** - How to test workflows

---

**🎉 Your production automation system is ready to go!**

**Expected result: 150-200 qualified prospects per day, fully automated, for ~$1.60/day total cost.**
