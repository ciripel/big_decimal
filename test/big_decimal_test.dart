import 'package:big_decimal/big_decimal.dart';
import 'package:test/test.dart';

void main() {
  group('BigDecimal parser tests - ', () {
    test('fromBigInt', () {
      expect(BigDecimal.fromBigInt(BigInt.from(12345)).toString(), '12345');
      expect(BigDecimal.fromBigInt(BigInt.from(12345), precision: 1).toString(),
          '1234.5');
      expect(BigDecimal.fromBigInt(BigInt.from(12345), precision: 4).toString(),
          '1.2345');
      expect(BigDecimal.fromBigInt(BigInt.from(12345), precision: 5).toString(),
          '0.12345');
      expect(BigDecimal.fromBigInt(BigInt.from(12345), precision: 8).toString(),
          '0.00012345');
      expect(BigDecimal.fromBigInt(BigInt.from(0), precision: 8).toString(),
          '0.00000000');
    });

    test('parse', () {
      expect(BigDecimal.parse('12345').toString(), '12345');
      expect(BigDecimal.parse('12345', precision: 2).toString(), '12345.00');
      expect(BigDecimal.parse('123.49').toString(), '123');
      expect(BigDecimal.parse('123.50').toString(), '124');
      expect(BigDecimal.parse('123.45', precision: 4).toString(), '123.4500');
      expect(BigDecimal.parse('0', precision: 8).toString(), '0.00000000');
      expect(BigDecimal.parse('0.001', precision: 4).toString(), '0.0010');
    });
  });
}
