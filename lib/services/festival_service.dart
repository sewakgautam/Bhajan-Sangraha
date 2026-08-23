import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/festival.dart';

class FestivalService {
  FestivalService._();
  static final FestivalService instance = FestivalService._();

  /// A festival is "active" from [windowDays] days before it through
  /// [windowDays] days after, so the highlight builds anticipation and
  /// lingers a little past the day itself.
  static const int windowDays = 1;

  List<Festival> _festivals = const [];

  Future<void> loadFestivals() async {
    final raw = await rootBundle.loadString('assets/festivals.json');
    loadFromJsonString(raw);
  }

  /// Entries with a missing/unparseable `date` are skipped rather than
  /// crashing the whole load — festivals.json is hand-edited and some
  /// entries don't have a date filled in yet. Exposed separately from
  /// [loadFestivals] so tests can feed it a fixture instead of depending on
  /// whatever's currently in the hand-edited asset.
  @visibleForTesting
  void loadFromJsonString(String raw) {
    final decoded = json.decode(raw) as List<dynamic>;
    final festivals = <Festival>[];
    for (final entry in decoded) {
      try {
        festivals.add(Festival.fromJson(entry as Map<String, dynamic>));
      } catch (e) {
        debugPrint('Skipping festival entry (${entry['id']}): $e');
      }
    }
    _festivals = festivals;
  }

  /// The festival to highlight today, if any. If more than one falls in its
  /// active window at once, the closest to today wins.
  Festival? activeFestival({DateTime? now}) {
    final today = _dateOnly(now ?? DateTime.now());

    Festival? closest;
    int? closestDistance;
    for (final festival in _festivals) {
      final date = _dateOnly(festival.date);
      final distance = date.difference(today).inDays.abs();
      if (distance > windowDays) continue;

      if (closestDistance == null || distance < closestDistance) {
        closest = festival;
        closestDistance = distance;
      }
    }
    return closest;
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
