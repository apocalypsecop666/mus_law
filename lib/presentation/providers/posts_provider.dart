import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mus_law/data/models/post_model.dart';
import 'package:mus_law/data/sources/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostsProvider with ChangeNotifier {
  final ApiClient _apiClient;

  List<PostModel> _posts = [];
  bool _isLoading = false;
  String _error = '';
  bool _isOffline = false;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isOffline => _isOffline;

  PostsProvider(this._apiClient);

  Future<void> loadPosts() async {
    _isLoading = true;
    _error = '';
    _scheduleNotify();

    try {
      final postsData = await _apiClient.getPosts();
      _posts = postsData.map(PostModel.fromJson).toList();
      await _cachePosts(_posts);
      _isOffline = false;
    } catch (e) {
      _error = 'Failed to load posts: $e';
      _posts = await _getCachedPosts();
      _isOffline = _posts.isNotEmpty;
    } finally {
      _isLoading = false;
      _scheduleNotify();
    }
  }

  Future<void> searchPosts(String query) async {
    if (query.isEmpty) {
      await loadPosts();
      return;
    }

    _isLoading = true;
    _scheduleNotify();

    try {
      final postsData = await _apiClient.searchPosts(query);
      _posts = postsData.map(PostModel.fromJson).toList();
    } catch (e) {
      final cachedPosts = await _getCachedPosts();
      _posts = cachedPosts.where((post) {
        return post.title.toLowerCase().contains(query.toLowerCase()) ||
            post.body.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } finally {
      _isLoading = false;
      _scheduleNotify();
    }
  }

  Future<void> _cachePosts(List<PostModel> posts) async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = posts.map((post) => post.toJson()).toList();
    await prefs.setString('cached_posts', json.encode(postsJson));
  }

  Future<List<PostModel>> _getCachedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_posts');

    if (cachedData != null) {
      final List<dynamic> data = json.decode(cachedData) as List<dynamic>;
      return data
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  void clearError() {
    _error = '';
    _scheduleNotify();
  }

  // Використовуємо Future.microtask для уникнення помилок під час build
  void _scheduleNotify() {
    Future.microtask(notifyListeners);
  }
}
