import 'dart:collection';

import 'package:finite_automata_flutter/models/fa_model.dart';

class FaHelper {
  static Set<String> sortStates(Set<String> states) {
    return SplayTreeSet<String>.from(states, (a, b) => a.compareTo(b)).toSet();
  }

  static String constructStates(Set<String> states) {
    return FaHelper.sortStates(states).join(",");
  }

  static Set<String> findNextStateFromSingleState(String state, FaModel fa) {
    List<String>? states = fa.transitions[state]?.values.map((e) => e.join(",")).join(",").split(",");
    return states?.toSet() ?? {};
  }

  static Set<String> findNextStates(
    Set<String> states,
    FaModel fa,
  ) {
    Set<String> nextStates = {};
    for (String state in states) {
      Set<String> _next = findNextStateFromSingleState(state, fa);
      nextStates.addAll(_next);
    }
    return nextStates;
  }
}
