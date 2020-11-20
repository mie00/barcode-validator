# Barcode-Validator

Barcode validator for flutter. Shamelessly copied from this PHP version: https://github.com/imelgrat/barcode-validator.

## Getting Started

```
# add this line to your dependencies
barcode_validator: ^0.0.1
```

```
import 'package:barcode_validator/barcode_validator.dart';
```

## Methods

```dart
bool isValidEAN8(String code)
bool isValidUPCA(String code)
bool isValidEAN13(String code)
bool isValidGLN(String code)
bool isValidEAN14(String code)
bool isValidGSIN(String code)
bool isValidSSCC(String code)
bool isValidISBN(String code)
bool isValidUPCE(String code)
bool isValidIMEI(String code)

// Return possible barcode algorithms
List<String> possibleAlgorithms(String code)
// Check if it can be a valid barcode
bool isValidBarcode(String code)
```

## License

MIT 2020 Mohamed Elawadi <mohamed@elawadi.net>
