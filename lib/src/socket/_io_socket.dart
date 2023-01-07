import 'dart:io' show WebSocket;

import 'package:meta/meta.dart';

import '_base_socket.dart' as base;

/// this class is example of Socket connection using [WebSocket]io which is not
/// accessible in web platform
@internal
class SocketConnection extends base.SocketConnection<WebSocket> {
  @internal
  SocketConnection(
    super.socket,
  );
  @internal
  factory SocketConnection.from(
    WebSocket socket,
  ) =>
      SocketConnection(socket);
  @override
  bool get isAttached => (socket.closeCode == null);
  @override
  void send(String value) => socket.add(value);
}
