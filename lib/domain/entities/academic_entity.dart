import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String title;
  final String content;
  final List<String> tags;
  final int upvotes;
  final int downvotes;
  final int answersCount;
  final bool isUpvoted;
  final bool isDownvoted;
  final DateTime createdAt;

  const Question({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.title,
    required this.content,
    this.tags = const [],
    this.upvotes = 0,
    this.downvotes = 0,
    this.answersCount = 0,
    this.isUpvoted = false,
    this.isDownvoted = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    authorId,
    authorName,
    authorAvatar,
    title,
    content,
    tags,
    upvotes,
    downvotes,
    answersCount,
    isUpvoted,
    isDownvoted,
    createdAt,
  ];
}

class Note extends Equatable {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String title;
  final String description;
  final String fileUrl;
  final double rating;
  final int downloads;
  final bool isSaved;
  final DateTime uploadedAt;

  const Note({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.title,
    required this.description,
    required this.fileUrl,
    this.rating = 0.0,
    this.downloads = 0,
    this.isSaved = false,
    required this.uploadedAt,
  });

  @override
  List<Object?> get props => [
    id,
    authorId,
    authorName,
    authorAvatar,
    title,
    description,
    fileUrl,
    rating,
    downloads,
    isSaved,
    uploadedAt,
  ];
}
