import 'package:equatable/equatable.dart';

class Class extends Equatable {
  final String id;
  final String subject;
  final String room;
  final String teacher;
  final DateTime startTime;
  final DateTime endTime;
  final String day;
  final String? description;

  const Class({
    required this.id,
    required this.subject,
    required this.room,
    required this.teacher,
    required this.startTime,
    required this.endTime,
    required this.day,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    subject,
    room,
    teacher,
    startTime,
    endTime,
    day,
    description,
  ];
}
