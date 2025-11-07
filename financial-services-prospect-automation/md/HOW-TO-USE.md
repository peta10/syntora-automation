# 📧 How to Use Your Prospect Automation System

## 🎯 **The Complete Daily Flow**

---

## **Morning (Automatic - 9am)**

### What Happens:
- ✅ Master Orchestrator runs
- ✅ Discovers 15-20 new prospects from Google searches across 7 industries
- ✅ Enriches with emails, phone numbers, company data
- ✅ Gathers LinkedIn intelligence & Perplexity research
- ✅ AI qualifies and grades prospects (A-F)
- ✅ AI generates personalized email & LinkedIn drafts
- ✅ All prospects land in Supabase with `ready_for_outreach = TRUE`

**You don't need to do anything - this runs automatically!**

---

## **Afternoon (Manual Review - 5-10 minutes)**

### Step 1: Open Supabase
1. Go to: https://supabase.com/dashboard
2. Select project: **Syntora.io**
3. Click **Table Editor** → **fs_prospects**

### Step 2: Filter for Ready Prospects
```sql
WHERE ready_for_outreach = TRUE 
AND approved_for_send = FALSE
ORDER BY ai_qualification_score DESC
```

Or use the Supabase UI filter:
- `ready_for_outreach` = `true`
- `approved_for_send` = `false`

### Step 3: Review Each Prospect

For each prospect, review:
- ✅ **Name & Company** - Look legit?
- ✅ **Email verified** - Should be `true`
- ✅ **AI Grade** - A or B preferred
- ✅ **Pain Point Analysis** - Makes sense?
- ✅ **Email Draft** - Read the subject & body
- ✅ **LinkedIn Draft** - Check if personalized well

### Step 4: Edit if Needed (Optional)
- Click into `email_draft` field
- Edit the JSON directly if you want to tweak wording
- Same for `linkedin_draft`

### Step 5: Approve for Sending
For prospects you want to email:
1. Click into the row
2. Set `approved_for_send` to `TRUE`
3. Optionally set `send_priority` (1-10, higher = sent first)
4. Click Save

**Recommended: Approve 5-10 prospects per day**

---

## **Next Morning (Automatic - 9am)**

### What Happens:
- ✅ Workflow 13 runs automatically
- ✅ Loads all prospects where `approved_for_send = TRUE`
- ✅ Sends emails via your Gmail account
- ✅ Updates prospects to `status = 'contacted'`
- ✅ Sets `approved_for_send = FALSE`
- ✅ Records `email_sent_at` timestamp

**No action needed - emails send automatically!**

---

## **LinkedIn Messages (Manual - When You Want)**

### Option 1: From Supabase
1. Open Supabase → **fs_prospects**
2. Filter: `WHERE status = 'contacted'` (or `ready_for_outreach`)
3. Click into `linkedin_draft` field
4. Copy the recommended version
5. Go to LinkedIn
6. Paste and send manually

### Option 2: Export to CSV
1. In Supabase, export filtered prospects to CSV
2. Open in Excel/Sheets
3. Copy LinkedIn messages one by one
4. Send via LinkedIn

---

## **Quick Reference: Prospect Statuses**

| Status | Meaning |
|--------|---------|
| `discovered` | Just found by discovery workflow |
| `enriching` | Getting email/phone/company data |
| `enriched` | Contact info complete |
| `researching` | LinkedIn & Perplexity gathering intel |
| `researched` | Research complete |
| `qualifying` | AI scoring in progress |
| `qualified` | AI score assigned |
| `personalizing` | AI drafting messages |
| `ready_for_outreach` | **Ready for your review** ⭐ |
| `contacted` | Email sent |

---

## **Daily Workflow Summary**

### ☀️ Morning (Auto)
```
9:00am - Discovery & enrichment runs
10:00am - AI qualification runs  
11:00am - AI personalization runs
12:00pm - Prospects ready for review
```

### 🌤️ Afternoon (You - 5-10 min)
```
2:00pm - Review in Supabase
2:05pm - Approve 5-10 prospects
2:10pm - Done!
```

### 🌅 Next Morning (Auto)
```
9:00am - Emails send via Gmail
9:05am - Status updated to 'contacted'
```

### 📱 Whenever (You - 10-15 min)
```
Copy/paste LinkedIn messages manually
Or skip LinkedIn entirely - your choice!
```

---

## **Tips for Best Results**

### ✅ DO:
- Review prospects daily (takes 5 min)
- Approve 5-10 per day (stay under Gmail limits)
- Check AI grades - focus on A & B grades
- Read pain point analysis before approving
- Edit email drafts if something feels off

### ❌ DON'T:
- Don't approve 50+ at once (Gmail limits!)
- Don't skip review - always read AI drafts
- Don't send to unverified emails
- Don't ignore C/D/F grades unless special case

---

## **Monitoring Replies**

### Check Daily:
1. Open Gmail inbox
2. Look for replies from sent prospects
3. When you get a reply:
   - Go to Supabase
   - Find prospect by email
   - Update `email_replied = TRUE`
   - Update `reply_sentiment` (positive/neutral/negative)
   - Add notes in `notes` field

### Optional: Set up Gmail Filter
- Create label: "Prospect Replies"
- Filter: Conversations with prospects
- Auto-label for easy tracking

---

## **Supabase Views for Quick Access**

### View 1: Ready for Review
```sql
SELECT 
  first_name, last_name, company_name, job_title,
  ai_qualification_grade, ai_qualification_score,
  email, phone, linkedin_url,
  email_draft->>'body' as email_preview
FROM fs_prospects
WHERE ready_for_outreach = TRUE 
  AND approved_for_send = FALSE
ORDER BY ai_qualification_score DESC;
```

### View 2: Sent This Week
```sql
SELECT 
  first_name, last_name, company_name,
  email_sent_at,
  email_replied,
  reply_sentiment
FROM fs_prospects
WHERE status = 'contacted'
  AND email_sent_at > NOW() - INTERVAL '7 days'
ORDER BY email_sent_at DESC;
```

### View 3: High Priority Follow-ups
```sql
SELECT 
  first_name, last_name, company_name,
  email, phone, linkedin_url,
  email_sent_at,
  notes
FROM fs_prospects
WHERE email_replied = TRUE
  AND reply_sentiment = 'positive'
  AND meeting_scheduled = FALSE;
```

---

## **What to Do When Someone Replies**

### Positive Reply:
1. Mark `reply_sentiment = 'positive'`
2. Add notes about their interest
3. Schedule a call
4. Mark `meeting_scheduled = TRUE`

### Neutral Reply:
1. Mark `reply_sentiment = 'neutral'`
2. Add notes
3. Consider follow-up in 2 weeks

### Negative Reply:
1. Mark `reply_sentiment = 'negative'`
2. Mark `status = 'disqualified'`
3. Don't contact again

---

## **Troubleshooting**

### No prospects showing up?
- Check if workflows are running (n8n executions)
- Check `status` field - might be stuck at earlier stage
- Check `error_count` - might have errors

### Email not sending?
- Check Gmail API credentials in n8n
- Check daily send limit (500/day)
- Check `email_verified = TRUE`

### Bad AI drafts?
- Edit directly in Supabase before approving
- Adjust AI prompt in Workflow 07 if consistently bad
- Provide feedback in notes for pattern recognition

### LinkedIn URLs missing?
- Normal - not all prospects have LinkedIn
- Focus on email outreach for these

---

## **Your Weekly Stats**

Track in Supabase:
```sql
SELECT 
  COUNT(*) as prospects_discovered,
  SUM(CASE WHEN status = 'contacted' THEN 1 ELSE 0 END) as emails_sent,
  SUM(CASE WHEN email_replied = TRUE THEN 1 ELSE 0 END) as replies_received,
  SUM(CASE WHEN meeting_scheduled = TRUE THEN 1 ELSE 0 END) as meetings_scheduled,
  ROUND(AVG(ai_qualification_score), 1) as avg_quality_score
FROM fs_prospects
WHERE created_at > NOW() - INTERVAL '7 days';
```

---

## **Need Help?**

1. Check workflow execution logs in n8n
2. Check Supabase error logs
3. Review prospect `last_error` field
4. Check `needs_manual_review` flag

**Everything is designed to run automatically with minimal manual work. Just review, approve, and let the system do the rest!** 🚀

