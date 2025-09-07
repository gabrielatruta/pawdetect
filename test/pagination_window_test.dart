import 'package:flutter_test/flutter_test.dart';

List<T> visibleWindow<T>(List<T> items, int visibleCount) {
  if (visibleCount < 0) visibleCount = 0;
  if (visibleCount > items.length) visibleCount = items.length;
  return items.take(visibleCount).toList();
}

bool hasMore<T>(List<T> items, int visibleCount) => visibleCount < items.length;

void main() {
  test('windowing + hasMore (pure)', () {
    final items = List.generate(10, (i) => 'id_$i');

    expect(visibleWindow(items, 0), <String>[]);
    expect(hasMore(items, 0), true);

    expect(visibleWindow(items, 4), ['id_0', 'id_1', 'id_2', 'id_3']);
    expect(hasMore(items, 4), true);

    expect(visibleWindow(items, 10).length, 10);
    expect(hasMore(items, 10), false);

    // clamp beyond length
    expect(visibleWindow(items, 999).length, 10);
  });
}
