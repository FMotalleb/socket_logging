import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final server = await HttpServer.bind('0.0.0.0', 9090);
  if (!logFile.existsSync()) {
    print(
      'if you want to capture logs into file create a file named `socket.log`',
    );
  }
  print('server address: ws://${server.address.address}:${server.port}');
  await for (final conn in server) {
    final webConn = await WebSocketTransformer.upgrade(conn);
    await for (final event in webConn) {
      print('new log');
      recordLog(conn.connectionInfo, event);
    }
  }
}

final logFile = File('socket.log');

void recordLog(HttpConnectionInfo? connection, String raw) {
  final buffer = StringBuffer('Log Begin\n');
  if (connection != null) {
    buffer.writeAll(
      [
        'Connection info:',
        '\tip: ${connection.remoteAddress.address}',
        '\tport: ${connection.remotePort}',
        '',
      ],
      '\n',
    );
  } else {
    buffer.writeAll(
      ['Connection info:', '\tNull received', ''],
      '\n',
    );
  }
  Map<String, dynamic>? data;
  try {
    data = jsonDecode(raw);
  } catch (e) {}
  if (data != null) {
    buffer.writeln(asLogEntry(data));
  } else {
    buffer.writeln('Raw: $raw');
  }
  buffer.writeln('Log End');
  buffer.writeln('===========================================');
  if (logFile.existsSync()) {
    logFile.writeAsStringSync(buffer.toString(), mode: FileMode.append);
  } else {
    print(buffer);
  }
}

String asLogEntry(Map<String, dynamic> data) {
  final buffer = StringBuffer();
  buffer.writeln(
    'Record Time: ${DateTime.fromMillisecondsSinceEpoch(data['time']).toLocal().toIso8601String()}',
  );
  buffer.write('[${data['level']}]');
  if (data['logger_name']?.isNotEmpty == true) {
    buffer.write('<${data['logger_name']}>');
  }
  buffer.write(':\n\t');
  buffer.writeln(data['message'].toString().replaceAll('\n', '\n\t'));
  for (final key in [
    'object',
    'error',
    'stack_trace',
    'sequence_number',
    'zone',
  ]) {
    if (data[key]?.toString().isNotEmpty == true) {
      buffer.writeln(
        'Attached $key:\n\t${(data[key]).toString().replaceAll('\n', '\n\t')}',
      );
    }
  }

  if (data['meta_data'].isNotEmpty) {
    buffer.writeln('MetaData:');
    for (final i in Map.from(data['meta_data']).entries) {
      buffer.writeln(
        '\t#${i.key}: \t${i.value.toString().replaceAll('\n', '\n\t\t')}',
      );
    }
  }
  return buffer.toString();
}
