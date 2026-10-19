import 'package:flutter_test/flutter_test.dart';
import 'package:streetbite/data/models/user_model.dart';

void main() {
  test('UserModelBuilder validates and serializes a user profile', () {
    final user = UserModel.builder()
        .withId('firebase-uid')
        .withName('Assem Ali')
        .withEmail('assem@example.com')
        .build();

    expect(user.name, 'Assem Ali');
    expect(UserModel.fromJson(user.toJson()).email, 'assem@example.com');
  });

  test('UserModelBuilder rejects invalid registration data', () {
    expect(
      () => UserModel.builder()
          .withId('firebase-uid')
          .withName('assem')
          .withEmail('invalid')
          .build(),
      throwsStateError,
    );
  });
}
