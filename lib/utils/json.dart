import 'dart:convert';
import 'dart:developer';

class JsonUtils {
  static void print(Map<String, dynamic> json) {
    final encoder = JsonEncoder.withIndent('  ');
    final prettyprint = encoder.convert(json);
    log(prettyprint);
  }

  static dynamic decode(String source) {
    return json.decode(source);
  }
}
