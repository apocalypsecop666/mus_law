import 'package:flutter/material.dart';
import 'package:mus_law/data/repositories/auth_repository.dart';
import 'package:mus_law/data/repositories/user_repository.dart';
import 'package:mus_law/data/sources/auth_local_storage.dart';
import 'package:mus_law/presentation/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = AuthLocalStorage();
  await storage.init();

  final authRepo = AuthRepository(storage);
  final userRepo = UserRepository(storage);

  runApp(MultiProvider(
    providers: [
      Provider<AuthRepository>(
        create: (_) => authRepo,
      ),
      Provider<UserRepository>(
        create: (_) => userRepo,
      ),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mus Law',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
