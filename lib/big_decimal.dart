import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class BigDecimal extends Equatable {
  static const defaultPrecision = 0;

  /// Create a new [BigDecimal] from a [value] of type [BigInt] given a
  /// [precision].
  ///
  /// [defaultPrecision] is 0.
  ///
  /// Only positive [value]s are supported.
  ///
  /// [precision] must be positive.
  ///
  /// Example:
  /// ```dart
  /// print(BigDecimal.fromBigInt(BigInt.from(12345))); // 12345
  /// print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 1)); // 1234.5
  /// print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 4)); // 1.2345
  /// print(BigDecimal.fromBigInt(BigInt.from(12345), precision: 8)); // 0.00012345
  /// print(BigDecimal.fromBigInt(BigInt.from(0), precision: 8)); // 0.00000000
  /// ```
  factory BigDecimal.fromBigInt(
    BigInt value, {
    int precision = defaultPrecision,
  }) {
    if (value < BigInt.zero) {
      throw FormatException('Only positive values are supported');
    }
    if (precision < 0) throw FormatException('Precision must be positive');
    final v = Decimal.fromBigInt(value);
    final p = Decimal.fromBigInt(BigInt.from(pow(10, precision)));
    final r = (v / p).toDecimal().toString().split('.');

    return BigDecimal._(
      r.isNotEmpty ? r.first.split('').map(int.parse).toList() : const [],
      r.length > 1 ? r.last.split('').map(int.parse).toList() : null,
      precision,
    );
  }

  /// Parses [value] as a BigDecimal literal and returns it's value as
  /// [BigDecimal] given a [precision].
  ///
  /// [defaultPrecision] is 0.
  ///
  /// Only positive [value]s are supported.
  ///
  /// [precision] must be positive.
  ///
  /// Example:
  /// ```dart
  /// print(BigDecimal.parse('12345')); // 12345
  /// print(BigDecimal.parse('12345', precision: 2)); // 12345.00
  /// print(BigDecimal.parse('123.45')); // 123
  /// print(BigDecimal.parse('123.67')); // 124
  /// print(BigDecimal.parse('123.45', precision: 4)); // 123.4500
  /// print(BigDecimal.parse('0', precision: 8)); // 0.00000000
  /// print(BigDecimal.parse('0.00000001', precision: 9)); // 0.000000010
  /// ```
  static BigDecimal parse(
    String value, {
    int precision = defaultPrecision,
  }) {
    if (precision < 0) throw FormatException('Precision must be positive');
    return BigDecimal.fromBigInt(
      BigInt.parse(
        Decimal.parse(value).toStringAsFixed(precision).replaceAll('.', ''),
      ),
      precision: precision,
    );
  }

  /// Create a new [BigDecimal] from a [value] of type [double] given a
  /// [precision].
  ///
  /// [defaultPrecision] is the number of decimals of the [value].
  ///
  /// Only positive [value]s are supported.
  ///
  /// [precision] must be positive.
  ///
  /// Example:
  /// ```dart
  /// print(BigDecimal.fromDouble(12345)); // 12345
  /// print(BigDecimal.fromDouble(123.45)); // 123.45
  /// print(BigDecimal.fromDouble(123.4500)); // 123.45
  /// print(BigDecimal.fromDouble(0)); // 0
  /// print(BigDecimal.fromDouble(0, precision: 8)); // 0.00000000
  /// print(BigDecimal.fromDouble(123.45, precision: 5)); // 123.45000
  /// ```
  factory BigDecimal.fromDouble(
    double value, {
    int? precision,
  }) {
    final inheritedPrecision = (Decimal.parse(value.toString()) -
                Decimal.parse(value.truncate().toString()))
            .precision -
        1;
    return parse(
      value.toString(),
      precision: precision ?? inheritedPrecision,
    );
  }

  /// The [BigDecimal] corresponding to `0`.
  ///
  /// [defaultPrecision] is 0.
  ///
  /// Negative [precision] will default to `0`.
  ///
  /// Example:
  /// ```dart
  /// print(BigDecimal.zero()); // 0
  /// print(BigDecimal.zero(precision: 8)); // 0.00000000
  /// print(BigDecimal.zero(precision: -1)); // 0
  /// ```
  const BigDecimal.zero({
    int precision = defaultPrecision,
  }) : this._(const [], null, precision);

  const BigDecimal._(
    this._abs,
    this._dec,
    this.precision,
  );

  /// must be a valid `int` value. it is list of integers
  final List<int> _abs;

  /// must be a valid `int` value
  final List<int>? _dec;

  /// represents decimal place
  final int precision;

  bool get isZero =>
      (_abs.isEmpty || (_abs[0] == 0 && _abs.length == 1)) && _dec == null;
  bool get isNotZero => !isZero;
  bool get isDecimal => _dec != null;
  bool get isNotDecimal => !isDecimal;
  bool get isFinite =>
      _dec == null || (_dec != null && _dec!.length <= precision);

  /// Addition operator.
  ///
  /// Precision of the result will be minimum needed precision
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('1.888', precision: 4);
  /// final addition = x + z; // 3.11 (precision: 2)
  /// ```
  BigDecimal operator +(BigDecimal other) {
    final inheritedPrecision = (Decimal.parse(
                    (toDecimal() + other.toDecimal()).toString()) -
                Decimal.parse(
                    (toDecimal() + other.toDecimal()).truncate().toString()))
            .precision -
        1;
    return BigDecimal.parse(
      (toDecimal() + other.toDecimal()).toString(),
      precision: inheritedPrecision,
    );
  }

  /// Subtraction operator.
  ///
  /// It will return [BigDecimal.zero()] if the subtraction result is negative.
  ///
  /// Precision of the result will be minimum needed precision
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('0.2225', precision: 4);
  /// final subtract = x - y; // 0.9995 (precision 4)
  /// ```
  BigDecimal operator -(BigDecimal other) {
    if (toDecimal() - other.toDecimal() < Decimal.zero) {
      return BigDecimal.zero(precision: defaultPrecision);
    }
    final inheritedPrecision = (Decimal.parse(
                    (toDecimal() - other.toDecimal()).toString()) -
                Decimal.parse(
                    (toDecimal() - other.toDecimal()).truncate().toString()))
            .precision -
        1;
    return BigDecimal.parse(
      (toDecimal() - other.toDecimal()).toString(),
      precision: inheritedPrecision,
    );
  }

  /// Multiplication operator.
  ///
  /// Precision of the result will be minimum needed precision
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('1.888', precision: 4);
  /// final multiplication = x * z; // 2.307136 (precision: 6)
  /// ```
  BigDecimal operator *(BigDecimal other) {
    final inheritedPrecision = (Decimal.parse(
                    (toDecimal() * other.toDecimal()).toString()) -
                Decimal.parse(
                    (toDecimal() * other.toDecimal()).truncate().toString()))
            .precision -
        1;
    return BigDecimal.parse(
      (toDecimal() * other.toDecimal()).toString(),
      precision: inheritedPrecision,
    );
  }

  /// Division operator.
  ///
  /// Matching the similar operator on [double],
  /// this operation first performs [toDouble] on both this [BigDecimal]
  /// and [other], then does [double.operator/] on those values and
  /// returns the result.
  ///
  /// **Note:** The initial [toDouble] conversion may lose precision.
  ///
  /// It will return [BigDecimal.zero()] if the [other] is [BigDecimal.zero()].
  ///
  /// Precision of the result will be minimum needed precision
  ///
  /// Example:
  /// ```dart
  /// final x = BigDecimal.parse('1.222', precision: 3);
  /// final y = BigDecimal.parse('0.2225', precision: 4);
  /// final division = x / y; // 5.492134831460674 (precision 15)
  /// ```
  BigDecimal operator /(BigDecimal other) {
    if (other.toDecimal() == Decimal.zero) {
      return BigDecimal.zero(precision: defaultPrecision);
    }
    final inheritedPrecision =
        (Decimal.parse((toDouble() / other.toDouble()).toString()) -
                    Decimal.parse(
                        (toDouble() / other.toDouble()).truncate().toString()))
                .precision -
            1;
    return BigDecimal.fromDouble(
      toDouble() / other.toDouble(),
      precision: inheritedPrecision,
    );
  }

  BigDecimal clear() => BigDecimal.zero(precision: precision);

  BigDecimal removeValue() {
    if (_abs.isEmpty) return _copyWith();
    if (!isDecimal) return _copyWith(abs: List.from(_abs)..removeLast());
    if (_dec!.isEmpty) return BigDecimal._(_abs, null, precision);

    return _copyWith(dec: List.from(_dec!)..removeLast());
  }

  BigDecimal addValue(int? n) {
    if (n == null) return _addPrecision();
    if (isDecimal) return _addDec(n);
    return _addAbs(n);
  }

  BigDecimal _addPrecision() {
    if (isDecimal) return _copyWith();
    return _copyWith(
      abs: _abs.isEmpty ? [0] : _abs,
      dec: const [],
    );
  }

  BigDecimal _addAbs(int n) {
    final updated = [..._abs, n];
    if (int.tryParse(updated.join('')) == null) return _copyWith();
    if (_abs.isEmpty && n < 1) return _copyWith();
    return _copyWith(abs: [..._abs, n]);
  }

  BigDecimal _addDec(int n) {
    if (isNotDecimal) return _copyWith(dec: [n]);
    if (_dec!.length < precision) return _copyWith(dec: [..._dec!, n]);
    return _copyWith();
  }

  BigInt toBigInt() {
    return BigInt.tryParse(toString().replaceAll('.', '')) ?? BigInt.zero;
  }

  Decimal toDecimal() {
    return Decimal.parse(toString());
  }

  /// Returns this [BigInt] as a [double].
  ///
  /// If the number is not representable as a [double],
  /// an approximation is returned.
  double toDouble() {
    return double.parse(toString());
  }

  @override
  String toString() {
    final abs = _abs.isNotEmpty ? _abs.join('') : '0';
    final dec = _dec?.join('') ?? '0';
    final str = [abs, dec].join('.').replaceAll(RegExp(r'[.]*$'), '');

    return (Decimal.tryParse(str) ?? Decimal.zero)
        .toStringAsFixed(max(precision, defaultPrecision));
  }

  String format({String locale = 'en_US'}) {
    if (_abs.isEmpty) return '';

    final f = NumberFormat('###,###', locale);
    final a = f.format(
      DecimalIntl(Decimal.tryParse(_abs.join('')) ?? Decimal.zero),
    );

    if (isNotDecimal) return a;
    return [a, _dec?.join('')].join('.');
  }

  BigDecimal _copyWith({
    List<int>? abs,
    List<int>? dec,
  }) {
    return BigDecimal._(
      abs ?? _abs,
      dec ?? _dec,
      precision,
    );
  }

  @override
  List<Object?> get props => [_abs, _dec];
}
