# 🔄 Database-Driven Workflow Rebuild Plan

## **Target Table: `fs_prospects` in Supabase**

All workflows read from and write to: **`fs_prospects`** table

---

## **Workflow Rebuild Strategy:**

### **Discovery Workflows (2, 5, 9-12, 14) - 7 Total**

**Pattern:**
```
1. Generate search queries
2. Execute Google searches
3. Parse and extract websites
4. Scrape team/contact pages
5. Extract prospect data
6. Filter valid prospects
7. ✅ INSERT INTO fs_prospects (NEW)
8. Return summary
```

**Supabase Operation:** `INSERT`
**Target Table:** `fs_prospects`
**Fields to Save:**
- email
- company_domain
- company_website
- industry
- discovery_source
- status = 'discovered'
- discovered_at = NOW()

---

### **Enrichment Workflow (3)**

**Pattern:**
```
1. ✅ LOAD FROM fs_prospects WHERE status='discovered' (NEW)
2. Validate emails
3. Find phone numbers
4. Scrape company data
5. Calculate quality score
6. ✅ UPDATE fs_prospects SET enrichment data (NEW)
7. Return summary
```

**Supabase Operations:**
- `SELECT` WHERE status = 'discovered'
- `UPDATE` SET:
  - email_verified
  - phone
  - company_intelligence
  - enrichment_quality_score
  - status = 'enriched'
  - enriched_at = NOW()

---

### **LinkedIn Intelligence Workflow (4)**

**Pattern:**
```
1. ✅ LOAD FROM fs_prospects WHERE status='enriched' (NEW)
2. Search LinkedIn profiles
3. ChatGPT deep research
4. Extract profile data
5. Generate personalization hooks
6. ✅ UPDATE fs_prospects SET linkedin data (NEW)
7. Return summary
```

**Supabase Operations:**
- `SELECT` WHERE status = 'enriched'
- `UPDATE` SET:
  - linkedin_url
  - linkedin_profile_data
  - company_research
  - personalization_hooks
  - status = 'researched'
  - intelligence_collected_at = NOW()

---

### **AI Qualification Workflow (6)**

**Pattern:**
```
1. ✅ LOAD FROM fs_prospects WHERE status='researched' (NEW)
2. GPT-4 analyzes prospects
3. Calculate scores and grades
4. ✅ UPDATE fs_prospects SET qualification data (NEW)
5. Return summary
```

**Supabase Operations:**
- `SELECT` WHERE status = 'researched'
- `UPDATE` SET:
  - ai_qualification_score
  - ai_qualification_grade
  - ai_key_strengths
  - ai_concerns
  - status = 'qualified'
  - qualified_at = NOW()

---

### **AI Personalization Workflow (7)**

**Pattern:**
```
1. ✅ LOAD FROM fs_prospects WHERE status='qualified' AND grade IN ('A','B') (NEW)
2. GPT-4 deep research
3. Generate email drafts
4. Generate LinkedIn drafts
5. ✅ UPDATE fs_prospects SET personalization data (NEW)
6. Return summary
```

**Supabase Operations:**
- `SELECT` WHERE status = 'qualified' AND ai_qualification_grade IN ('A', 'B')
- `UPDATE` SET:
  - email_draft
  - linkedin_draft
  - pain_point_analysis
  - recommended_approach
  - ready_for_outreach = TRUE
  - status = 'personalized'
  - personalized_at = NOW()

---

### **Gmail Outreach Workflow (13)**

**Pattern:**
```
1. ✅ LOAD FROM fs_prospects WHERE approved_for_send=TRUE LIMIT 20 (NEW)
2. Prepare emails
3. Send via Gmail
4. ✅ UPDATE fs_prospects SET sent status (NEW)
5. Done
```

**Supabase Operations:**
- `SELECT` WHERE approved_for_send = TRUE AND status = 'personalized' LIMIT 20
- `UPDATE` SET:
  - status = 'contacted'
  - email_sent_at = NOW()
  - approved_for_send = FALSE

---

### **Master Orchestrator (1)**

**New Behavior:**
```
1. Trigger all 7 discovery workflows (parallel)
2. Wait for all to complete
3. Trigger enrichment workflow
4. Wait for completion
5. Trigger LinkedIn intelligence
6. Wait for completion
7. Trigger AI qualification
8. Wait for completion
9. Trigger AI personalization
10. Wait for completion
11. Done - all data in Supabase ready for review
```

**No Supabase Operations** - Just triggers workflows

---

## **Status Progression:**

```
discovered → enriched → researched → qualified → personalized → contacted
```

---

## **Deduplication Strategy:**

**Use `email_hash` column (already exists)**
- Hash = MD5 of lowercase trimmed email
- On INSERT: Check if email_hash exists
- If exists: Skip (don't insert duplicate)
- If new: Insert

---

## **Error Handling:**

**Per Workflow:**
- `continueOnFail: true` on all external HTTP requests
- Failed prospects skip to next
- Successful prospects continue

**Orchestrator Level:**
- If discovery workflow fails: Continue with other discoveries
- If processing workflow fails: Log error, continue to next stage
- Partial success is OK

---

## **Batch Processing:**

**Discovery:** Process all search queries (no batch limit)
**Enrichment:** Process all discovered prospects (no batch limit)
**LinkedIn:** Process all enriched prospects (no batch limit)
**AI Qualification:** Process all researched prospects (no batch limit)
**AI Personalization:** Process only Grade A/B (filtered by query)
**Gmail Sending:** LIMIT 20 per batch (respects Gmail limits)

---

## **Rebuild Order:**

1. ✅ Discovery workflows (7) - Add INSERT nodes
2. ✅ Enrichment workflow - Add LOAD and UPDATE nodes
3. ✅ LinkedIn workflow - Add LOAD and UPDATE nodes
4. ✅ AI Qualification workflow - Add LOAD and UPDATE nodes
5. ✅ AI Personalization workflow - Add LOAD and UPDATE nodes
6. ✅ Gmail workflow - Add LOAD and UPDATE nodes
7. ✅ Master Orchestrator - Update to just trigger (no data passing)

---

## **Testing After Rebuild:**

```
1. Test Discovery:
   → Run manually
   → Check Supabase: SELECT * FROM fs_prospects WHERE status='discovered'
   → Should see new prospects ✅

2. Test Enrichment:
   → Run manually
   → Check Supabase: SELECT * FROM fs_prospects WHERE status='enriched'
   → Should see enrichment data ✅

3. Test LinkedIn:
   → Run manually
   → Check Supabase: SELECT * FROM fs_prospects WHERE status='researched'
   → Should see linkedin_url and company_research ✅

4. Test AI Qualification:
   → Run manually
   → Check Supabase: SELECT * FROM fs_prospects WHERE status='qualified'
   → Should see ai_qualification_grade ✅

5. Test AI Personalization:
   → Run manually
   → Check Supabase: SELECT * FROM fs_prospects WHERE ready_for_outreach=TRUE
   → Should see email_draft and linkedin_draft ✅

6. Test Gmail:
   → Manually set approved_for_send=TRUE for 1 prospect
   → Run manually
   → Check Supabase: SELECT * FROM fs_prospects WHERE status='contacted'
   → Should see email_sent_at ✅

7. Test Full Pipeline:
   → Run Master Orchestrator manually
   → Watch each stage complete
   → Check Supabase after each stage
   → Verify data flows correctly ✅
```

---

## **Supabase Credential Configuration:**

**All workflows will use:**
```
Credential Name: Supabase - Syntora
Host: https://qcrgacxgwlpltdfpwkiz.supabase.co
Service Role Key: [Your service_role key]
```

**You'll need to link this credential in n8n to every Supabase node.**

---

**Ready to rebuild! Starting now...**
