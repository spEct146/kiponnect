import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:kiponnect/domain/entities/post_entity.dart';

class LocalDataProvider extends ChangeNotifier {
  // In-memory data
  List<Post> _posts = [];
  List<Map<String, dynamic>> _schedule = [];
  List<Map<String, dynamic>> _qaQuestions = [];
  
  // User profile
  Map<String, dynamic> _userProfile = {
    'id': '1',
    'email': 'john.doe@example.com',
    'fullName': 'John Doe',
    'college': 'Example University',
    'department': 'Computer Science',
    'year': 3,
    'postsCount': 0,
    'followersCount': 0,
    'followingCount': 0,
    'createdAt': DateTime.now().toIso8601String(),
  };
  
  // App settings
  String _language = 'en';
  
  // Getters
  List<Post> get posts => _posts;
  List<Map<String, dynamic>> get schedule => _schedule;
  List<Map<String, dynamic>> get qaQuestions => _qaQuestions;
  Map<String, dynamic> get userProfile => _userProfile;
  String get language => _language;
  
  // Initialization
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load user profile
    final profileJson = prefs.getString('userProfile');
    if (profileJson != null) {
      _userProfile = json.decode(profileJson);
    }
    
    // Load language
    _language = prefs.getString('language') ?? 'en';
    
    // Load posts
    final postsJson = prefs.getString('posts');
    if (postsJson != null) {
      final postsData = json.decode(postsJson) as List;
      _posts = postsData.map((postData) => Post(
        id: postData['id'],
        authorId: postData['authorId'] ?? '1',
        authorName: postData['authorName'],
        authorAvatar: postData['authorAvatar'],
        content: postData['content'],
        imageUrls: postData['imageUrls'] != null ? List<String>.from(postData['imageUrls']) : null,
        likesCount: postData['likesCount'] ?? 0,
        commentsCount: postData['commentsCount'] ?? 0,
        sharesCount: postData['sharesCount'] ?? 0,
        isLiked: postData['isLiked'] ?? false,
        createdAt: DateTime.parse(postData['createdAt']),
        comments: postData['comments'] != null 
          ? (postData['comments'] as List).map((commentData) => Comment(
              id: commentData['id'],
              authorId: commentData['authorId'],
              authorName: commentData['authorName'],
              content: commentData['content'],
              createdAt: DateTime.parse(commentData['createdAt']),
            )).toList()
          : [],
      )).toList();
    } else {
      // Default posts
      _posts = [
        Post(
          id: '1',
          authorId: '1',
          authorName: 'John Doe',
          content: 'Just finished my CS project! Feeling proud of what we\'ve accomplished. Open to feedback!',
          imageUrls: null,
          likesCount: 124,
          commentsCount: 32,
          sharesCount: 8,
          isLiked: false,
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
        ),
        Post(
          id: '2',
          authorId: '2',
          authorName: 'Sarah Smith',
          content: 'Anyone looking for study partners for the Math exam next week? Let\'s prepare together!',
          imageUrls: null,
          likesCount: 89,
          commentsCount: 45,
          sharesCount: 12,
          isLiked: true,
          createdAt: DateTime.now().subtract(Duration(hours: 4)),
        ),
      ];
    }
    
    // Load schedule
    final scheduleJson = prefs.getString('schedule');
    if (scheduleJson != null) {
      _schedule = List<Map<String, dynamic>>.from(json.decode(scheduleJson));
    } else {
      // Default schedule
      _schedule = [
        {
          'id': '1',
          'time': '09:00 - 10:30',
          'subject': 'Data Structures',
          'room': '301',
          'teacher': 'Dr. Smith',
          'isCurrent': true,
        },
        {
          'id': '2',
          'time': '11:00 - 12:30',
          'subject': 'Algorithms',
          'room': '305',
          'teacher': 'Prof. Johnson',
          'isCurrent': false,
        },
        {
          'id': '3',
          'time': '14:00 - 15:30',
          'subject': 'Database Design',
          'room': '201',
          'teacher': 'Dr. Williams',
          'isCurrent': false,
        },
      ];
    }
    
    // Load Q&A
    final qaJson = prefs.getString('qaQuestions');
    if (qaJson != null) {
      _qaQuestions = List<Map<String, dynamic>>.from(json.decode(qaJson));
    } else {
      // Default Q&A
      _qaQuestions = [
        {
          'id': '1',
          'title': 'How do I solve differential equations?',
          'tags': ['Math'],
          'upvotes': 42,
          'answersCount': 8,
        },
        {
          'id': '2',
          'title': 'Best practices for Flutter state management?',
          'tags': ['Programming'],
          'upvotes': 67,
          'answersCount': 15,
        },
      ];
    }
    
    notifyListeners();
  }
  
  // User Profile
  Future<void> updateUserProfile(Map<String, dynamic> profile) async {
    _userProfile = profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfile', json.encode(_userProfile));
    notifyListeners();
  }
  
  // Language
  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _language);
    notifyListeners();
  }
  
  // Posts
  Future<void> addPost({
    required String authorName,
    required String content,
    List<String>? imageUrls,
  }) async {
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: '1', // Current user ID
      authorName: authorName,
      content: content,
      imageUrls: imageUrls,
      createdAt: DateTime.now(),
    );
    _posts.insert(0, newPost);
    await _savePosts();
    notifyListeners();
  }
  
  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final updatedPost = Post(
        id: post.id,
        authorId: post.authorId,
        authorName: post.authorName,
        authorAvatar: post.authorAvatar,
        content: post.content,
        imageUrls: post.imageUrls,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
        commentsCount: post.commentsCount,
        sharesCount: post.sharesCount,
        isLiked: !post.isLiked,
        createdAt: post.createdAt,
        comments: post.comments,
      );
      _posts[index] = updatedPost;
      await _savePosts();
      notifyListeners();
    }
  }
  
  Future<void> addComment(String postId, String authorName, String content) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final newComment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: '1', // Current user ID
        authorName: authorName,
        content: content,
        createdAt: DateTime.now(),
      );
      final updatedComments = [...post.comments, newComment];
      final updatedPost = Post(
        id: post.id,
        authorId: post.authorId,
        authorName: post.authorName,
        authorAvatar: post.authorAvatar,
        content: post.content,
        imageUrls: post.imageUrls,
        likesCount: post.likesCount,
        commentsCount: post.commentsCount + 1,
        sharesCount: post.sharesCount,
        isLiked: post.isLiked,
        createdAt: post.createdAt,
        comments: updatedComments,
      );
      _posts[index] = updatedPost;
      await _savePosts();
      notifyListeners();
    }
  }
  
  Future<void> clearAllPosts() async {
    _posts.clear();
    await _savePosts();
    notifyListeners();
  }
  
  Future<void> _savePosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = _posts.map((post) => {
      'id': post.id,
      'authorId': post.authorId,
      'authorName': post.authorName,
      'authorAvatar': post.authorAvatar,
      'content': post.content,
      'imageUrls': post.imageUrls,
      'likesCount': post.likesCount,
      'commentsCount': post.commentsCount,
      'sharesCount': post.sharesCount,
      'isLiked': post.isLiked,
      'createdAt': post.createdAt.toIso8601String(),
      'comments': post.comments.map((comment) => {
        'id': comment.id,
        'authorId': comment.authorId,
        'authorName': comment.authorName,
        'content': comment.content,
        'createdAt': comment.createdAt.toIso8601String(),
      }).toList(),
    }).toList();
    await prefs.setString('posts', json.encode(postsJson));
  }
  
  // Schedule
  Future<void> addClass(Map<String, dynamic> classItem) async {
    classItem['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    _schedule.add(classItem);
    await _saveSchedule();
    notifyListeners();
  }
  
  Future<void> updateClass(String id, Map<String, dynamic> classItem) async {
    final index = _schedule.indexWhere((c) => c['id'] == id);
    if (index != -1) {
      _schedule[index] = classItem;
      await _saveSchedule();
      notifyListeners();
    }
  }
  
  Future<void> deleteClass(String id) async {
    _schedule.removeWhere((c) => c['id'] == id);
    await _saveSchedule();
    notifyListeners();
  }
  
  Future<void> _saveSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('schedule', json.encode(_schedule));
  }
  
  // Q&A
  Future<void> addQuestion(Map<String, dynamic> question) async {
    question['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    _qaQuestions.insert(0, question);
    await _saveQA();
    notifyListeners();
  }
  
  Future<void> _saveQA() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('qaQuestions', json.encode(_qaQuestions));
  }
}