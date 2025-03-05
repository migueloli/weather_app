import 'package:flutter_test/flutter_test.dart';

class QueryParametersMatcher extends Matcher {
  QueryParametersMatcher(this.expected);

  final Map<String, dynamic> expected;

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Map<String, dynamic>) return false;

    for (final entry in expected.entries) {
      if (!item.containsKey(entry.key) || item[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('query parameters matching $expected');
  }
}
