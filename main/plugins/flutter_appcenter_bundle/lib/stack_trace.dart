import 'package:stack_trace/stack_trace.dart';

final _obfuscatedStackTraceLineRegExp =
RegExp(r'^(\s*#\d{2} abs )([\da-f]+)((?: virt [\da-f]+)?(?: .*)?)$');

/// Returns a [List] containing detailed output of each line in a stack trace.
List<Map<String, String>> getStackTraceElements(StackTrace stackTrace) {

  final trace = Trace.parseVM(stackTrace.toString()).terse;
  final elements = <Map<String, String>>[];

  for (final frame in trace.frames) {
    if (frame is UnparsedFrame) {
      if (_obfuscatedStackTraceLineRegExp.hasMatch(frame.member)) {

        final method = frame.member.replaceFirstMapped(
            _obfuscatedStackTraceLineRegExp,
                (match) => '${match.group(1)}0${match.group(3)}');
        elements.add(<String, String>{
          'file': '',
          'line': '0',
          'method': method,
        });
      }
    } else {
      final element = <String, String>{
        'file': frame.library,
        'line': frame.line?.toString() ?? '0',
      };
      final member = frame.member ?? '<fn>';
      final members = member.split('.');
      if (members.length > 1) {
        element['method'] = members.sublist(1).join('.');
        element['class'] = members.first;
      } else {
        element['method'] = member;
      }
      elements.add(element);
    }
  }

  return elements;
}
