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

  Map<String, double> getResponsiveFontAndLineHeightPercentage(
      {height, width}) {
    double fixedFontSizePercentage = height * 0.035;
    double fixedLineHeightPercentage = height * 0.0022;
    if ((width > 400 && width < 600) && height < 750) {
      fixedFontSizePercentage = width * 0.06;
      fixedLineHeightPercentage = width * 0.0035;
    } else if ((width > 400 && width < 600) && height < 900) {
      fixedFontSizePercentage = width * 0.06;
      fixedLineHeightPercentage = width * 0.0031;
    } else if (height < 660) {
      fixedFontSizePercentage = height * 0.0345;
      fixedLineHeightPercentage = height * 0.00234;
    } else if (height < 700) {
      // iphone se
      fixedFontSizePercentage = height * 0.0345;
      fixedLineHeightPercentage = height * 0.0021;
    } else if (height < 810) {
      // iphone 10
      fixedFontSizePercentage = height * 0.0275;
      fixedLineHeightPercentage = height * 0.0022;
    } else if (height < 820) {
      // iphone 10
      fixedFontSizePercentage = height * 0.0275;
      fixedLineHeightPercentage = height * 0.00215;
    } else if (height < 860) {
      // iphone 12
      fixedFontSizePercentage = height * 0.028;
      fixedLineHeightPercentage = height * 0.0021;
    } else if (height < 930) {
      /// iphone pro max
      fixedFontSizePercentage = height * 0.028;
      fixedLineHeightPercentage = height * 0.0019;
    } else if (height < 1000) {
      // sony z
      fixedFontSizePercentage = height * 0.026;
      fixedLineHeightPercentage = height * 0.0022;
    } else if (height < 1100) {
      // sony z
      fixedFontSizePercentage = height * 0.034;
      fixedLineHeightPercentage = 1.5;
    } else if (height < 1200) {
      fixedFontSizePercentage = height * 0.0335;
      fixedLineHeightPercentage = 1.53;
    } else if (height < 2000 && width < 1300) {
      // square tablets
      fixedFontSizePercentage = height * 0.035;
      fixedLineHeightPercentage = 1.5;
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

  String replaceFarsiNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(farsi[i], english[i]);
    }

    return input;
  }
}
