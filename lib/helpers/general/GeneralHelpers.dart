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

  getColorFromType(type) {
    var color;
    switch (type) {
      case "revert":
        color = MistakesColors.revert;
        break;
      case "warning":
        color = MistakesColors.warning;
        break;
      case "mistake":
        color = MistakesColors.mistake;
        break;
    }
    return color;
  }

  Map<String, double> getResponsiveFontAndLineHeightPercentage({height}) {
    double fixedFontSizePercentage = height * 0.035;
    double fixedLineHeightPercentage = height * 0.0022;
    if (height < 700) {
      // iphone se
      fixedFontSizePercentage = height * 0.030;
      fixedLineHeightPercentage = height * 0.001;
    } else if (height < 850) {
      // iphone 12
      fixedFontSizePercentage = height * 0.028;
      fixedLineHeightPercentage = height * 0.0021;
    } else if (height < 930) {
      /// iphone pro max
      fixedFontSizePercentage = height * 0.028;
      fixedLineHeightPercentage = height * 0.002;
    } else if (height < 1000) {
      // sony z
      fixedFontSizePercentage = height * 0.026;
      fixedLineHeightPercentage = height * 0.0022;
    } else if (height < 1100) {
      // sony z
      fixedFontSizePercentage = height * 0.033;
      fixedLineHeightPercentage = 1;
    } else if (height < 1200) {
      // sony z
      fixedFontSizePercentage = height * 0.033;
      fixedLineHeightPercentage = 1;
    }
    return {
      "fixedFontSizePercentage": fixedFontSizePercentage,
      "fixedLineHeightPercentage": fixedLineHeightPercentage
    };
  }

  double getResponsiveFontAndLineHeightPercentageForHeader({height}) {
    double fixedFontSizePercentage = 14;
    if (height < 700) {
      // iphone se
      fixedFontSizePercentage = 12;
    } else if (height < 850) {
      // iphone 12
      fixedFontSizePercentage = 13;
    } else if (height < 930) {
      /// iphone pro max
      fixedFontSizePercentage = 15;
    } else if (height < 1000) {
      // sony z
      fixedFontSizePercentage = 15;
    } else if (height < 1100) {
      // ipad
      fixedFontSizePercentage = 18;
    } else if (height < 1200) {
      // ipad air and pro
      fixedFontSizePercentage = 20;
    }
    return fixedFontSizePercentage;
  }
}
