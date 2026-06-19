import 'package:bcrypt/bcrypt.dart';

class AuthService {
  /// Turns a plain text password into a one-way hash before saving it.
  static String hashPassword(String plainPassword) {
    return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
  }

  /// Compares what the user typed at login against the stored hash.
  /// Never decrypts the hash - it re-hashes the input and compares.
  static bool verifyPassword(String plainPassword, String hashedPassword) {
    return BCrypt.checkpw(plainPassword, hashedPassword);
  }
}
