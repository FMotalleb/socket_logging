import 'dart:io';

import '_base_socket.dart' as base;

class SocketConnection extends base.SocketConnection<WebSocket> {
  SocketConnection(
    super.socket,
  );
  @override
  bool get isAttached => (socket.closeCode == null);
  @override
  void send(String value) => socket.add(value);
}
