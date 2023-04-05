enum AmountKey implements Comparable<AmountKey> {
  zero(isDigit: true, char: '0'),
  one(isDigit: true, char: '1'),
  two(isDigit: true, char: '2'),
  three(isDigit: true, char: '3'),
  four(isDigit: true, char: '4'),
  five(isDigit: true, char: '5'),
  six(isDigit: true, char: '6'),
  seven(isDigit: true, char: '7'),
  eight(isDigit: true, char: '8'),
  nine(isDigit: true, char: '9'),
  decimal(isDigit: false, char: '.'),
  backspace(isDigit: false, char: 'b'),
  clear(isDigit: false, char: 'c'),
  calculator(isDigit: false, char: 'l'),
  done(isDigit: false, char: 'd');

  const AmountKey({
    required this.isDigit,
    required this.char,
  });

  final bool isDigit;
  final String char;

  @override
  int compareTo(AmountKey other) => char.compareTo(other.char);
}
