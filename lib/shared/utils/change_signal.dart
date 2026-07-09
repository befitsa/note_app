import 'package:flutter/foundation.dart';

class ChangeSignal extends ChangeNotifier {
  void bump() => notifyListeners();
}
