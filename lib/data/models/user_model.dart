import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        email: (json['email'] ?? '').toString(),
        photoUrl: json['photoUrl']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        if (photoUrl != null) 'photoUrl': photoUrl,
      };

  static UserModelBuilder builder() => UserModelBuilder();
}

/// Step-by-step builder used when registration data becomes available across
/// form validation, Firebase Authentication, and Firestore persistence.
class UserModelBuilder {
  String? _id;
  String? _name;
  String? _email;
  String? _photoUrl;

  UserModelBuilder withId(String value) {
    _id = value.trim();
    return this;
  }

  UserModelBuilder withName(String value) {
    _name = value.trim();
    return this;
  }

  UserModelBuilder withEmail(String value) {
    _email = value.trim();
    return this;
  }

  /// Pre-fills the builder from a stored Firestore profile, falling back to
  /// Firebase Authentication values for fields the document does not contain.
  /// [build] still validates the result, so the profile screen only ever
  /// renders a well-formed [UserModel].
  static UserModelBuilder fromFirestore(
    Map<String, dynamic> data, {
    required String uid,
    String? fallbackName,
    String? fallbackEmail,
  }) {
    String? text(Object? value) {
      final s = value?.toString().trim();
      return s == null || s.isEmpty ? null : s;
    }

    return UserModelBuilder()
        .withId(uid)
        .withName(text(data['name']) ?? fallbackName ?? '')
        .withEmail(text(data['email']) ?? fallbackEmail ?? '')
        .withPhotoUrl(text(data['photoUrl']));
  }

  UserModelBuilder withPhotoUrl(String? value) {
    _photoUrl = value?.trim();
    return this;
  }

  UserModel build() {
    final id = _id ?? '';
    final name = _name ?? '';
    final email = _email ?? '';
    if (id.isEmpty) {
      throw StateError('User id is required.');
    }
    if (name.isEmpty || !RegExp(r'^[A-Z]').hasMatch(name)) {
      throw StateError('Name must begin with an uppercase letter.');
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      throw StateError('A valid email address is required.');
    }
    return UserModel(
      id: id,
      name: name,
      email: email,
      photoUrl: _photoUrl?.isEmpty == true ? null : _photoUrl,
    );
  }
}
