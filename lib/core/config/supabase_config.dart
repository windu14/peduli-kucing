import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://ohonmeefuioicdbbsvji.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ob25tZWVmdWlvaWNkYmJzdmppIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA5ODM0MDIsImV4cCI6MjA5NjU1OTQwMn0.wgjwHI5HrY3J1unQgbgN5BmxenLR2qsO0dHb__f3-NM';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      publishableKey: anonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
