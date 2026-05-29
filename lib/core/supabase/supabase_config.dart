class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://rbltthvigaropascfmiu.supabase.co',
  );
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJibHR0aHZpZ2Fyb3Bhc2NmbWl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk5ODc2MjMsImV4cCI6MjA5NTU2MzYyM30.ulw9jb4nhp7tOd4HI4tpK-90bh04pRDg2S4TOdF6I_M',
  );
}
