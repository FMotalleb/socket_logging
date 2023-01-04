import 'dart:developer';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:socket_logging/socket_logging.dart';
import 'package:socket_logging/src/logger/log_modes.dart';

void main() async {
  WebSocket client = await WebSocket.connect(
    'ws://127.0.0.1:9090',
  );
  client.pingInterval = const Duration(milliseconds: 300);
  SocketConnection conn = SocketConnection.from(client);
  SocketLogger.I.initLogger(Logger.root);
  SocketLogger.I.logMode = LogMode.raw;
  SocketLogger.I.socketConnectionGetter = () async {
    if (conn.isAttached) {
      return conn;
    } else {
      client = await WebSocket.connect(
        'ws://127.0.0.1:9090',
      );
      client.pingInterval = const Duration(milliseconds: 300);
      conn = SocketConnection.from(client);
    }
    return conn;
  };

  SocketLogger.I.metaData = {
    'name': 'test',
    'id': 16,
  };
  while (true) {
    await Future.delayed(const Duration(seconds: 2), () {
      Logger('test').info('mamad');
    });
  }
  print(conn);
  // conn.socket!.done;
}
