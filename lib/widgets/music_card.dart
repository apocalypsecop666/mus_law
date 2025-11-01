import 'package:flutter/material.dart';

class MusicCard extends StatelessWidget {
  final String title;
  final String artist;

  const MusicCard({
    required this.title, required this.artist, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: const Icon(Icons.music_note, color: Colors.amber),
      title: Text(title),
      subtitle: Text(artist),
      trailing: const Icon(Icons.play_arrow),
    ),);
  }
}
