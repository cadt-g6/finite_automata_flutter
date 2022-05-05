import 'package:finite_automata_flutter/models/fa_model.dart';
import 'dart:collection';

class MinimizeDFAService {
  FaModel fa;
  MinimizeDFAService(this.fa);

  FaModel minialDFA() {
    fa = removeNoneAccessibleStates(fa);
    return fa;
  }

  FaModel removeNoneAccessibleStates(FaModel _fa) {
    Set<String> accessibleStates = findAccessibleStates();

    Map<String, Map<String, List<String>>> transition = {};
    _fa.transitions.forEach((key, value) {
      if (accessibleStates.contains(key)) {
        transition[key] = value;
      }
    });

    return _fa.copyWith(
      states: accessibleStates.toList(),
      transitions: transition,
    );
  }

  Set<String> findNextStateFromSingleState(String state) {
    List<String>? states = fa.transitions[state]?.values.map((e) => e.join(",")).join(",").split(",");
    return states?.toSet() ?? {};
  }

  Set<String> sortStates(Set<String> states) {
    return SplayTreeSet<String>.from(states, (a, b) => a.compareTo(b)).toSet();
  }

  Set<String> findNextStates(
    Set<String> states,
  ) {
    Set<String> nextStates = {};

    for (String state in states) {
      Set<String> _nextStatesPerState = findNextStateFromSingleState(state);
      nextStates.addAll(_nextStatesPerState);
    }

    return nextStates;
  }

  bool isAllAccessible(Set<String> accessibleStates, Set<String> states) {
    Iterable<bool> result = states.map((state) => accessibleStates.contains(state));
    String t = states.map((e) => true.toString()).join(",");
    String b = result.map((e) => "$e").join(",");
    return t == b;
  }

  Set<String> findAccessibleStates() {
    Set<String> accessibleStates = {fa.initialState};
    Set<String> states = findNextStateFromSingleState(fa.initialState);
    Set<String> setStatesFounds = {};

    while (!isAllAccessible(states, accessibleStates)) {
      accessibleStates.addAll(states);
      states = findNextStates(states);

      String found = states.join(",");
      if (setStatesFounds.contains(found)) {
        break;
      } else {
        setStatesFounds.add(found);
      }
    }

    accessibleStates.addAll(states);
    return sortStates(accessibleStates);
  }
}
