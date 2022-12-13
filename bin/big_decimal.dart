import 'package:big_decimal/big_decimal.dart';
import 'package:decimal/decimal.dart';

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
  print('==================================================');
  print(BigDecimal.fromDouble(12345)); // 12345
  print(BigDecimal.fromDouble(123.45)); // 123.45
  print(BigDecimal.fromDouble(123.4500)); // 123.45
  print(BigDecimal.fromDouble(0)); // 0
  print(BigDecimal.fromDouble(0, precision: 8)); // 0.00000000
  print(BigDecimal.fromDouble(123.450, precision: 5)); // 123.45000
  print(BigDecimal.fromDouble(123.45678, precision: 2)); // 123.46
  try {
    print(BigDecimal.fromDouble(-123.45));
  } catch (e) {
    print(e);
  }
  try {
    print(BigDecimal.fromDouble(123.45, precision: -1));
  } catch (e) {
    print(e);
  }
  print('==================================================');
  print(BigDecimal.zero()); // 0
  print(BigDecimal.zero(precision: 8)); // 0.00000000
  print(BigDecimal.zero(precision: -1)); // 0
  print('==================================================');
}
