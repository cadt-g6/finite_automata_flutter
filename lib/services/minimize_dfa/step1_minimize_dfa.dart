import 'package:finite_automata_flutter/helpers/fa_helper.dart';
import 'package:finite_automata_flutter/models/fa_model.dart';

class Step1MinimizeDfa {
  Step1MinimizeDfa(this.fa);
  final FaModel fa;

  // Remove none accessible states
  FaModel exec() {
    Set<String> initialNextStates = findNextStateFromSingleState(fa.startState);
    Set<String> accessibleStates = {fa.startState, ...initialNextStates};
    Set<String> remainStates = initialNextStates;

    while (remainStates.isNotEmpty) {
      Set<String> nextStates = findNextStates(remainStates);

      // remove if it already accessible before adding to remain
      nextStates.removeWhere((element) => accessibleStates.contains(element));
      accessibleStates.addAll(nextStates);

      remainStates.clear();
      remainStates.addAll(nextStates);
    }

    return fa.copyWith(
      states: FaHelper.sortStates(accessibleStates).toList(),
      transitions: {...fa.transitions}..removeWhere((key, value) => !accessibleStates.contains(key)),
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
      Set<String> _next = findNextStateFromSingleState(state);
      nextStates.addAll(_next);
    }
    return nextStates;
  }
}
