// main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:sih/services/mongo_service.dart';
import 'firebase_options.dart';
import 'pages/landing_page.dart';
import 'pages/dashboard_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (optional - you can comment this out if not using Firebase)
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // Test API connection on startup
  print('🔄 Initializing CompliScan...');

  try {
    final isHealthy = await MongoService.isHealthy();

    if (isHealthy) {
      print('✅ API connection established successfully!');

      // Check if we have existing data
      final hasData = await MongoService.hasData();
      if (hasData) {
        final stats = await MongoService.getStats();
        if (stats != null) {
          print('📊 Found ${stats['total_products']} products in database');
          print('   - Compliant: ${stats['compliant']}');
          print('   - Non-compliant: ${stats['non_compliant']}');
          print('   - Average score: ${stats['average_score']}%');
        }
      } else {
        print('📝 No existing data found - will use sample data');
      }
    } else {
      print('❌ API connection failed - app will run in offline mode');
      print(
          '   Make sure your Flask API server is running on the configured URL');
    }
  } catch (e) {
    print('❌ API health check failed: $e');
    print('   App will continue with fallback sample data');
  }

  print('🚀 Starting CompliScan application...');
  runApp(CompliScanApp());
}

class CompliScanApp extends StatelessWidget {
  CompliScanApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
    // Handle initial location and error cases
    initialLocation: '/',
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The requested page "${state.uri}" could not be found.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home),
              label: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CompliScan - Legal Metrology Compliance Checker',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      
      // Global error handling
      builder: (context, child) {
        // Handle any global errors or add global wrappers here
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return Scaffold(
            backgroundColor: Colors.red[50],
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bug_report,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'An unexpected error occurred in the application.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    if (kDebugMode) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          errorDetails.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Try to restart the app
                        runApp(CompliScanApp());
                      },
                      child: const Text('Restart App'),
                    ),
                  ],
                ),
              ),
            ),
          );
        };

        return child ?? const SizedBox.shrink();
      },
    );
  }
}
