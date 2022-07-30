import 'package:flutter/cupertino.dart';

class WerdProvider with ChangeNotifier {
  bool _isWerd = false;
  int _duoID = 0;
  int _werdID = 0;
  String _username = "";
  int _mistakesCounter = 0;
  int _warningsCounter = 0;

  bool get isWerd {
    return _isWerd;
  }

  int get duoID {
    return _duoID;
  }

  int get werdID {
    return _werdID;
  }

  int get mistakesCounter {
    return _mistakesCounter;
  }

  int get warningsCounter {
    return _warningsCounter;
  }

  String get username {
    return _username;
  }

  void startWerd({required creds}) async {
    print(creds);
    // _isWerd = true;
    // _werdID = creds.werdID;
    // _duoID = creds.duoID;
    // _username = creds.username;
    // notifyListeners();
  }

  void finishWerd() {
    _isWerd = false;
    _werdID = 0;
    _duoID = 0;
    _username = "";
    _mistakesCounter = 0;
    _warningsCounter = 0;
  }
}
