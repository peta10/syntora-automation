# 🗂️ Database Schema Organization

**Project:** Syntora.io Multi-Purpose Database  
**Last Updated:** October 23, 2025  
**Supabase Project:** qcrgacxgwlpltdfpwkiz

---

## 📊 Schema Structure Overview

Your Supabase database is organized into **5 logical schemas** for clean separation of concerns:

| Schema | Purpose | Table Count | Use Case |
|--------|---------|-------------|----------|
| **`public`** | Website & Product Features | 20 tables | Contact forms, time audits, marketplace, Tora AI |
| **`automation`** | Prospect Automation Workflows | 9 tables | Financial services automation, future automations |
| **`crm`** | Internal Business Operations | 77 tables | CRM, tax, productivity, projects, conversations |
| **`analytics`** | Reporting & Dashboards | 0 tables | Cross-schema analytics (future) |
| **`archive`** | Historical Data Storage | 0 tables | Old/inactive records (future) |

---

## 🌐 PUBLIC SCHEMA

**Purpose:** Website functionality and product features accessible to public users.

### Tables in Public Schema:

#### **Website Forms & Submissions**
- `contact_submissions` - Contact form submissions from syntora.io (stays here for website compatibility)

#### **Time Audit Tool**
- `time_audit_sessions` - User time audit sessions
- `time_audit_submissions` - Completed time audit data
- `email_report_logs` - Email delivery tracking for reports

#### **Marketplace**
- `automations` - Published automation workflows
- `automation_categories` - Workflow categories
- `resources` - External tools/resources
- `resource_categories` - Resource categorization
- `industries` - Industry classification
- `automation_opportunities` - Automation opportunity templates

#### **Tora AI Assistant**
- `tora_sessions` - Tora conversation sessions
- `tora_analytics` - Tora usage analytics
- `tora_performance` - Performance metrics
- `tora_tool_patterns` - Tool recommendation patterns

#### **General Purpose**
- `chat_sessions` - Generic chat sessions
- `chat_messages` - Chat message history
- `gemini_messages` - Gemini AI messages
- `logs` - System logs
- `search_analytics` - Search tracking

#### **Registry**
- `schema_registry` - Schema documentation table
- `schema_overview` (view) - Quick schema statistics

### Access Patterns:
```sql
-- Access public tables (default)
SELECT * FROM contact_submissions;
SELECT * FROM automations;
SELECT * FROM tora_sessions;
```

---

## 🤖 AUTOMATION SCHEMA

**Purpose:** All prospect automation workflows (financial services, e-commerce, SaaS, etc.)

### Organization Strategy:
- **Prefix-based "virtual folders"** (e.g., `fs_*`, `ecom_*`, `saas_*`)
- Each automation type gets its own prefix
- Allows querying across automation types easily

### Current Tables (Financial Services):

#### **Core Prospect Management**
- `fs_prospects` - Main prospect database with enrichment data
  - 0 rows currently
  - Moved from `public.fs_prospects` (backward compatibility view exists)

#### **Enrichment & Research**
- `fs_enrichment_log` - Track all enrichment attempts (email, LinkedIn, research)
- `fs_linkedin_data` - Detailed LinkedIn profile intelligence
- `fs_perplexity_research` - Deep AI research from Perplexity

#### **Campaign Management**
- `fs_outreach_campaigns` - Campaign configuration & metrics
- `fs_campaign_prospects` - Link prospects to campaigns

#### **Outreach Tracking**
- `fs_email_tracking` - Email sends, opens, clicks, replies

#### **Workflow Execution**
- `fs_workflow_runs` - n8n workflow execution tracking
- `fs_api_quotas` - API usage limits & costs

### Access Patterns:
```sql
-- Access automation tables
SELECT * FROM automation.fs_prospects;
SELECT * FROM automation.fs_enrichment_log WHERE prospect_id = '...';
SELECT * FROM automation.fs_workflow_runs WHERE status = 'failed';

-- Backward compatibility (for existing n8n workflows)
SELECT * FROM public.fs_prospects;  -- Redirects to automation.fs_prospects
```

### Future Expansion:
- `ecom_*` tables for E-commerce automation
- `saas_*` tables for SaaS prospect automation
- `re_*` tables for Real Estate automation

---

## 💼 CRM SCHEMA

**Purpose:** Internal business operations for your company (Syntora).

### Categories of Tables:

#### **1. Core CRM (17 tables)**
- `profiles` - User profiles (linked to `auth.users`)
- `organizations` - Organization management
- `crm_businesses` - Business/company records (3 rows)
- `crm_contacts` - Contact management (1 row)
- `crm_deals` - Sales deals & pipeline
- `crm_activities` - Calls, meetings, tasks
- `crm_pipeline_stages` - Deal stages (6 rows)
- `crm_products` - Product catalog
- `crm_deal_products` - Products in deals
- `crm_email_campaigns` - Email marketing
- `crm_campaign_recipients` - Campaign tracking
- `crm_invoices` - Invoice management
- `crm_invoice_items` - Invoice line items
- `crm_contact_scores` - Lead scoring
- `crm_marketing_attribution` - Marketing analytics
- `crm_1099_vendors` - 1099 contractor management
- `crm_1099_annual_totals` - Annual 1099 totals
- `airtable_sync_log` - Airtable sync history

#### **2. Accounting & Finance (12 tables)**
- `crm_chart_of_accounts` - Chart of accounts (65 rows)
- `crm_journal_entries` - Accounting journal entries
- `crm_journal_entry_lines` - Journal entry lines
- `crm_expense_categories` - Expense categorization (71 rows)
- `crm_revenue_entries` - Revenue tracking (14 rows)
- `crm_expenses` - Expense management
- `crm_assets` - Asset tracking
- `crm_liabilities` - Liability management
- `crm_equity_transactions` - Equity changes
- `crm_revenue_forecasts` - Revenue forecasting

#### **3. Tax Management (10 tables)**
- `tax_businesses` - Business entities for tax
- `tax_receipts` - Receipt tracking
- `tax_expense_categories` - Tax-specific categories (22 rows)
- `tax_transactions` - Transaction records
- `tax_code_sections` - IRS code reference (4 rows)
- `tax_recommendations` - AI tax recommendations
- `tax_chat_sessions` - Tax assistant conversations
- `tax_chat_messages` - Tax chat history
- `tax_strategies` - Tax strategy templates (5 rows)
- `tax_audit_logs` - Tax audit trail

#### **4. Project Management (15 tables)**
- `projects` - Project tracking
- `tasks` - Task management
- `project_settings` - User project preferences
- `project_activities` - Project activity log
- `project_documents` - Document management
- `project_comments` - Comments & discussions
- `project_milestones` - Project milestones
- `project_dependencies` - Project dependencies
- `project_team_members` - Team assignments
- `project_time_entries` - Time tracking
- `project_risks` - Risk management
- `project_resources` - Resource allocation
- `project_budget_items` - Budget tracking
- `project_kpis` - KPI monitoring
- `project_stakeholders` - Stakeholder management

#### **5. Productivity & Personal (10 tables)**
- `daily_todos` - Daily task list (42 rows)
- `daily_reflections` - Daily reflections
- `todo_templates` - Reusable todo templates (1 row)
- `productivity_analytics` - Productivity metrics
- `daily_email_log` - Daily email tracking
- `gaming_stats` - Gamification stats (1 row)
- `daily_stats_history` - Historical stats (6 rows)
- `achievement_history` - Achievement unlocks
- `bible_verses` - Bible verse collection (25 rows)
- `daily_bible_verse_notifications` - Daily verses (4 rows)

#### **6. AI Assistant & Conversations (13 tables)**
- `conversations` - Conversation threads (1 row)
- `messages` - Message history (4 rows)
- `task_queue` - Task queue from voice/AI (3 rows)
- `learning_events` - AI learning log (2 rows)
- `user_context` - User context for AI
- `conversation_memory` - Conversation history
- `personal_preferences` - User preferences
- `project_knowledge` - Project knowledge base
- `syntora_memory` - Syntora AI memory (4 rows)
- `conversation_intelligence` - Conversation insights (2 rows)
- `agent_performance` - Agent metrics (5 rows)
- `syntora_patterns` - Learned patterns (3 rows)
- `api_usage_logs` - API usage tracking
- `budget_limits` - API budget limits

### Access Patterns:
```sql
-- Access CRM tables
SELECT * FROM crm.crm_contacts;
SELECT * FROM crm.projects WHERE status = 'active';
SELECT * FROM crm.daily_todos WHERE date = CURRENT_DATE;
SELECT * FROM crm.tax_receipts WHERE date >= '2024-01-01';
```

---

## 📈 ANALYTICS SCHEMA

**Purpose:** Reporting, dashboards, and cross-schema analytics.

**Status:** Empty (ready for future use)

### Planned Use:
- Materialized views aggregating data across schemas
- Dashboard queries
- Cross-schema reporting tables
- Performance-optimized read-only tables

### Example Future Tables:
```sql
-- Future analytics tables
analytics.monthly_revenue_summary
analytics.prospect_conversion_funnel
analytics.productivity_trends
analytics.api_cost_analysis
```

---

## 📦 ARCHIVE SCHEMA

**Purpose:** Long-term storage of old/inactive records.

**Status:** Empty (ready for future use)

### Planned Use:
- Move old prospects (>1 year inactive) to `archive.fs_prospects`
- Archive completed projects to `archive.projects`
- Store historical invoices to `archive.crm_invoices`
- Reduce main table sizes for better performance

---

## 🔐 Security & Access Control

### Row Level Security (RLS)

All tables have RLS enabled with authenticated user access:

```sql
-- Example RLS policies
CREATE POLICY "Authenticated users full access" 
  ON automation.fs_prospects 
  FOR ALL TO authenticated 
  USING (true);
```

### Schema Permissions

```sql
-- Authenticated users can access all schemas
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA automation TO authenticated;
GRANT USAGE ON SCHEMA crm TO authenticated;
GRANT USAGE ON SCHEMA analytics TO authenticated;
GRANT USAGE ON SCHEMA archive TO authenticated;
```

---

## 🔄 Migration Notes

### What Was Moved:

**From `public` → `automation`:**
- `fs_prospects` (with backward compatibility view)

**From `public` → `crm`:**
- All `crm_*` tables (businesses, contacts, deals, etc.)
- All `tax_*` tables
- All `project*` tables
- Productivity tables (`daily_todos`, `gaming_stats`, etc.)
- Conversation & AI tables
- `profiles`, `organizations`

### Backward Compatibility:

A view exists for `fs_prospects`:
```sql
-- Old way (still works)
SELECT * FROM public.fs_prospects;

-- New way (preferred)
SELECT * FROM automation.fs_prospects;
```

**Action Required:** Update your n8n workflows to use `automation.fs_prospects` directly.

---

## 🛠️ n8n Workflow Updates

### Required Changes:

#### **All Financial Services Workflows:**
Replace table references:
```javascript
// OLD (will work but deprecated)
INSERT INTO public.fs_prospects ...

// NEW (correct way)
INSERT INTO automation.fs_prospects ...
```

#### **CRM Workflows:**
```javascript
// OLD
SELECT * FROM public.crm_contacts;

// NEW
SELECT * FROM crm.crm_contacts;
```

### Which Workflows Need Updates:

1. ✅ **Prospect Discovery Workflows** (01-16) - Use `automation.fs_prospects`
2. ✅ **Contact Enrichment** - Use `automation.fs_enrichment_log`
3. ✅ **LinkedIn Intelligence** - Use `automation.fs_linkedin_data`
4. ✅ **Gmail Outreach** - Use `automation.fs_email_tracking`
5. ✅ **AI Qualification** - Use `automation.fs_prospects`
6. ✅ **AI Personalization** - Use `automation.fs_prospects`

---

## 📊 Quick Reference Queries

### Check Schema Organization:
```sql
SELECT * FROM public.schema_overview;
```

### Count Tables Per Schema:
```sql
SELECT 
  table_schema,
  COUNT(*) as table_count
FROM information_schema.tables
WHERE table_schema IN ('public', 'automation', 'crm', 'analytics', 'archive')
  AND table_type = 'BASE TABLE'
GROUP BY table_schema;
```

### List All Automation Tables:
```sql
SELECT table_name 
FROM information_schema.tables
WHERE table_schema = 'automation'
ORDER BY table_name;
```

### Check Foreign Key References:
```sql
SELECT 
  tc.table_schema,
  tc.table_name,
  kcu.column_name,
  ccu.table_schema AS foreign_table_schema,
  ccu.table_name AS foreign_table_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema IN ('automation', 'crm')
ORDER BY tc.table_schema, tc.table_name;
```

---

## ✅ Contact Form Protection

**Important:** The `contact_submissions` table **remains in `public` schema** to ensure your website contact form continues working without any code changes.

When you're ready to connect contact submissions to your CRM:
```sql
-- Future: Sync contact_submissions to CRM
INSERT INTO crm.crm_contacts (first_name, last_name, email, company, ...)
SELECT first_name, last_name, email, company_name, ...
FROM public.contact_submissions
WHERE NOT EXISTS (
  SELECT 1 FROM crm.crm_contacts 
  WHERE email = contact_submissions.email
);
```

---

## 🎯 Best Practices

### 1. Always Use Schema-Qualified Names
```sql
-- ✅ Good
SELECT * FROM automation.fs_prospects;
SELECT * FROM crm.crm_contacts;

-- ❌ Bad (ambiguous, may break)
SELECT * FROM fs_prospects;
```

### 2. Future Automation Types
When adding new automation types, follow the prefix convention:
- E-commerce: `ecom_prospects`, `ecom_campaigns`, etc.
- SaaS: `saas_prospects`, `saas_trials`, etc.
- Real Estate: `re_properties`, `re_leads`, etc.

### 3. Archive Old Data
Periodically move inactive records to `archive` schema:
```sql
-- Example: Archive old prospects
INSERT INTO archive.fs_prospects 
SELECT * FROM automation.fs_prospects 
WHERE updated_at < NOW() - INTERVAL '1 year'
  AND status IN ('dead', 'disqualified');

DELETE FROM automation.fs_prospects 
WHERE prospect_id IN (SELECT prospect_id FROM archive.fs_prospects);
```

---

## 📞 Support

For questions about schema organization:
- Check this documentation first
- View schema overview: `SELECT * FROM public.schema_overview`
- Contact: Parker Gawne @ Syntora.io

---

**End of Documentation**

