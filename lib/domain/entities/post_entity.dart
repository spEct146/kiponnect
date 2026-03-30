import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, authorId, authorName, content, createdAt];
}

class Post extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final List<String>? imageUrls;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isLiked;
  final DateTime createdAt;
  final List<Comment> comments;

  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    this.imageUrls,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isLiked = false,
    required this.createdAt,
    this.comments = const [],
  });

  @override
  List<Object?> get props => [
    id,
    authorId,
    authorName,
    authorAvatar,
    content,
    imageUrls,
    likesCount,
    commentsCount,
    sharesCount,
    isLiked,
    createdAt,
    comments,
  ];
}
