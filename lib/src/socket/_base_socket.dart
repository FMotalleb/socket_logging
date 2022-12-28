class SocketConnection<T extends Object?> {
  final T socket;
  bool get isAttached => false;
  void send(String value) {}
  SocketConnection(
    this.socket,
  );
}
