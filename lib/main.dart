import 'package:flutter/material.dart';
import 'package:mus_law/data/repositories/auth_repository.dart';
import 'package:mus_law/data/repositories/user_repository.dart';
import 'package:mus_law/data/sources/api_client.dart';
import 'package:mus_law/data/sources/shared_prefs_storage.dart';
import 'package:mus_law/presentation/providers/auth_provider.dart';
import 'package:mus_law/presentation/providers/connectivity_provider.dart';
import 'package:mus_law/presentation/providers/mqtt_provider.dart';
import 'package:mus_law/presentation/providers/posts_provider.dart'; // Додай цей імпорт
import 'package:mus_law/presentation/screens/home_screen.dart';
import 'package:mus_law/presentation/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = SharedPrefsStorage();
  await storage.init();

  final authRepo = AuthRepository(storage);
  final userRepo = UserRepository(storage);
  final apiClient = ApiClient();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => authRepo),
        Provider<UserRepository>(create: (_) => userRepo),
        Provider<ApiClient>(create: (_) => apiClient),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => MqttProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepo)),
        ChangeNotifierProvider(create: (_) => PostsProvider(apiClient)),
      ],
      child: const MusicApp(),
    ),
  );
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mus Law',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const AppWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // ignore: inference_failure_on_instance_creation
    await Future.delayed(Duration.zero);

    final authProvider = Provider.of<AuthProvider>
        // ignore: use_build_context_synchronously
        (context, listen: false);
    await authProvider.autoLogin();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return authProvider.isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}
