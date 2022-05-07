import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/services/minimize_dfa/step2_minimize_dfa.dart';
import 'package:flutter_test/flutter_test.dart';

// TODO: complete this test
void main() {
  group('Step2MinimizeDfa: Single final state', () {
    final service = Step2MinimizeDfa(FaModel.fromJson({
      "title": "Minimizable  FA (Some states are not accessible)",
      "states": ["q0", "q1", "q2", "q3", "q4", "q5", "q6", "q7"],
      "symbols": ["a", "b"],
      "start_state": "q0",
      "final_states": ["q2"],
      "transitions": {
        "q7": {
          "b": ["q2"],
          "a": ["q6"]
        },
        "q1": {
          "b": ["q2"],
          "a": ["q6"]
        },
        "q4": {
          "b": ["q5"],
          "a": ["q7"]
        },
        "q2": {
          "b": ["q2"],
          "a": ["q0"]
        },
        "q5": {
          "a": ["q2"],
          "b": ["q6"]
        },
        "q3": {
          "a": ["q2"],
          "b": ["q6"]
        },
        "q0": {
          "b": ["q5"],
          "a": ["q1"]
        },
        "q6": {
          "b": ["q4"],
          "a": ["q6"]
        }
      }
    }));

    test('#findAccessibleStates: it return accessibleStates without q3 since it\'s not accessible', () {});

    test('#removeNoneAccessibleStates: it assign new value to transition & states', () {});
  });

  group('Step2MinimizeDfa: Multiple final states', () {
    final service = Step2MinimizeDfa(FaModel.fromJson({
      "title": "Minimizable DFA (Multiple final states)",
      "states": ["q0", "q1", "q2", "q3", "q4", "q5"],
      "symbols": ["0", "1"],
      "start_state": "q0",
      "final_states": ["q1", "q2", "q4"],
      "transitions": {
        "q0": {
          "0": ["q3"],
          "1": ["q1"]
        },
        "q3": {
          "0": ["q0"],
          "1": ["q4"]
        },
        "q4": {
          "0": ["q2"],
          "1": ["q5"]
        },
        "q2": {
          "0": ["q2"],
          "1": ["q5"]
        },
        "q5": {
          "0": ["q5"],
          "1": ["q5"]
        },
        "q1": {
          "0": ["q2"],
          "1": ["q5"]
        }
      }
    }));

    test('#firstIteration: it return all marked states from first iteration', () {
      final result = service.firstIteration();
      final Set<String> markedSets = result[0];
      expect(
        "q0,q1 | q0,q2 | q0,q4 | q1,q3 | q1,q5 | q2,q3 | q2,q5 | q3,q4 | q4,q5",
        markedSets.join(" | "),
      );
    });

    test('#exec', () {});
  });
}
