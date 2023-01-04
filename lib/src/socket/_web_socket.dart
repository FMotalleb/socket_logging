import 'dart:html';

import '_base_socket.dart' as base;

/// this class is example of Socket connection using [WebSocket]html which is not
/// accessible in platforms other than web
class SocketConnection extends base.SocketConnection<WebSocket> {
  SocketConnection(
    super.socket,
  ) {
    socket.onClose.drain().then((value) => isAttached = false);
  }
  factory SocketConnection.from(
    WebSocket socket,
  ) =>
      SocketConnection(socket);
  @override
  bool isAttached = true;
  @override
  void send(String value) => socket.sendString(value);
}
