# 🔄 n8n Workflow Update Guide

**Quick reference for updating your workflows to use the new schema organization**

---

## ⚡ TL;DR - What Changed

Your Supabase database is now organized into schemas:
- **`automation`** - All prospect automation data (was `public`)
- **`crm`** - All your business data (CRM, tax, productivity, projects)
- **`public`** - Website features only

---

## 🎯 Required Changes

### 1. Update Table References

#### **Financial Services Automation Workflows:**

**OLD (will work but deprecated):**
```sql
SELECT * FROM public.fs_prospects;
INSERT INTO public.fs_prospects ...;
UPDATE public.fs_prospects SET ...;
```

**NEW (correct way):**
```sql
SELECT * FROM automation.fs_prospects;
INSERT INTO automation.fs_prospects ...;
UPDATE automation.fs_prospects SET ...;
```

#### **NEW Tables Available:**

You now have additional tables for better organization:

```sql
-- Enrichment tracking
INSERT INTO automation.fs_enrichment_log (
  prospect_id, enrichment_type, provider, status, response_data
) VALUES (...);

-- LinkedIn data (separate from main prospect table)
INSERT INTO automation.fs_linkedin_data (
  prospect_id, linkedin_url, profile_data, recent_posts
) VALUES (...);

-- Perplexity research (structured)
INSERT INTO automation.fs_perplexity_research (
  prospect_id, research_query, research_type, research_summary, key_findings
) VALUES (...);

-- Email tracking
INSERT INTO automation.fs_email_tracking (
  prospect_id, email_subject, email_body, sent_at, gmail_message_id
) VALUES (...);

-- Workflow execution tracking
INSERT INTO automation.fs_workflow_runs (
  workflow_name, workflow_type, status, batch_id, records_processed
) VALUES (...);

-- API quota management
UPDATE automation.fs_api_quotas 
SET quota_used = quota_used + 1 
WHERE provider = 'hunter.io' AND api_type = 'email_finder';
```

---

## 📋 Workflow-by-Workflow Updates

### **Workflow 01: Master Orchestrator**
- ✅ No changes needed (orchestration only)

### **Workflow 02-12, 14-16: Discovery Workflows**
- 🔄 **Change:** `INSERT INTO public.fs_prospects` → `INSERT INTO automation.fs_prospects`
- Find Supabase nodes
- Update table name in all INSERT/UPDATE queries

### **Workflow 03: Contact Enrichment Pipeline**
- 🔄 **Change:** Use `automation.fs_prospects` AND log to `automation.fs_enrichment_log`
- Example:
  ```sql
  -- Update prospect
  UPDATE automation.fs_prospects 
  SET email = $1, email_verified = true, enriched_at = NOW()
  WHERE prospect_id = $2;
  
  -- Log enrichment
  INSERT INTO automation.fs_enrichment_log (
    prospect_id, enrichment_type, provider, status, response_data
  ) VALUES ($1, 'email_discovery', 'hunter.io', 'success', $2);
  ```

### **Workflow 04: LinkedIn Intelligence Pipeline**
- 🔄 **Change:** Store detailed LinkedIn data in `automation.fs_linkedin_data`
- Example:
  ```sql
  -- Still update main prospect
  UPDATE automation.fs_prospects 
  SET linkedin_url = $1, enriched_at = NOW()
  WHERE prospect_id = $2;
  
  -- Store detailed LinkedIn data separately
  INSERT INTO automation.fs_linkedin_data (
    prospect_id, linkedin_url, profile_data, recent_posts, scraped_at
  ) VALUES ($1, $2, $3, $4, NOW())
  ON CONFLICT (prospect_id) DO UPDATE
  SET profile_data = EXCLUDED.profile_data,
      recent_posts = EXCLUDED.recent_posts,
      last_updated = NOW();
  ```

### **Workflow 06: AI Lead Qualification Agent**
- 🔄 **Change:** Read from `automation.fs_prospects`, update qualification scores

### **Workflow 07: AI Personalization Agent**
- 🔄 **Change:** Read from `automation.fs_prospects`, update email/linkedin drafts

### **Workflow 08: AI Search Optimizer Agent**
- ✅ No changes needed (or update to use `automation` schema)

### **Workflow 13: Gmail Outreach Sender**
- 🔄 **Change:** Read from `automation.fs_prospects`, log to `automation.fs_email_tracking`
- Example:
  ```sql
  -- Get approved prospects
  SELECT * FROM automation.fs_prospects 
  WHERE approved_for_send = true 
  AND email_sent_at IS NULL
  LIMIT 50;
  
  -- After sending, log it
  INSERT INTO automation.fs_email_tracking (
    prospect_id, campaign_id, email_subject, email_body,
    email_from, email_to, gmail_message_id, gmail_thread_id,
    sent_at, send_status
  ) VALUES (...);
  
  -- Update prospect
  UPDATE automation.fs_prospects 
  SET email_sent_at = NOW(), status = 'contacted'
  WHERE prospect_id = $1;
  ```

---

## 🔍 How to Find & Replace

### In n8n Visual Editor:

1. Open workflow
2. Find all **Postgres** or **Supabase** nodes
3. Click on each node
4. Look for SQL queries
5. Replace:
   - `public.fs_prospects` → `automation.fs_prospects`
   - Or better: Just use `automation.fs_prospects` (always specify schema)

### Example n8n Supabase Node:

**Before:**
```javascript
// Supabase Node - Insert
{
  "table": "fs_prospects",
  "schema": "public",  // ❌ OLD
  "values": {...}
}
```

**After:**
```javascript
// Supabase Node - Insert
{
  "table": "fs_prospects",
  "schema": "automation",  // ✅ NEW
  "values": {...}
}
```

---

## ✅ Testing Your Updates

### 1. Test Query in Supabase Dashboard:
```sql
-- Should return data (or 0 rows if empty)
SELECT COUNT(*) FROM automation.fs_prospects;

-- Should show your new tables
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'automation'
ORDER BY table_name;
```

### 2. Test n8n Workflow:
- Run workflow in test mode
- Check Supabase logs for errors
- Verify data appears in correct schema

### 3. Verify Backward Compatibility:
```sql
-- This still works (view redirects to automation.fs_prospects)
SELECT * FROM public.fs_prospects LIMIT 1;
```

---

## 🆕 New Features You Can Use

### 1. Track All Enrichment Attempts
```sql
-- See enrichment history for a prospect
SELECT 
  enrichment_type,
  provider,
  status,
  created_at
FROM automation.fs_enrichment_log
WHERE prospect_id = 'xxx'
ORDER BY created_at DESC;

-- Find failed enrichments to retry
SELECT * FROM automation.fs_enrichment_log
WHERE status = 'failed'
AND created_at > NOW() - INTERVAL '1 day';
```

### 2. Monitor Workflow Performance
```sql
-- Track workflow success rates
SELECT 
  workflow_name,
  COUNT(*) as runs,
  COUNT(*) FILTER (WHERE status = 'success') as successful,
  AVG(execution_time_seconds) as avg_time
FROM automation.fs_workflow_runs
GROUP BY workflow_name;
```

### 3. Monitor API Usage & Costs
```sql
-- Check API quota usage
SELECT 
  provider,
  api_type,
  quota_used,
  quota_remaining,
  total_cost
FROM automation.fs_api_quotas
WHERE period_start = CURRENT_DATE;

-- Get cost by provider
SELECT 
  provider,
  SUM(total_cost) as monthly_cost
FROM automation.fs_api_quotas
WHERE period_start >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY provider;
```

---

## 🚨 Common Errors & Fixes

### Error: "relation 'fs_prospects' does not exist"
**Fix:** Add schema prefix: `automation.fs_prospects`

### Error: "permission denied for schema automation"
**Fix:** Check Supabase RLS policies - should allow authenticated access

### Error: "column does not exist"
**Fix:** Check column names - some columns moved to separate tables:
- `linkedin_profile_data` → Still in `fs_prospects` (deprecated, use `fs_linkedin_data` table)
- `perplexity_research` → Still in `fs_prospects` (deprecated, use `fs_perplexity_research` table)

---

## 📞 Need Help?

1. Check full documentation: `DATABASE-SCHEMA-ORGANIZATION.md`
2. View schema overview in Supabase:
   ```sql
   SELECT * FROM public.schema_overview;
   ```
3. List automation tables:
   ```sql
   \dt automation.*  -- In psql
   
   -- Or in Supabase SQL Editor:
   SELECT table_name FROM information_schema.tables
   WHERE table_schema = 'automation';
   ```

---

## ✨ Benefits of New Organization

1. **Cleaner Structure:** CRM separate from automation, separate from website
2. **Better Performance:** Smaller, focused schemas
3. **Easier Scaling:** Add new automation types without cluttering
4. **Better Tracking:** New tables for enrichment logs, email tracking, workflow runs
5. **Cost Monitoring:** Track API usage and costs per provider

---

**Ready to update your workflows? Start with one workflow, test it, then roll out to others!**

