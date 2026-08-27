/// The roles an admissible session can carry.
///
/// A `client` role exists in the wider product but is deliberately absent
/// here: a token naming it is refused at login rather than mapped to a
/// degraded experience.
enum UserRole {
  /// Sees their own book of business.
  advisor,

  /// Sees another advisor's book, after picking one in the FA selector.
  leadership;

  /// Parses a role claim, returning `null` for anything not admissible.
  static UserRole? tryParse(String? value) {
    return UserRole.values.where((role) => role.name == value).firstOrNull;
  }
}

/// The signed-in user, built from the session token's claims.
class User {
  /// Creates a user.
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.role,
    this.advisorId,
  });

  /// Rebuilds a user from [toJson] output or from a token's claim map.
  factory User.fromJson(Map<String, dynamic> json) {
    final role = UserRole.tryParse(json['role'] as String?);
    if (role == null) throw ArgumentError.value(json['role'], 'role', 'Not an admissible role');
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: role,
      advisorId: json['advisorId'] as String?,
    );
  }

  /// Stable user identifier.
  final String id;

  /// Sign-in name.
  final String username;

  /// Contact address, also accepted at sign-in.
  final String email;

  /// Display name.
  final String name;

  /// Which experience this session loads.
  final UserRole role;

  /// The advisor whose book this user owns — `null` for leadership, who pick
  /// one from the FA selector instead.
  final String? advisorId;

  /// Serialises the user for the cached-session snapshot.
  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'name': name,
    'role': role.name,
    'advisorId': advisorId,
  };
}
