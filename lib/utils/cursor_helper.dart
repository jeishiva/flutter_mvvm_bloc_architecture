import 'dart:convert';

class CursorHelper {
  static String encode(Map<String, dynamic> payload) {
    return base64Url.encode(utf8.encode(jsonEncode(payload)));
  }

  static Map<String, dynamic>? decode(String? cursor) {
    if (cursor == null) return null;
    try {
      final jsonStr = utf8.decode(base64Url.decode(cursor));
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
