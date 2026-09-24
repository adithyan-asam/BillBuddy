import 'user.dart';

class Session {
  final User user;
  final String token;

  const Session({
    required this.user,
    required this.token,
  });

  factory Session.fromJson(Map<String, Object?> json) {
    return Session(
      user: User.fromJson(
        json['user'] as Map<String, Object?>,
      ),
      token: json['token'] as String,
    );
  }
}