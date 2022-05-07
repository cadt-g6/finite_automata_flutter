import 'package:finite_automata_flutter/helpers/fa_helper.dart';
import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/services/minimize_dfa/step2_minimize_dfa.dart';

class MinimizeDFAService {
  FaModel fa;
  Step2MinimizeDfa? cachedStep2Service;
  MinimizeDFAService(this.fa);

  FaModel minialDFA() {
    fa = removeNoneAccessibleStates(fa);
    fa = step2(fa);
    return fa;
  }

  FaModel step2(FaModel fa) {
    cachedStep2Service = Step2MinimizeDfa(fa);
    fa = cachedStep2Service!.exec();
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
    Set<String> accessibleStates = {fa.startState};
    Set<String> states = findNextStateFromSingleState(fa.startState);
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
    return FaHelper.sortStates(accessibleStates);
  }
}
