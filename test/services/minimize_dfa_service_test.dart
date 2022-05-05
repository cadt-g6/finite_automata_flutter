import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/services/minimize_dfa_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MinimizeDFAService: Some states are not accessible', () {
    final fa = FaModel.fromJson({
      "title": "Minimal DFA (Some states are not accessible)",
      "states": ["q0", "q1", "q2", "q3", "q4", "q5", "q6", "q7"],
      "symbols": ["a", "b"],
      "initial_state": "q0",
      "final_state": ["q2"],
      "transitions": {
        "q7": {
          "a": ["q6"],
          "b": ["q2"]
        },
        "q5": {
          "a": ["q2"],
          "b": ["q6"]
        },
        "q3": {
          "0": ["q3"],
          "1": ["q3"],
          "a": ["q2"],
          "b": ["q6"]
        },
        "q2": {
          "0": ["q3"],
          "1": ["q0"],
          "a": ["q0"],
          "b": ["q2"]
        },
        "q4": {
          "a": ["q7"],
          "b": ["q5"]
        },
        "q0": {
          "0": ["q1"],
          "1": ["q0"],
          "a": ["q1"],
          "b": ["q5"]
        },
        "q1": {
          "b": ["q2"],
          "a": ["q6"]
        },
        "q6": {
          "b": ["q4"],
          "a": ["q6"]
        }
      }
    });

    final service = MinimizeDFAService(fa);

    test('findAccessibleStates', () {
      test('it return without q3 since it\'s not accessible', () {
        final accessibleStates = service.findAccessibleStates();
        expect("q0,q1,q2,q3,q4,q5,q6,q7", fa.states.join(","));
        expect("q0,q1,q2,q4,q5,q6,q7", accessibleStates.join(","));
      });
    });

    test('removeNoneAccessibleStates', () {
      test('it assign new value to transition & states', () {
        final newFa = service.removeNoneAccessibleStates(fa);
        expect("q0,q1,q2,q3,q4,q5,q6,q7", fa.states.join(","));
        expect("q0,q1,q2,q4,q5,q6,q7", newFa.states.join(","));
        expect("q7,q5,q2,q4,q0,q1,q6", newFa.transitions.keys.join(","));
      });
    });
  });

  group('MinimizeDFAService: All states are accessible', () {
    final fa = FaModel.fromJson({
      "title": "Minimal DFA",
      "states": ["q0", "q1", "q2", "q3", "q4"],
      "symbols": ["0", "1"],
      "initial_state": "q0",
      "final_state": ["q4"],
      "transitions": {
        "q0": {
          "0": ["q1"],
          "1": ["q3"]
        },
        "q1": {
          "0": ["q2"],
          "1": ["q4"]
        },
        "q2": {
          "0": ["q1"],
          "1": ["q4"]
        },
        "q3": {
          "0": ["q2"],
          "1": ["q4"]
        },
        "q4": {
          "0": ["q4"],
          "1": ["q4"]
        }
      }
    });

    final service = MinimizeDFAService(fa);

    test('findAccessibleStates', () {
      final accessibleStates = service.findAccessibleStates();

      expect(
        "q0,q1,q2,q3,q4",
        accessibleStates.join(","),
      );
    });

    test('removeNoneAccessibleStates', () {
      final newFa = service.removeNoneAccessibleStates(fa);
      expect("q0,q1,q2,q3,q4", fa.transitions.keys.join(","));
      expect("q0,q1,q2,q3,q4", newFa.transitions.keys.join(","));
    });
  });
}
