import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kiponnect/core/theme/app_theme.dart';
import 'package:kiponnect/presentation/providers/local_data_provider.dart';
import 'package:kiponnect/presentation/providers/localization_provider.dart';
import 'package:kiponnect/presentation/screens/auth/splash_screen.dart';
import 'package:kiponnect/presentation/screens/auth/login_screen.dart';
import 'package:kiponnect/presentation/screens/auth/otp_screen.dart';
import 'package:kiponnect/presentation/screens/home/home_screen.dart';
import 'package:kiponnect/presentation/screens/schedule/schedule_screen.dart';
import 'package:kiponnect/presentation/screens/academic/academic_screen.dart';
import 'package:kiponnect/presentation/screens/messenger/messenger_screen.dart';
import 'package:kiponnect/presentation/screens/profile/profile_screen.dart';
import 'package:kiponnect/presentation/screens/profile/edit_profile_screen.dart';
import 'package:kiponnect/presentation/screens/settings/settings_screen.dart';
import 'package:kiponnect/presentation/screens/messenger/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final localDataProvider = LocalDataProvider();
  await localDataProvider.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localDataProvider),
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocalDataProvider, LocalizationProvider>(
      builder: (context, localDataProvider, localizationProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Kiponnect',
          theme: AppTheme.darkTheme,
          locale: Locale(localDataProvider.language),
          home: const SplashScreen(),
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const HomeScreen(),
            '/schedule': (context) => const ScheduleScreen(),
            '/academic': (context) => const AcademicScreen(),
            '/messenger': (context) => const MessengerScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/otp') {
              final email = settings.arguments as String? ?? '';
              return MaterialPageRoute(
                builder: (context) => OtpScreen(email: email),
              );
            } else if (settings.name == '/chat') {
              final args = settings.arguments as Map<String, String>;
              return MaterialPageRoute(
                builder: (context) => ChatScreen(
                  chatName: args['chatName']!,
                  chatId: args['chatId']!,
                ),
              );
            }
            return null;
          },
        );
      },
    );
  }
}
