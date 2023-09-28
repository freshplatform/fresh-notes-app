import 'dart:async' show Zone;
import 'dart:developer' as dev show log;

import 'package:flutter/foundation.dart' show kDebugMode;
export 'package:logging/src/level.dart';

class AppLogger {
  const AppLogger._();

  static bool shouldLog() {
    return kDebugMode;
  }

  static log(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    StackTrace? stackTrace,
  }) {
    if (!shouldLog()) {
      return;
    }
    dev.log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      name: name,
      zone: zone,
      stackTrace: stackTrace,
    );
  }

  static error(
    String message, {
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!shouldLog()) {
      return;
    }

    dev.log(
      message,
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      name: name,
      zone: zone,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
