import 'package:flutter/material.dart';
import 'package:mus_law/presentation/screens/dashboard_screen.dart';
import 'package:mus_law/presentation/screens/posts_screen.dart';
import 'package:mus_law/presentation/screens/profile_screen.dart';
import 'package:mus_law/presentation/widgets/bottom_player.dart';
import 'package:mus_law/presentation/widgets/music_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MusicHomeScreen(),
    const DashboardScreen(),
    const PostsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mus Law'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<Map<dynamic, dynamic>>(
                builder: (_) => const ProfileScreen(),
              ),
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        elevation: 2,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class MusicHomeScreen extends StatelessWidget {
  const MusicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              Text(
                'Recently Played',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              MusicCard(title: 'Song 1', artist: 'Artist 1'),
              MusicCard(title: 'Song 2', artist: 'Artist 2'),
              MusicCard(title: 'Song 3', artist: 'Artist 3'),
              SizedBox(height: 20),
              Text(
                'Playlists',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              MusicCard(title: 'Chill', artist: '24 songs'),
              MusicCard(title: 'Workout', artist: '18 songs'),
            ],
          ),
        ),
        const BottomPlayer(),
      ],
    );
  }
}
