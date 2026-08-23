import 'package:bhajan_sangraha/services/festival_service.dart';
import 'package:flutter_test/flutter_test.dart';

const _fixture = '''
[
  {
    "id": "krishna_janmashtami_2026",
    "name_devanagari": "कृष्ण जन्माष्टमी",
    "name_english": "Krishna Janmashtami",
    "category": "krishna",
    "date": "2026-09-04"
  },
  {
    "id": "ghatasthapana_2026",
    "name_devanagari": "घटस्थापना",
    "name_english": "Ghatasthapana",
    "category": "devi",
    "date": "2026-10-11"
  },
  {
    "id": "vijaya_dashami_2026",
    "name_devanagari": "विजया दशमी",
    "name_english": "Vijaya Dashami",
    "category": "devi",
    "date": "2026-10-20"
  },
  {
    "id": "no_date_entry",
    "name_devanagari": "बिना मिति",
    "name_english": "Undated Entry",
    "category": "other"
  }
]
''';

void main() {
  final service = FestivalService.instance;

  setUp(() {
    service.loadFromJsonString(_fixture);
  });

  test('returns the festival on its exact date', () {
    final festival = service.activeFestival(now: DateTime(2026, 9, 4));
    expect(festival?.id, 'krishna_janmashtami_2026');
  });

  test('returns the festival within the lead-in window', () {
    final festival = service.activeFestival(now: DateTime(2026, 9, 3));
    expect(festival?.id, 'krishna_janmashtami_2026');
  });

  test('returns the festival within the trailing window', () {
    final festival = service.activeFestival(now: DateTime(2026, 9, 5));
    expect(festival?.id, 'krishna_janmashtami_2026');
  });

  test('returns null just outside the window', () {
    expect(service.activeFestival(now: DateTime(2026, 9, 2)), isNull);
    expect(service.activeFestival(now: DateTime(2026, 9, 6)), isNull);
  });

  test('returns null on an ordinary day', () {
    expect(service.activeFestival(now: DateTime(2026, 7, 22)), isNull);
  });

  test('picks the closest festival when two windows are near each other', () {
    final festival = service.activeFestival(now: DateTime(2026, 10, 12));
    expect(festival?.id, 'ghatasthapana_2026');
  });

  test('skips entries with a missing date instead of crashing', () {
    // Loading the fixture (which includes "no_date_entry") must not throw,
    // and the malformed entry should simply be absent from any result.
    expect(
      () => service.loadFromJsonString(_fixture),
      returnsNormally,
    );
  });
}
