import 'package:flutter_test/flutter_test.dart';

String normalizeAreaKey(String area) {
  return area
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

void main() {
  test('normalizes to lowercase, ascii-ish, single spaces (pure)', () {
    expect(normalizeAreaKey('Riga Center'), 'riga center');
    expect(normalizeAreaKey('  Rīga—Center!! '), 'r ga center');
    expect(normalizeAreaKey('Jūrmala  Old—Town'), 'j rmala old town');
    expect(normalizeAreaKey('Teika'), 'teika');
    expect(normalizeAreaKey('CENTRE  1'), 'centre 1');
  });
}
