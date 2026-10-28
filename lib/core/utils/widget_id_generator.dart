import 'package:uuid/uuid.dart';

class WidgetIdGenerator {
  static const Uuid _uuid = Uuid();

  static String generate() {
    return _uuid.v4(); // unique 128-bit id
  }
}
