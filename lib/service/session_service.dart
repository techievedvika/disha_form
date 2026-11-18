import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_session_model.dart';

/// Stores the logged-in user's session (role, org, departments) locally.
/// The server must still enforce permissions; this is for UI only.
class SessionService {
  static const _key = 'user_session';

  static Future<void> save(UserSession s) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, jsonEncode(s.toJson()));
    // keep legacy keys used by existing screens
    await p.setString('user_id', s.userId);
    await p.setString('user_mail', s.email);
  }

  static Future<UserSession?> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_key);
    if (raw == null) return null;
    try {
      return UserSession.fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
    await p.remove('user_id');
    await p.remove('user_mail');
  }
}