import 'dart:async';

// import 'package:flutter/material.dart';

class Debounce {
  Timer? _timer;

  void call(Duration duration, void Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}
