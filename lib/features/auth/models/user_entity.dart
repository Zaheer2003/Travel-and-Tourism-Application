import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_entity.freezed.dart';

/// Domain entity for User
/// This represents the core business logic model
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String uid,
    required String? email,
    required String displayName,
    required String? photoURL,
    required bool isAnonymous,
    DateTime? lastLogin,
  }) = _UserEntity;

  const UserEntity._();

  /// Check if user is authenticated
  bool get isAuthenticated => uid.isNotEmpty;

  /// Get user initials for avatar
  String get initials {
    if (displayName.isEmpty) return '?';
    final parts = displayName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName[0].toUpperCase();
  }

  /// Get display name or fallback
  String get displayNameOrEmail => displayName.isNotEmpty ? displayName : email ?? 'User';
}

extension UserExtension on User {
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName ?? '',
      photoURL: photoURL,
      isAnonymous: isAnonymous,
      lastLogin: metadata.lastSignInTime,
    );
  }
}








