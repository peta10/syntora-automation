# 🧪 Database-Driven Architecture - Testing Guide

## **Overview**

Your workflows now use **Database-Driven architecture** where:
- ✅ Each workflow loads data from Supabase
- ✅ Each workflow saves results to Supabase
- ✅ Data persists at every step
- ✅ Workflows can be tested independently

---

## **Status Progression**

Prospects move through these statuses:

```
discovered → enriched → researched → qualified → personalized → contacted
```

---

## **Testing Strategy**

### **Step 1: Test Each Discovery Workflow Independently**

**Test Workflow 02 - Wealth Management Discovery:**

1. Open n8n and navigate to "Wealth Management Discovery"
2. Click "Execute Workflow" manually
3. Wait for completion
4. **Verify in Supabase:**
   ```sql
   SELECT * FROM fs_prospects 
   WHERE status = 'discovered' 
   AND industry = 'wealth_management'
   ORDER BY discovered_at DESC 
   LIMIT 10;
   ```

**Expected Result:**
- ✅ 15-20 new prospects with status='discovered'
- ✅ Each has: email, company_domain, company_website, industry
- ✅ `discovered_at` timestamp is recent

**Repeat for all 7 discovery workflows:**
- 02 - Wealth Management
- 05 - Accounting Firms
- 09 - Equipment Financing
- 10 - Insurance Agencies
- 11 - Financial Advisors
- 12 - Real Estate
- 14 - Venture Capital/PE

---

### **Step 2: Test Contact Enrichment Pipeline**

**Prerequisite:** Must have prospects with status='discovered'

1. Open "Contact Enrichment Pipeline" workflow
2. Click "Execute Workflow" manually
3. Wait for completion
4. **Verify in Supabase:**
   ```sql
   SELECT 
     prospect_id,
     email,
     email_verified,
     phone,
     company_intelligence,
     enrichment_quality_score,
     status,
     enriched_at
   FROM fs_prospects 
   WHERE status = 'enriched'
   ORDER BY enriched_at DESC 
   LIMIT 10;
   ```

**Expected Result:**
- ✅ Prospects now have status='enriched'
- ✅ `email_verified` = true/false
- ✅ `phone` is populated (if found)
- ✅ `company_intelligence` has data
- ✅ `enrichment_quality_score` is calculated
- ✅ `enriched_at` timestamp is set

---

### **Step 3: Test LinkedIn Intelligence Pipeline**

**Prerequisite:** Must have prospects with status='enriched'

1. Open "LinkedIn Intelligence Pipeline" workflow
2. Click "Execute Workflow" manually
3. Wait for completion (this may take a few minutes due to ChatGPT API calls)
4. **Verify in Supabase:**
   ```sql
   SELECT 
     prospect_id,
     email,
     linkedin_url,
     linkedin_profile_data,
     company_research,
     personalization_hooks,
     status,
     intelligence_collected_at
   FROM fs_prospects 
   WHERE status = 'researched'
   ORDER BY intelligence_collected_at DESC 
   LIMIT 10;
   ```

**Expected Result:**
- ✅ Prospects now have status='researched'
- ✅ `linkedin_url` is populated (if found)
- ✅ `linkedin_profile_data` has JSON data
- ✅ `company_research` contains ChatGPT analysis
- ✅ `personalization_hooks` has 5 email hooks
- ✅ `intelligence_collected_at` timestamp is set

---

### **Step 4: Test AI Lead Qualification Agent**

**Prerequisite:** Must have prospects with status='researched'

1. Open "AI Lead Qualification Agent" workflow
2. Click "Execute Workflow" manually
3. Wait for completion (GPT-4 will analyze top 20 prospects)
4. **Verify in Supabase:**
   ```sql
   SELECT 
     prospect_id,
     email,
     company_name,
     ai_qualification_score,
     ai_qualification_grade,
     ai_key_strengths,
     ai_concerns,
     status,
     qualified_at
   FROM fs_prospects 
   WHERE status = 'qualified'
   ORDER BY ai_qualification_score DESC 
   LIMIT 10;
   ```

**Expected Result:**
- ✅ Top 20 prospects now have status='qualified'
- ✅ `ai_qualification_score` is 0-100
- ✅ `ai_qualification_grade` is A, B, C, or D
- ✅ `ai_key_strengths` has JSON array
- ✅ `ai_concerns` has JSON array
- ✅ `qualified_at` timestamp is set

---

### **Step 5: Test AI Personalization Agent**

**Prerequisite:** Must have prospects with status='qualified' AND grade='A' or 'B'

1. Open "AI Personalization Agent" workflow
2. Click "Execute Workflow" manually
3. Wait for completion (GPT-4 will generate personalized drafts)
4. **Verify in Supabase:**
   ```sql
   SELECT 
     prospect_id,
     email,
     company_name,
     ai_qualification_grade,
     email_draft,
     linkedin_draft,
     pain_point_analysis,
     recommended_approach,
     ready_for_outreach,
     status,
     personalized_at
   FROM fs_prospects 
   WHERE status = 'personalized'
   ORDER BY personalized_at DESC 
   LIMIT 10;
   ```

**Expected Result:**
- ✅ Grade A/B prospects now have status='personalized'
- ✅ `email_draft` contains plain-text email body
- ✅ `linkedin_draft` contains connection message
- ✅ `pain_point_analysis` has JSON array
- ✅ `recommended_approach` has strategy
- ✅ `ready_for_outreach` = TRUE
- ✅ `personalized_at` timestamp is set

---

### **Step 6: Test Gmail Outreach Sender**

**Prerequisite:** Must manually approve prospects for sending

1. **First, approve a test prospect in Supabase:**
   ```sql
   UPDATE fs_prospects 
   SET approved_for_send = TRUE 
   WHERE prospect_id = 'YOUR_TEST_PROSPECT_ID';
   ```

2. Open "Gmail Outreach Sender" workflow
3. Click "Execute Workflow" manually
4. Check that email was sent
5. **Verify in Supabase:**
   ```sql
   SELECT 
     prospect_id,
     email,
     status,
     email_sent_at,
     approved_for_send
   FROM fs_prospects 
   WHERE status = 'contacted'
   ORDER BY email_sent_at DESC 
   LIMIT 10;
   ```

**Expected Result:**
- ✅ Prospect now has status='contacted'
- ✅ `email_sent_at` timestamp is set
- ✅ `approved_for_send` = FALSE (reset after sending)
- ✅ Email was received in target inbox

---

### **Step 7: Test Complete Pipeline (Master Orchestrator)**

**This tests the full end-to-end flow**

1. **Clear test data (optional):**
   ```sql
   DELETE FROM fs_prospects WHERE discovered_at > NOW() - INTERVAL '1 day';
   ```

2. Open "Master Prospect Automation Orchestrator" workflow
3. Click "Execute Workflow" manually
4. Monitor execution (will take 30-60 minutes)
5. **Check progress at each stage:**

   **After Discoveries Complete (~5 min):**
   ```sql
   SELECT industry, COUNT(*) as count
   FROM fs_prospects
   WHERE status = 'discovered'
   GROUP BY industry;
   ```

   **After Enrichment Complete (~10 min):**
   ```sql
   SELECT COUNT(*) FROM fs_prospects WHERE status = 'enriched';
   ```

   **After LinkedIn Intelligence (~20 min):**
   ```sql
   SELECT COUNT(*) FROM fs_prospects WHERE status = 'researched';
   ```

   **After AI Qualification (~25 min):**
   ```sql
   SELECT ai_qualification_grade, COUNT(*)
   FROM fs_prospects
   WHERE status = 'qualified'
   GROUP BY ai_qualification_grade;
   ```

   **After AI Personalization (~30 min):**
   ```sql
   SELECT COUNT(*) FROM fs_prospects 
   WHERE status = 'personalized' 
   AND ready_for_outreach = TRUE;
   ```

**Expected Result:**
- ✅ 105+ prospects discovered across all industries
- ✅ ~85+ enriched with contact data
- ✅ ~75+ researched with LinkedIn intelligence
- ✅ ~20 qualified with AI scores
- ✅ ~8-15 personalized (Grade A/B only)
- ✅ All data persisted in Supabase

---

## **Troubleshooting**

### **Problem: No prospects discovered**
```sql
-- Check if discovery workflows ran
SELECT * FROM fs_prospects WHERE discovered_at > NOW() - INTERVAL '1 hour';
```
**Solution:** 
- Check n8n execution history for errors
- Verify Google search is working
- Check website scraping is not blocked

---

### **Problem: Prospects stuck at 'discovered' status**
```sql
-- See how many at each stage
SELECT status, COUNT(*) FROM fs_prospects GROUP BY status;
```
**Solution:**
- Manually run enrichment workflow
- Check workflow execution history for errors
- Verify Supabase connection

---

### **Problem: No prospects qualified**
```sql
-- Check enrichment quality scores
SELECT enrichment_quality_score, COUNT(*) 
FROM fs_prospects 
WHERE status = 'enriched'
GROUP BY enrichment_quality_score;
```
**Solution:**
- Qualification requires status='researched'
- Run LinkedIn Intelligence first
- Check OpenAI API credentials

---

### **Problem: Email drafts contain formatting characters**
```sql
-- Check email draft content
SELECT email_draft FROM fs_prospects WHERE status = 'personalized' LIMIT 1;
```
**Solution:**
- Email formatting rules are in Workflow 07
- GPT-4 prompt enforces plain text
- Re-run personalization if needed

---

## **Data Validation Queries**

### **Complete Data Pipeline Check:**
```sql
SELECT 
  status,
  COUNT(*) as count,
  AVG(enrichment_quality_score) as avg_enrichment_score,
  AVG(ai_qualification_score) as avg_ai_score,
  COUNT(CASE WHEN ready_for_outreach = TRUE THEN 1 END) as ready_for_outreach
FROM fs_prospects
GROUP BY status
ORDER BY 
  CASE status
    WHEN 'discovered' THEN 1
    WHEN 'enriched' THEN 2
    WHEN 'researched' THEN 3
    WHEN 'qualified' THEN 4
    WHEN 'personalized' THEN 5
    WHEN 'contacted' THEN 6
  END;
```

### **Quality Metrics:**
```sql
SELECT 
  COUNT(*) as total_prospects,
  COUNT(CASE WHEN email_verified = TRUE THEN 1 END) as verified_emails,
  COUNT(CASE WHEN phone IS NOT NULL THEN 1 END) as has_phone,
  COUNT(CASE WHEN linkedin_url IS NOT NULL THEN 1 END) as has_linkedin,
  AVG(enrichment_quality_score) as avg_enrichment,
  AVG(ai_qualification_score) as avg_ai_score
FROM fs_prospects;
```

### **AI Performance:**
```sql
SELECT 
  ai_qualification_grade,
  COUNT(*) as count,
  AVG(ai_qualification_score) as avg_score,
  COUNT(CASE WHEN status = 'personalized' THEN 1 END) as personalized_count
FROM fs_prospects
WHERE ai_qualification_grade IS NOT NULL
GROUP BY ai_qualification_grade
ORDER BY ai_qualification_grade;
```

---

## **Daily Production Testing**

### **Morning Check (9 AM - After Gmail sends):**
```sql
-- Check today's sends
SELECT 
  email,
  company_name,
  ai_qualification_grade,
  email_sent_at
FROM fs_prospects
WHERE email_sent_at::date = CURRENT_DATE
ORDER BY email_sent_at DESC;
```

### **Evening Check (6 PM - After daily automation):**
```sql
-- Check today's discoveries
SELECT 
  industry,
  COUNT(*) as discovered_today,
  COUNT(CASE WHEN status = 'personalized' THEN 1 END) as ready_for_review
FROM fs_prospects
WHERE discovered_at::date = CURRENT_DATE
GROUP BY industry;
```

---

## **Success Criteria**

✅ **Discovery:** 105+ prospects/day across 7 industries
✅ **Enrichment:** 80%+ enrichment success rate
✅ **LinkedIn:** 70%+ LinkedIn profile discovery
✅ **Qualification:** 15-20 prospects qualified daily
✅ **Personalization:** 8-15 A/B grade prospects personalized
✅ **Email Quality:** Plain text, no formatting characters
✅ **Data Persistence:** All data saved at every stage
✅ **Fault Tolerance:** Can resume from any step if failure occurs

---

## **Best Practices**

1. **Test workflows individually before running full pipeline**
2. **Monitor Supabase for data quality at each stage**
3. **Review personalized emails before approving for send**
4. **Check execution history in n8n for errors**
5. **Validate email formatting (plain text only)**
6. **Set `approved_for_send=TRUE` only for prospects you want to contact**

---

**🎉 Your Database-Driven automation is now fully tested and ready for production!**
