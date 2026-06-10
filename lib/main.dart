import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SupabaseConfig.initialize();

  runApp(
    const ProviderScope(
      child: PeduliKucingApp(),
    ),
  );
}

class PeduliKucingApp extends StatelessWidget {
  const PeduliKucingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peduli Kucing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
