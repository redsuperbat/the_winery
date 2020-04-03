import 'package:flutter/widgets.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;

  bool get busy => _busy;


  void setBusy(bool busy) {
    _busy = busy;
    notifyListeners();
  }
}