import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String content;
  final String type; // 'text', 'voice', 'image'
  final bool isDisappearing;
  final DateTime sentAt;
  final DateTime? readAt;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.content,
    this.type = 'text',
    this.isDisappearing = false,
    required this.sentAt,
    this.readAt,
  });

  @override
  List<Object?> get props => [
    id,
    chatId,
    senderId,
    senderName,
    senderAvatar,
    content,
    type,
    isDisappearing,
    sentAt,
    readAt,
  ];
}

class Chat extends Equatable {
  final String id;
  final String name;
  final List<String> participantIds;
  final String? lastMessage;
  final String? lastMessageSenderId;
  final DateTime? lastMessageTime;
  final bool isGroup;
  final String? groupAvatar;
  final int unreadCount;

  const Chat({
    required this.id,
    required this.name,
    required this.participantIds,
    this.lastMessage,
    this.lastMessageSenderId,
    this.lastMessageTime,
    this.isGroup = false,
    this.groupAvatar,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    participantIds,
    lastMessage,
    lastMessageSenderId,
    lastMessageTime,
    isGroup,
    groupAvatar,
    unreadCount,
  ];
}
