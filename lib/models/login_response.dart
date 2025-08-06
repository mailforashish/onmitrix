import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String id;
  final String email;
  final String name;
  final String token;
  final String? photoUrl;

  const LoginResponse({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    this.photoUrl,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  LoginResponse copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    String? photoUrl,
  }) {
    return LoginResponse(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  String toString() {
    return 'LoginResponse(id: $id, email: $email, name: $name, token: $token, photoUrl: $photoUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginResponse &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.token == token &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        token.hashCode ^
        photoUrl.hashCode;
  }
}