import 'package:moeen/helpers/general/constants.dart';

class GeneralHelpers {
  getTypeFromColor(color) {
    var type;
    switch (color) {
      case MistakesColors.revert:
        type = "revert";
        break;
      case MistakesColors.warning:
        type = "warning";
        break;
      case MistakesColors.mistake:
        type = "mistake";
        break;
    }
    return type;
  }
}
