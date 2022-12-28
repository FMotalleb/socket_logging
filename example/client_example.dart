import 'dart:io';

import 'package:logging/logging.dart';
import 'package:socket_logging/socket_logging.dart';

void main() async {
  final conn = SocketConnection(await WebSocket.connect(
    'ws://127.0.0.1:9090',
  ));
  SocketLogger.I.socketConnection = conn;

  SocketLogger.I.initLogger(Logger.detached('socket_logger'));
  SocketLogger.I.metaData = {
    'name': 'test',
    'id': 16,
  };
  SocketLogger.I.logger.warning(
    'new Warning',
    Exception('Exception'),
    StackTrace.current,
  );
  // conn.socket!.done;
}
