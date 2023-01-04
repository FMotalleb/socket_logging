/// this abstract class used to provide cross-platform socket-connection to logger
abstract class SocketConnection<T extends Object?> {
  /// socket connection
  final T socket;

  /// check that socket is still attached to server
  bool get isAttached => false;

  /// sends string value to socket
  void send(String value);

  SocketConnection(this.socket);

  /// since its impossible to use constructor of abstract class
  /// you should use this factory to create connection instances
  factory SocketConnection.from(
    T socket,
  ) {
    throw Exception('this method cannot be called');
  }
}
