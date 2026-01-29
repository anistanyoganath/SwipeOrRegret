import 'dart:async';
import 'dart:ui';

class CountdownTimer {
  Timer? _timer;
  int timeLeft = 3;

  void start(VoidCallback onFinish) {
    timeLeft = 3;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeLeft--;
      if (timeLeft <= 0) {
        timer.cancel();
        onFinish();
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }
}
