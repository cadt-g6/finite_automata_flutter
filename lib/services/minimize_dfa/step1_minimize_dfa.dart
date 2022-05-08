import 'package:finite_automata_flutter/helpers/fa_helper.dart';
import 'package:finite_automata_flutter/models/fa_model.dart';

class Step1MinimizeDfa {
  Step1MinimizeDfa(this.fa);
  final FaModel fa;

  // Remove none accessible states
  FaModel exec() {
    Set<String> initialNextStates = FaHelper.findNextStateFromSingleState(fa.startState, fa);
    Set<String> accessibleStates = {fa.startState, ...initialNextStates};
    Set<String> remainStates = initialNextStates;

    while (remainStates.isNotEmpty) {
      Set<String> nextStates = FaHelper.findNextStates(remainStates, fa);

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
}
