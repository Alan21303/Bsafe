import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsArticle {
  final String id;
  final String title;
  final String description;
  final String url;
  final String author;
  final String image;
  final String published;
  final List<String> category;
  final bool isSafetyRelated;

  NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.author,
    required this.image,
    required this.published,
    required this.category,
    required this.isSafetyRelated,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    final title = json['title'] ?? '';
    final description = json['description'] ?? '';
    
    // Check if the article is safety-related
    final isSafetyRelated = 
        title.toLowerCase().contains('safety') ||
        title.toLowerCase().contains('security') ||
        title.toLowerCase().contains('crime') ||
        title.toLowerCase().contains('police') ||
        title.toLowerCase().contains('emergency') ||
        description.toLowerCase().contains('safety') ||
        description.toLowerCase().contains('security') ||
        description.toLowerCase().contains('crime') ||
        description.toLowerCase().contains('police') ||
        description.toLowerCase().contains('emergency');

    return NewsArticle(
      id: json['id'] ?? '',
      title: title,
      description: description,
      url: json['url'] ?? '',
      author: json['author'] ?? '',
      image: json['image'] != null && json['image'] != 'None' 
          ? json['image'] 
          : 'https://via.placeholder.com/150',
      published: json['published'] ?? '',
      category: List<String>.from(json['category'] ?? []),
      isSafetyRelated: isSafetyRelated,
    );
  }
}

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _articles = [];
  bool _isLoading = false;
  String? _error;

  // TODO: Replace with your actual API key
  static const String _apiKey = 'vPnHYVOA5S9_PmsOBH0OJeGND_ZuOgtk327csRsL8XlsPy4J';
  static const String _baseUrl = 'https://api.currentsapi.services/v1';

  List<NewsArticle> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCrimeNews() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = Uri.parse('$_baseUrl/latest-news?' +
          'category=general' +
          '&language=en' +
          '&apiKey=$_apiKey');
      
      print('Fetching news from: ${url.toString()}');

      final response = await http.get(url);
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['news'] != null && data['news'] is List) {
          _articles = (data['news'] as List)
              .map((article) => NewsArticle.fromJson(article))
              .toList();
          
          // Sort articles to show safety-related ones first
          _articles.sort((a, b) {
            if (a.isSafetyRelated && !b.isSafetyRelated) return -1;
            if (!a.isSafetyRelated && b.isSafetyRelated) return 1;
            return 0;
          });
          
        } else {
          _error = 'Invalid response format from API';
        }
      } else {
        final errorData = json.decode(response.body);
        _error = 'Failed to load news: ${errorData['message'] ?? 'Unknown error'}';
      }
    } catch (e) {
      print('Error fetching news: $e');
      _error = 'Error loading news: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 
