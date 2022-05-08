import 'package:finite_automata_flutter/helpers/fa_helper.dart';
import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/services/minimize_dfa/step2/first_interation.dart';
import 'package:finite_automata_flutter/services/minimize_dfa/step2/next_interation.dart';

class Step2MinimizeDfa {
  late final FirstIteration firstInteration;
  late final NextInteration nextInteration;

  final FaModel fa;

  Step2MinimizeDfa(this.fa) {
    firstInteration = FirstIteration(fa);
    nextInteration = NextInteration(fa);
  }

  // Merge equal state:
  // Start with first interation & next interation...
  FaModel exec() {
    // 1st next iteration
    firstInteration.exec();
    nextInteration.exec(firstInteration.markedSets, firstInteration.statesSets);

    return fa.copyWith(
      states: FaHelper.sortStates(nextInteration.transitions!.keys.toSet()).toList(),
      startState: nextInteration.startState,
      finalStates: nextInteration.finalStates,
      transitions: nextInteration.transitions,
    );
  }
}
