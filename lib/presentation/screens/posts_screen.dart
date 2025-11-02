import 'package:flutter/material.dart';
import 'package:mus_law/presentation/providers/posts_provider.dart';
import 'package:mus_law/presentation/widgets/post_item.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Використовуємо addPostFrameCallback для безпечного завантаження
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPosts();
      _isInitialized = true;
    });
  }

  void _loadPosts() {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    postsProvider.loadPosts();
  }

  void _searchPosts(String query) {
    final postsProvider = Provider.of<PostsProvider>(context, listen: false);
    postsProvider.searchPosts(query);
  }

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPosts,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search posts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _searchPosts,
            ),
          ),
          if (postsProvider.isOffline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.orange[100],
              child: Row(
                children: [
                  const Icon(Icons.wifi_off, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    'Offline mode - showing cached data',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange[800],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _buildContent(postsProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(PostsProvider postsProvider) {
    // Не показуємо loading поки не ініціалізовано
    if (!_isInitialized || postsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (postsProvider.error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                postsProvider.error,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPosts,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (postsProvider.posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No posts found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: postsProvider.posts.length,
      itemBuilder: (context, index) {
        final post = postsProvider.posts[index];
        return PostItem(post: post);
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
