library socket_logging.logger;

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:logging/logging.dart';
import 'package:socket_logging/socket_logging.dart';

import 'log_modes.dart';
part '../models/record_model.dart';

class SocketLogger {
  /// instance of socket logger
  static SocketLogger get I => instance;

  /// instance of socket logger
  static final SocketLogger instance = SocketLogger._();

  /// how message will be sent to socket connection
  ///
  /// * in raw mode its human readable string e.g.: [Warning] message
  /// * in json mode its a json containing any information related to the log
  LogMode logMode = LogMode.json;
  SocketLogger._();

  /// instance of [Logger] attached to this instance
  Logger get L => logger;

  /// instance of [Logger] attached to this instance
  Logger get logger {
    if (_logger == null) {
      throw Exception('no logger registered');
    }
    return _logger!;
  }

  Logger? _logger;

  /// attach [SocketLogger] to [Logger] so every time you log anything using
  /// [logger] it will be sent trough socket connection
  ///
  /// * calling this method at start of application is mandatory
  /// * you can use [Logger.root] so logging using any instance of [Logger]
  /// will be reported to socket connection
  /// * you can use [Logger.detached(<Name>)] to encapsulate socket logger from
  /// other loggers
  void initLogger(Logger logger) {
    _logger = logger;
    logger.onRecord
        .map(
          _modelParser,
        )
        .listen(
          _record,
        );
  }

  /// a metadata that will be passed to any log
  Map<String, dynamic> metaData = {};

  @pragma("vm:prefer-inline")
  _LogRecordModel _modelParser(
    LogRecord record,
  ) =>
      _LogRecordModel.fromLogRecord(
        record,
        metaData: metaData,
      );

  @pragma("vm:prefer-inline")
  Future<void> _record(_LogRecordModel record) async {
    if (socketConnectionGetter == null) {
      return;
    }
    try {
      socketConnectionGetter?.call().then(
        (value) {
          final String data;
          switch (logMode) {
            case LogMode.json:
              data = record.toJson();
              break;
            case LogMode.raw:
              data = record.toFormattedString();
              break;
          }
          value.send(
            data,
          );
        },
      );
    } catch (e, st) {
      log(
        'Error in SocketLogger',
        error: e,
        stackTrace: st,
        level: Level.SHOUT.value,
        name: 'SocketLogger',
        time: DateTime.now(),
        zone: Zone.current,
      );
    }
  }

  /// manage instances of socket connection by yourself
  ///
  /// * do not put heavy load in this method
  /// * make sure your code does not create socket connection each time
  /// this method called
  /// * this method is used to access socket connection each time it tries
  /// to send anything to socket
  ///
  Future<SocketConnection> Function()? socketConnectionGetter;
}
