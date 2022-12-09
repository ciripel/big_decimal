import 'package:big_decimal/big_decimal.dart';

void main(List<String> arguments) {
  print(BigDecimal.fromBigInt(BigInt.from(12345))); // 12345
  print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 1)); // 1234.5
  print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 4)); // 1.2345
  print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 8)); // 0.00012345
  print(BigDecimal.fromBigInt(BigInt.from(0), precision: 8)); // 0.00000000
  try {
    print(BigDecimal.fromBigInt(BigInt.from(-12345)));
  } catch (e) {
    print(e);
  }
  try {
    print(BigDecimal.fromBigInt(BigInt.from(12345), precision: -1));
  } catch (e) {
    print(e);
  }
  print('==================================================');
  print(BigDecimal.parse('12345')); // 12345
  print(BigDecimal.parse('12345', precision: 2)); // 12345.00
  print(BigDecimal.parse('123.45')); // 123
  print(BigDecimal.parse('123.67')); // 124
  print(BigDecimal.parse('123.45', precision: 4)); // 123.4500
  print(BigDecimal.parse('0', precision: 8)); // 0.00000000
  print(BigDecimal.parse('0.001', precision: 4)); // 0.0010
  try {
    print(BigDecimal.parse('-12345'));
  } catch (e) {
    print(e);
  }
  try {
    print(BigDecimal.parse('12345', precision: -1));
  } catch (e) {
    print(e);
  }
}
