String calculateEANCheckDigit(String code) {
  int even = 0;
  int odd = 0;
  for (var i = 0; i < code.length; i++) {
    if (i % 2 == 1) {
      odd += int.parse(code[i]);
    } else {
      even += int.parse(code[i]);
    }
  }
  if (code.length % 2 == 0) {
    even *= 3;
  } else {
    odd *= 3;
  }
  int sum = even + odd;
  return "${(10 - sum % 10) % 10}";
}

RegExp nonDigit = new RegExp(r'[^0-9]');

bool validateEANCheckDigit(String code, int length) {
  if (code.length != length) {
    return false;
  }
  if (nonDigit.hasMatch(code)) {
    return false;
  }
  return calculateEANCheckDigit(code.substring(0, -1)) == code[-1];
}

String sumDoubleAllDigits(String number) {
  int sum = 0;
  for (var i = 0; i < number.length; i++) {
    sum += int.parse(number[i]) * 2;
  }
  return "$sum";
}

String calculateLuhnCheckDigit(code) {
  String ev = "";
  int odd = 0;
  for (var i = code.length - 2; i >= 0; i--) {
    if (i % 2 == 1) {
      odd += int.parse(code[i]);
    } else {
      ev += code[i];
    }
  }
  ev = sumDoubleAllDigits(ev);
  int even = 0;
  for (var i = 0; i < ev.length; i++) {
    even += int.parse(ev[i]);
  }
  int sum = even + odd;
  return "${(10 - sum % 10) % 10}";
}

bool validateLuhnCheckDigit(String code, int length) {
  if (code.length != length) {
    return false;
  }

  if (nonDigit.hasMatch(code)) {
    return false;
  }
  return calculateLuhnCheckDigit(code.substring(0, -1)) == code[-1];
}

bool validateISBNCheckDigit(String code) {
  int i, s = 0, t = 0;

  for (i = 0; i < 10; i++) {
    t += int.parse(code[i]);
    s += t;
  }
  return s % 11 == 0;
}


isValidEanN (int n) {
  return (String code) => validateEANCheckDigit(code.replaceAll('-', ''), n);
}

var isValidEAN8 = isValidEanN(8);
var isValidUPCA =isValidEanN(12);
var isValidEAN13 = isValidEanN(13);
var isValidGLN =isValidEanN(13);
var isValidEAN14 = isValidEanN(14);
var isValidGSIN =isValidEanN(17);
var isValidSSCC =isValidEanN(18);

bool isValidISBN(String code) {
  code = code.replaceAll('-', '');
  if (code.length != 10) {
    return false;
  }

  if (nonDigit.hasMatch(code)) {
    return false;
  }
  return validateISBNCheckDigit(code);
}

bool isValidUPCE(code) {
  code = code.replaceAll('-', '');
  if (nonDigit.hasMatch(code)) {
    return false;
  }
  if (code.len == 6) {
    return true;
  }
  if (code.len != 7 && code.len != 8) {
    return false;
  }
  if (code.len == 8 && code[0] != "0") {
    return false;
  }
  String checkCode = code[-1];
  String upcECode = code.substring(code.length == 7 ? 0 : 1, 6);
  String manufacturerNumber = upcECode[0] +
      upcECode[1] +
      (upcECode[5] == "0" || upcECode[5] == "1" || upcECode[5] == "2"
          ? upcECode[5]
          : upcECode[5] == "3"
              ? upcECode[2]
              : upcECode[5] == "4"
                  ? upcECode[2] + upcECode[3]
                  : upcECode[2] + upcECode[3] + upcECode[4]);
  while (manufacturerNumber.length < 5) {
    manufacturerNumber += "0";
  }
  String itemNumber =
      (upcECode[5] == "0" || upcECode[5] == "1" || upcECode[5] == "2"
          ? upcECode[2] + upcECode[3] + upcECode[4]
          : upcECode[5] == "3"
              ? upcECode[3] + upcECode[4]
              : upcECode[5] == "4"
                  ? upcECode[4]
                  : upcECode[5]);
  while (itemNumber.length < 5) {
    itemNumber = "0" + itemNumber;
  }
  return validateEANCheckDigit(
      "0" + manufacturerNumber + itemNumber + checkCode, 12);
}

bool isValidIMEI(code) {
  code = code.replaceAll('-', '');

  if (nonDigit.hasMatch(code)) {
    return false;
  }
  if (code.length == 14 || code.length == 16) {
    return true;
  }
  if (code.length != 15) {
    return false;
  }
  return validateLuhnCheckDigit(code, 15);
}

// 6 UPCE
// 7 UPCE
// 8 EAN8 UPCE
// 9
// 10 ISBN
// 11
// 12 UPCA
// 13 ENA13 GLN
// 14 EAN14 IMEI
// 15 IMEI
// 16 IMEI
// 17 GSIN
// 18 SSCC
List<String> possibleAlgorithms(String code) {
  code = code.replaceAll('-', '');

  if (nonDigit.hasMatch(code)) {
    return List<String>();
  }
  var ret = List<String>();
  switch(code.length) {
    case 8:
    if (isValidEAN8(code)) {
      ret.add("EAN8");
    }
    continue case_6;
    case_6:
    case 6:
    case 7:
    if (isValidUPCE(code)) {
      ret.add("UPCE");
    }
    break;
    case 10:
    if (isValidISBN(code)) {
      ret.add("ISBN");
    }
    break;
    case 12:
    if (isValidUPCA(code)) {
      ret.add("UPCA");
    }
    break;
    case 13:
    if (isValidEAN13(code)) {
      ret.add("EAN13");
    }
    if (isValidGLN(code)) {
      ret.add("GLN");
    }
    break;
    case 14:
    if (isValidEAN14(code)) {
      ret.add("EAN14");
    }
    continue case_15;
    case_15:
    case 15:
    case 16:
    if (isValidIMEI(code)) {
      ret.add("IMEI");
    }
    break;
    case 17:
    if (isValidGSIN(code)) {
      ret.add("GSIN");
    }
    break;
    case 18:
    if (isValidSSCC(code)) {
      ret.add("SSCC");
    }
    break;
  }
  return ret;
}

bool isValidBarcode(String code) {
  return possibleAlgorithms(code).length > 0;
}