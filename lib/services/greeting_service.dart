import 'dart:math';

import '../models/greeting.dart';

class GreetingService {
  GreetingService._();
  static final GreetingService instance = GreetingService._();

  /// Hand-picked devotional salutations, one per deity category that
  /// actually has bhajans. Unlike [Festival]s these aren't calendar-bound —
  /// any one of them is appropriate on any day.
  static const List<Greeting> _greetings = [
    Greeting(nameDevanagari: 'राधे राधे', nameEnglish: 'Radhe Radhe', categoryId: 'krishna'),
    Greeting(nameDevanagari: 'जय शम्भो', nameEnglish: 'Jai Shambho', categoryId: 'shiv'),
    Greeting(nameDevanagari: 'जय श्री राम', nameEnglish: 'Jai Shree Ram', categoryId: 'ram'),
    Greeting(nameDevanagari: 'जय बजरंगबली', nameEnglish: 'Jai Bajrangbali', categoryId: 'hanuman'),
    Greeting(nameDevanagari: 'जय गणेश', nameEnglish: 'Jai Ganesh', categoryId: 'ganesh'),
    Greeting(nameDevanagari: 'जय माता दी', nameEnglish: 'Jai Mata Di', categoryId: 'devi'),
    Greeting(nameDevanagari: 'जय विष्णु', nameEnglish: 'Jai Vishnu', categoryId: 'bishnu'),
  ];

  final Random _random = Random();

  /// Picks one greeting to show for this app session. Callers should call
  /// this once (e.g. in initState) and hold onto the result — calling it
  /// again on every rebuild would make the greeting flicker between values
  /// on unrelated state changes like a bookmark toggle.
  Greeting randomGreeting() => _greetings[_random.nextInt(_greetings.length)];
}
