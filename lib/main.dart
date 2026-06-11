import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:peduli_kucing/features/home/presentation/screens/main_screen.dart';
import 'package:peduli_kucing/features/auth/presentation/screens/login_screen.dart';
import 'package:peduli_kucing/features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SupabaseConfig.initialize();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    const ProviderScope(
      child: PeduliKucingApp(),
    ),
  );
}

class PeduliKucingApp extends ConsumerWidget {
  const PeduliKucingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Peduli Kucing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: authState.when(
        data: (state) {
          if (state.session != null) {
            return const MainScreen();
          }
          return const LoginScreen();
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, st) => const LoginScreen(),
      ),
    );
  }
}
