import 'dart:collection';

class FaHelper {
  static Set<String> sortStates(Set<String> states) {
    return SplayTreeSet<String>.from(states, (a, b) => a.compareTo(b)).toSet();
  }

  static String constructStates(Set<String> states) {
    return FaHelper.sortStates(states).join(",");
  }
}
