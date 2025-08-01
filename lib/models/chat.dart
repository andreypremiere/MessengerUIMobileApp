enum TypeChat { personal, group }

class UserChat {
  final String userId;
  final String displayedNickname;

  UserChat({required this.userId, required this.displayedNickname});

  factory UserChat.fromJson(Map<String, dynamic> json) {
    return UserChat(userId: json['user_id'], displayedNickname: json['displayed_nickname']);
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'displayed_nickname': displayedNickname
    };
  }
}

class Chat {
  final String? chatId;
  final List<UserChat> participants;
  final TypeChat typeChat;
  final UserChat? admin;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // final String? nameChat;

  Chat({
    this.chatId,
    required this.participants,
    this.typeChat = TypeChat.personal,
    this.admin,
    this.name,
    this.createdAt,
    this.updatedAt,
    // this.nameChat
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chat_id'],
      participants: (json['participants'] as List)
          .map((e) => UserChat.fromJson(e))
          .toList(),
      typeChat: TypeChat.values.firstWhere(
        (e) => e.name == json['type_chat'],
        orElse: () => TypeChat.personal,
      ),
      admin: json['admin'] != null ? UserChat.fromJson(json['admin']) : null,
      name: json['name'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      // nameChat: json['name_chat']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'participants': participants.map((e) => e.toJson()).toList(),
      'type_chat': typeChat.name,
      'admin': admin?.toJson(),
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
