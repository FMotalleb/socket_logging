import 'dart:html';

import '_base_socket.dart' as base;

class SocketConnection extends base.SocketConnection<WebSocket> {
  SocketConnection(
    super.socket,
  ) {
    socket.onClose.drain().then((value) => isAttached = false);
  }
  bool isAttached = true;
  @override
  void send(String value) => socket.sendString(value);
}
