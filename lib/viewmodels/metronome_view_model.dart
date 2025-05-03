import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum MetronomeMode { normal, polyRhythm, coach }

class MetronomeViewModel extends ChangeNotifier {
  int bpm = 120;
  int beatCount = 4;
  Duration timerDuration = const Duration(minutes: 5);
  MetronomeMode mode = MetronomeMode.normal;

  Timer? _timer;
  int _currentBeat = 0;

  int get currentBeat => _currentBeat;
  bool get isRunning => _timer?.isActive ?? false;

  void increaseBpm() {
    bpm += 1;
    notifyListeners();
  }

  void decreaseBpm() {
    bpm = max(20, bpm - 1);
    notifyListeners();
  }

  void changeBeatCount(int newCount) {
    beatCount = newCount;
    notifyListeners();
  }

  void setTimer(Duration d) {
    timerDuration = d;
    notifyListeners();
  }

  void toggleMode(MetronomeMode m) {
    mode = m;
    notifyListeners();
  }

  void start() {
    stop();
    _currentBeat = 0;
    _timer = Timer.periodic(
      Duration(milliseconds: (60000 / bpm).round()),
      (_) {
        _currentBeat = (_currentBeat + 1) % beatCount;
        notifyListeners();
        // TODO: 클릭 소리 재생
      },
    );
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _currentBeat = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
