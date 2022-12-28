library socket_logging.logger;

import 'package:logging/logging.dart';
import 'package:socket_logging/socket_logging.dart';

class SocketLogger {
  static SocketLogger get I => instance;
  static final SocketLogger instance = SocketLogger._();
  SocketLogger._();

  Logger get L => logger;

  Logger get logger {
    if (_logger == null) {
      throw Exception('no logger registered');
    }
    return _logger!;
  }

  Logger? _logger;

  void initLogger(Logger logger) {
    _logger = logger;
    logger.onRecord
        .map(
          modelParser,
        )
        .listen(
          record,
        );
  }

  Map<String, dynamic> metaData = {};
  @pragma("vm:prefer-inline")
  LogRecordModel modelParser(
    LogRecord record,
  ) =>
      LogRecordModel.fromLogRecord(
        record,
        metaData: metaData,
      );
  @pragma("vm:prefer-inline")
  Future<void> record(LogRecordModel record) async {
    if (socketConnection == null) {
      return;
    }
    socketConnection?.send(record.toJson());
  }

  SocketConnection? socketConnection;
}
