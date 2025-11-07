-- Commercial Real Estate Property Research Database Schema
-- For Supabase PostgreSQL

-- Table 1: Properties
CREATE TABLE IF NOT EXISTS cre_properties (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  address TEXT NOT NULL,
  street TEXT,
  city TEXT,
  state TEXT,
  zip_code TEXT,
  county TEXT,
  property_type TEXT,
  email TEXT,
  status TEXT DEFAULT 'processing',
  created_at TIMESTAMP DEFAULT NOW(),
  completed_at TIMESTAMP,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Table 2: Documents
CREATE TABLE IF NOT EXISTS cre_documents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID REFERENCES cre_properties(id) ON DELETE CASCADE,
  document_type TEXT NOT NULL,
  document_category TEXT,
  source TEXT,
  extracted_data JSONB,
  status TEXT DEFAULT 'pending',
  retrieved_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Table 3: Property Analysis
CREATE TABLE IF NOT EXISTS cre_property_analysis (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  property_id UUID REFERENCES cre_properties(id) ON DELETE CASCADE,
  analysis_data JSONB NOT NULL,
  completeness_score FLOAT,
  generated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_documents_property_id ON cre_documents(property_id);
CREATE INDEX IF NOT EXISTS idx_documents_type ON cre_documents(document_type);
CREATE INDEX IF NOT EXISTS idx_properties_status ON cre_properties(status);
CREATE INDEX IF NOT EXISTS idx_analysis_property_id ON cre_property_analysis(property_id);

-- Enable Row Level Security (optional but recommended)
ALTER TABLE cre_properties ENABLE ROW LEVEL SECURITY;
ALTER TABLE cre_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE cre_property_analysis ENABLE ROW LEVEL SECURITY;

-- Create policies (adjust based on your needs)
-- Allow authenticated users to read their own data
CREATE POLICY "Users can read own properties"
  ON cre_properties FOR SELECT
  USING (auth.uid()::text = email);

CREATE POLICY "Users can read own documents"
  ON cre_documents FOR SELECT
  USING (
    property_id IN (
      SELECT id FROM cre_properties WHERE email = auth.uid()::text
    )
  );

CREATE POLICY "Users can read own analysis"
  ON cre_property_analysis FOR SELECT
  USING (
    property_id IN (
      SELECT id FROM cre_properties WHERE email = auth.uid()::text
    )
  );

-- Allow service role to insert (for n8n workflows)
CREATE POLICY "Service role can insert properties"
  ON cre_properties FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Service role can insert documents"
  ON cre_documents FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Service role can insert analysis"
  ON cre_property_analysis FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Service role can update properties"
  ON cre_properties FOR UPDATE
  USING (true);

