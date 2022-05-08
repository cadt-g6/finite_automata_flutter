import 'package:finite_automata_flutter/helpers/fa_helper.dart';
import 'package:finite_automata_flutter/models/fa_model.dart';

class FirstIteration {
  final FaModel fa;
  FirstIteration(this.fa);

  Set<String> markedSets = {};
  Set<String> statesSets = {};

  bool allInFinalState(Set<String> state) {
    return state.where((e) => fa.finalStates.contains(e)).length == state.length;
  }

  void exec() {
    markedSets.clear();
    statesSets.clear();

    for (String stateR in fa.states) {
      for (String stateC in fa.states) {
        if (stateR != stateC) {
          Set<String> sets = {stateC, stateR};
          String states = FaHelper.constructStates(sets);
          statesSets.add(states);

          for (String fstate in fa.finalStates) {
            if (sets.contains(fstate)) {
              if (!allInFinalState(sets)) {
                markedSets.add(states);
              }
            }
          }
        }
      }
    }
  }
}
