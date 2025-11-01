import 'package:flutter/material.dart';
import 'package:mus_law/screens/home_screen.dart';
import 'package:mus_law/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 60, color: Colors.amber),
            const Text('Mus Law'),
            const SizedBox(height: 30),
            const TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(
              height: 10,
            ),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute<Map<dynamic, dynamic>>(
                  builder: (_) => const HomeScreen(),
                ),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<Map<dynamic, dynamic>>(
                  builder: (_) => const RegisterScreen(),
                ),
              ),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
