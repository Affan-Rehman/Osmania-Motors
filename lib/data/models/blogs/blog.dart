import 'dart:convert';
import 'package:http/http.dart' as http;

class BlogPost {
  final int id;
  final String title;
  final String image;
  final String author;
  final String date;
  final String content;

  BlogPost({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.date,
    required this.content,
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['ID'],
      title: json['title'],
      image: json['image'],
      author: json['author'],
      date: json['date'],
      content: json['content'],
    );
  }
}

List<BlogPost> blogPosts = [];
void fetchBlogPosts() async {
  final response = await http.get(Uri.parse(
      'https://osmaniamotors.com/wp-json/stm-mra/v1/oapi_blog_posts'));

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body)['blogs'];
    blogPosts = jsonData.map((data) => BlogPost.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load blog posts');
  }
}
