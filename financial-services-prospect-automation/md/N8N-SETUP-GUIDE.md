# 🚀 Complete n8n Setup Guide

## **Prerequisites**

Before starting, ensure you have:
- ✅ n8n installed and running (self-hosted or cloud)
- ✅ Supabase project: `qcrgacxgwlpltdfpwkiz`
- ✅ Supabase table `fs_prospects` created ✅
- ✅ Gmail account for sending emails
- ✅ OpenAI API key (GPT-4 access)

---

## **📋 Step-by-Step Setup**

### **Step 1: Set Up Credentials in n8n**

#### **1.1 Supabase API Credential**

1. Go to n8n → **Credentials** → **New**
2. Search for **"Supabase"**
3. Click **Create New Credential**
4. Fill in:
   ```
   Name: Supabase - Syntora
   Host: https://qcrgacxgwlpltdfpwkiz.supabase.co
   Service Role Secret: [Your Supabase Service Role Key]
   ```
5. **How to get Service Role Key:**
   - Go to Supabase Dashboard
   - Select project: `qcrgacxgwlpltdfpwkiz`
   - Settings → API
   - Copy **service_role** key (NOT anon key)
6. Click **Save**

---

#### **1.2 OpenAI API Credential**

1. Go to n8n → **Credentials** → **New**
2. Search for **"OpenAI"**
3. Click **Create New Credential**
4. Fill in:
   ```
   Name: OpenAI - GPT-4
   API Key: [Your OpenAI API Key]
   ```
5. **How to get API Key:**
   - Go to https://platform.openai.com/api-keys
   - Click **Create new secret key**
   - Copy and save immediately
6. Click **Save**

---

#### **1.3 Gmail OAuth2 Credential**

1. Go to n8n → **Credentials** → **New**
2. Search for **"Gmail OAuth2"**
3. Click **Create New Credential**
4. Fill in:
   ```
   Name: Gmail - Personal
   ```
5. Click **Connect my account**
6. Sign in with your Gmail account
7. Grant n8n permissions to send emails
8. Click **Save**

**Important:** Gmail has a 500 emails/day limit for personal accounts. The automation respects this by sending max 20/batch.

---

### **Step 2: Import All 14 Workflows**

#### **Import Order:**

Import workflows in this order to avoid errors:

1. **Core Workflows (No dependencies):**
   - `02-wealth-management-discovery.json`
   - `05-accounting-firm-discovery.json`
   - `09-equipment-financing-discovery.json`
   - `10-insurance-agency-discovery.json`
   - `11-financial-advisors-discovery.json`
   - `12-real-estate-discovery.json`
   - `14-venture-capital-discovery.json` ⭐ NEW

2. **Processing Workflows:**
   - `03-contact-enrichment-pipeline.json`
   - `04-linkedin-intelligence-pipeline.json`

3. **AI Agent Workflows:**
   - `06-ai-lead-qualification-agent.json`
   - `07-ai-personalization-agent.json`
   - `08-ai-search-optimizer-agent.json`

4. **Outreach:**
   - `13-gmail-outreach-sender.json`

5. **Master Orchestrator (LAST):**
   - `01-master-orchestrator.json`

---

#### **How to Import Each Workflow:**

1. Open n8n
2. Click **Workflows** → **Add workflow** → **Import from File**
3. Navigate to `financial-services-prospect-automation/workflows/`
4. Select workflow JSON file
5. Click **Open**
6. **IMMEDIATELY**:
   - Click **Settings** (gear icon top right)
   - Set **Workflow Name** (matches filename)
   - Set **Workflow ID** (matches filename without extension)
   - Click **Save**
7. **Link Credentials:**
   - Click each node with a credential requirement
   - Select the credential you created in Step 1
   - Common nodes needing credentials:
     - **Supabase nodes** → Select "Supabase - Syntora"
     - **OpenAI nodes** → Select "OpenAI - GPT-4"
     - **Gmail nodes** → Select "Gmail - Personal"
   - Click **Save** on each node
8. **Activate Workflow:**
   - Toggle **Active** switch (top right)

Repeat for all 14 workflows.

---

### **Step 3: Configure Master Orchestrator Workflow**

The Master Orchestrator needs to know the workflow IDs of all sub-workflows.

#### **Get Workflow IDs:**

1. Go to n8n → **Workflows**
2. Click each workflow
3. Look at the URL: `https://your-n8n.com/workflow/[WORKFLOW_ID]`
4. Copy the **WORKFLOW_ID** for each

---

#### **Update Master Orchestrator:**

1. Open **01-master-orchestrator.json** in n8n
2. Find **"Execute Discovery Workflows"** node
3. Update the `workflowId` field with actual IDs:
   ```javascript
   // Map workflow types to actual n8n workflow IDs
   const workflowMap = {
     'wealth_management_discovery': 'actual-workflow-id-1',
     'accounting_firm_discovery': 'actual-workflow-id-2',
     'financial_advisors_discovery': 'actual-workflow-id-3',
     'equipment_financing_discovery': 'actual-workflow-id-4',
     'insurance_agency_discovery': 'actual-workflow-id-5',
     'real_estate_discovery': 'actual-workflow-id-6',
     'venture_capital_discovery': 'actual-workflow-id-7'
   };
   
   return {
     json: {
       workflowId: workflowMap[$json.workflow_type]
     }
   };
   ```
4. Do the same for:
   - **"Trigger Contact Enrichment"** node
   - **"Trigger LinkedIn Intelligence"** node
   - **"Trigger AI Lead Qualification"** node
   - **"Trigger AI Personalization"** node
5. Click **Save**

---

### **Step 4: Test Each Workflow Individually**

Before running the full automation, test each workflow:

#### **Test Discovery Workflows:**

1. Open **02-wealth-management-discovery.json**
2. Click **Execute Workflow** (manually)
3. Check **Execution Data**:
   - Should discover 5-10 prospects
   - Should extract names, emails, company info
4. Check **Supabase**:
   - Go to Supabase Table Editor → `fs_prospects`
   - Should see new records with `status = 'discovered'`
5. If successful, repeat for workflows 5, 9, 10, 11, 12, 14

---

#### **Test Enrichment Workflows:**

1. Ensure you have prospects in Supabase with `status = 'discovered'`
2. Open **03-contact-enrichment-pipeline.json**
3. Click **Execute Workflow**
4. Check results:
   - Prospects should have verified emails
   - Phone numbers added
   - Company data enriched
   - Status updated to `enriched`

---

#### **Test AI Agent Workflows:**

1. Ensure you have prospects with `status = 'enriched'`
2. Open **06-ai-lead-qualification-agent.json**
3. Click **Execute Workflow**
4. Check Supabase:
   - Prospects should have:
     - `ai_qualification_score` (0-100)
     - `ai_qualification_grade` (A, B, C, D, F)
     - `ai_key_strengths` (JSON array)
     - Status updated to `qualified`

5. Open **07-ai-personalization-agent.json**
6. Click **Execute Workflow**
7. Check Supabase:
   - Prospects should have:
     - `email_draft` (JSON with subject + body)
     - `linkedin_draft` (JSON with message)
     - `pain_point_analysis` (JSON)
     - `recommended_approach` (text)
     - `ready_for_outreach` = `TRUE`

---

#### **Test Gmail Sender (CAREFULLY):**

⚠️ **WARNING:** This will send REAL EMAILS!

1. Ensure you have prospects with:
   - `ready_for_outreach = TRUE`
   - `approved_for_send = FALSE` (don't approve yet!)
2. **First, do a dry run:**
   - Open **13-gmail-outreach-sender.json**
   - Disable the **Gmail send** node
   - Click **Execute Workflow**
   - Check that it loads correct prospects
3. **When ready to send:**
   - Manually set ONE prospect to `approved_for_send = TRUE`
   - Enable the Gmail send node
   - Click **Execute Workflow**
   - **Check your Gmail Sent folder** to verify
4. **If successful**, you can approve more prospects

---

### **Step 5: Activate Master Orchestrator**

Once all individual workflows are tested and working:

1. Open **01-master-orchestrator.json**
2. Verify the cron schedule:
   - Default: `0 6 * * *` (6:00 AM daily)
   - Change if needed
3. Toggle **Active** to ON
4. The automation will now run automatically every day!

---

## **🔧 Configuration Checklist**

Before going live, verify:

### **Credentials:**
- [ ] Supabase API credential configured
- [ ] OpenAI API credential configured
- [ ] Gmail OAuth2 credential configured
- [ ] All nodes linked to correct credentials

### **Workflows:**
- [ ] All 14 workflows imported
- [ ] All workflows activated
- [ ] Master Orchestrator has correct workflow IDs
- [ ] Cron schedule set correctly

### **Database:**
- [ ] Supabase table `fs_prospects` exists
- [ ] Table has all required columns
- [ ] RLS (Row Level Security) disabled on `fs_prospects`

### **Testing:**
- [ ] Discovery workflows tested (at least 1)
- [ ] Enrichment workflow tested
- [ ] AI qualification tested
- [ ] AI personalization tested
- [ ] Gmail sender tested (dry run + 1 real email)
- [ ] Master Orchestrator test run completed

### **Monitoring:**
- [ ] n8n notifications enabled for workflow errors
- [ ] Daily check Supabase for new prospects
- [ ] Weekly review AI qualification quality

---

## **📊 Your Daily Workflow (After Setup)**

### **Morning (Automatic - 6am):**
✅ Master Orchestrator runs  
✅ 105 prospects discovered  
✅ 85 enriched with contact data  
✅ 80 get LinkedIn intelligence  
✅ 60 AI-qualified  
✅ 60 personalized with email drafts  
✅ All saved to Supabase with `ready_for_outreach = TRUE`

### **Afternoon (Manual - 5-10 minutes):**
1. Open Supabase Table Editor → `fs_prospects`
2. Filter: `ready_for_outreach = TRUE AND approved_for_send = FALSE`
3. Review prospects:
   - Read `ai_qualification_grade`
   - Read `email_draft`
   - Read `pain_point_analysis`
4. **Approve 5-10 prospects:**
   - Set `approved_for_send = TRUE` for ones you like
   - Set `send_priority = 1` for urgent ones
5. Save changes

### **Next Morning (Automatic - 9am):**
✅ Workflow 13 runs  
✅ Sends emails to approved prospects  
✅ Updates `status = 'contacted'`  
✅ Records `email_sent_at` timestamp

---

## **🔍 Troubleshooting**

### **Issue: Discovery workflows find 0 prospects**

**Cause:** Google blocking automated searches  
**Solution:**
- Add delays between searches (use Wait node)
- Rotate User-Agent headers
- Use residential proxy service

---

### **Issue: Email verification failing**

**Cause:** Free email verification APIs have rate limits  
**Solution:**
- Upgrade to paid email verification service
- Reduce daily discovery target
- Accept lower verification rates

---

### **Issue: OpenAI rate limit errors**

**Cause:** Too many API calls too quickly  
**Solution:**
- Add delays between AI agent calls
- Reduce daily discovery target
- Upgrade OpenAI plan

---

### **Issue: Gmail "Daily sending limit exceeded"**

**Cause:** Gmail limits personal accounts to 500 emails/day  
**Solution:**
- Workflow 13 already limits to 20/batch
- Don't approve more than 20 prospects/day
- Consider Google Workspace for higher limits

---

### **Issue: Supabase connection timeout**

**Cause:** Too many concurrent connections  
**Solution:**
- Add delays between Supabase operations
- Use batch operations instead of individual inserts
- Upgrade Supabase plan

---

### **Issue: Workflow execution taking too long**

**Cause:** Large batch sizes  
**Solution:**
- Reduce daily discovery targets
- Split workflows into smaller batches
- Optimize code nodes for performance

---

## **🎯 Success Metrics to Track**

### **Daily:**
```sql
-- Prospects discovered today
SELECT COUNT(*) FROM fs_prospects 
WHERE DATE(discovered_at) = CURRENT_DATE;

-- Emails sent today
SELECT COUNT(*) FROM fs_prospects 
WHERE DATE(email_sent_at) = CURRENT_DATE;
```

### **Weekly:**
```sql
-- Total prospects by industry
SELECT industry, COUNT(*) 
FROM fs_prospects 
WHERE discovered_at > NOW() - INTERVAL '7 days'
GROUP BY industry;

-- Email reply rate
SELECT 
  COUNT(*) FILTER (WHERE email_replied = TRUE) * 100.0 / 
  COUNT(*) as reply_rate_percent
FROM fs_prospects 
WHERE email_sent_at > NOW() - INTERVAL '7 days';
```

### **Monthly:**
```sql
-- Meetings scheduled
SELECT COUNT(*) FROM fs_prospects 
WHERE meeting_scheduled = TRUE 
  AND email_sent_at > NOW() - INTERVAL '30 days';

-- Top performing industries
SELECT 
  industry,
  COUNT(*) as sent,
  COUNT(*) FILTER (WHERE email_replied = TRUE) as replied,
  COUNT(*) FILTER (WHERE email_replied = TRUE) * 100.0 / COUNT(*) as reply_rate
FROM fs_prospects 
WHERE email_sent_at > NOW() - INTERVAL '30 days'
GROUP BY industry
ORDER BY reply_rate DESC;
```

---

## **✅ You're Ready to Launch!**

After completing all steps:
1. ✅ All credentials configured
2. ✅ All 14 workflows imported and active
3. ✅ Master Orchestrator running daily
4. ✅ Individual tests successful
5. ✅ Gmail sender tested and working

**Your automation is now live!** 🚀

**Expected Results:**
- 105 new prospects/day
- 60 AI-qualified prospects/day
- 10-15 approved for email/day
- 2-3 replies/day
- **2-3 new conversations/day from automation!**

---

## **📞 Need Help?**

**Common Issues:**
- Check n8n execution logs for errors
- Verify credentials are still valid
- Check Supabase for data flow
- Review OpenAI API usage limits

**Support Resources:**
- n8n Community: https://community.n8n.io
- n8n Docs: https://docs.n8n.io
- Supabase Docs: https://supabase.com/docs

**Your automation is production-ready! Let it run and watch the leads flow in.** 🎯

