import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? avatar;
  final String college;
  final String department;
  final int year;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatar,
    required this.college,
    required this.department,
    required this.year,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    avatar,
    college,
    department,
    year,
    postsCount,
    followersCount,
    followingCount,
    createdAt,
  ];
}
