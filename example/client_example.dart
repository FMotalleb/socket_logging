import 'dart:io';

import 'package:logging/logging.dart';
import 'package:socket_logging/socket_logging.dart';

void main() async {
  WebSocket client = await WebSocket.connect(
    'ws://127.0.0.1:9090',
  );
  client.pingInterval = const Duration(milliseconds: 300);
  SocketConnection conn = SocketConnection(client);
  SocketLogger.I.initLogger(Logger.detached('socket_logger'));
  SocketLogger.I.socketConnectionGetter = () async {
    if (conn.isAttached) {
      return conn;
    } else {
      client = await WebSocket.connect(
        'ws://127.0.0.1:9090',
      );
      client.pingInterval = const Duration(milliseconds: 300);
      conn = SocketConnection(client);
    }
    return conn;
  };

  SocketLogger.I.metaData = {
    'name': 'test',
    'id': 16,
  };
  while (true) {
    await Future.delayed(const Duration(seconds: 2), () {
      SocketLogger.I.logger.warning(
        'new Warning',
        Exception('Exception'),
        StackTrace.current,
      );
    });
  }
  print(conn);
  // conn.socket!.done;
}
