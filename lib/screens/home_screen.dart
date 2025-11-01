import 'package:flutter/material.dart';
import 'package:mus_law/screens/profile_screen.dart';
import 'package:mus_law/widgets/bottom_player.dart';
import 'package:mus_law/widgets/music_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Music'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<Map<dynamic, dynamic>>(
                      builder: (_) => const ProfileScreen(),),),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  Text(
                    'Recent',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MusicCard(title: 'Song 1', artist: 'Artist 111'),
                  MusicCard(title: 'Song 123', artist: 'Artist 12413'),
                  MusicCard(title: 'Song 333', artist: 'Artist 5325'),
                  SizedBox(height: 20),
                  Text(
                    'Playlists',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MusicCard(title: 'Epic', artist: '123 songs'),
                  MusicCard(title: 'Cool', artist: '0 songs'),
                ],
              ),
            ),
            const BottomPlayer(),
          ],
        ),);
  }
}
