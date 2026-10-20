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

  group('UserModelBuilder.fromFirestore (profile read path)', () {
    test('builds the profile from the stored document', () {
      final user = UserModelBuilder.fromFirestore(
        {'id': 'ignored', 'name': ' Signup Tester ', 'email': 'qa@example.com'},
        uid: 'uid-1',
      ).build();

      expect(user.id, 'uid-1');
      expect(user.name, 'Signup Tester');
      expect(user.email, 'qa@example.com');
      expect(user.photoUrl, isNull);
    });

    test('falls back to Firebase Authentication values when fields are absent',
        () {
      final user = UserModelBuilder.fromFirestore(
        const {},
        uid: 'uid-2',
        fallbackName: 'Qa Tester',
        fallbackEmail: 'qa2@example.com',
      ).build();

      expect(user.name, 'Qa Tester');
      expect(user.email, 'qa2@example.com');
    });

    test('blank stored values use the fallback instead of failing', () {
      final user = UserModelBuilder.fromFirestore(
        {'name': '   ', 'email': ''},
        uid: 'uid-3',
        fallbackName: 'Fallback Name',
        fallbackEmail: 'fallback@example.com',
      ).build();

      expect(user.name, 'Fallback Name');
    });

    test('invalid stored data is rejected by build()', () {
      expect(
        () => UserModelBuilder.fromFirestore(
          {'name': 'lowercase', 'email': 'not-an-email'},
          uid: 'uid-4',
        ).build(),
        throwsStateError,
      );
    });
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
