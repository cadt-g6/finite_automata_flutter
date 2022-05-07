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
          "b": ["q2"],
          "a": ["q6"]
        },
        "q1": {
          "b": ["q2"],
          "a": ["q6"]
        },
        "q0": {
          "a": ["q1"],
          "b": ["q5"]
        },
        "q6": {
          "a": ["q6"],
          "b": ["q4"]
        },
        "q3": {
          "b": ["q6"],
          "a": ["q2"]
        },
        "q4": {
          "a": ["q7"],
          "b": ["q5"]
        },
        "q5": {
          "a": ["q2"],
          "b": ["q6"]
        },
        "q2": {
          "b": ["q2"],
          "a": ["q0"]
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
    }, skip: true);

    test('removeNoneAccessibleStates', () {
      test('it assign new value to transition & states', () {
        final newFa = service.removeNoneAccessibleStates(fa);
        expect("q0,q1,q2,q3,q4,q5,q6,q7", fa.states.join(","));
        expect("q0,q1,q2,q4,q5,q6,q7", newFa.states.join(","));
        expect("q7,q5,q2,q4,q0,q1,q6", newFa.transitions.keys.join(","));
      });
    }, skip: true);

    // TODO: Complete Step 2
    test('minialDFA', () {
      final newFa = service.minialDFA();
    });
  });

  group('MinimizeDFAService: All states are accessible', () {
    final fa = FaModel.fromJson({
      "title": "Minimizable DFA (Multiple final states - have some bugs)",
      "states": ["q0", "q1", "q2", "q3", "q4", "q5"],
      "symbols": ["0", "1"],
      "initial_state": "q0",
      "final_state": ["q1", "q2", "q4"],
      "transitions": {
        "q4": {
          "0": ["q2"],
          "1": ["q5"]
        },
        "q3": {
          "0": ["q0"],
          "1": ["q4"]
        },
        "q1": {
          "0": ["q2"],
          "1": ["q5"]
        },
        "q5": {
          "0": ["q5"],
          "1": ["q5"]
        },
        "q2": {
          "0": ["q2"],
          "1": ["q5"]
        },
        "q0": {
          "0": ["q3"],
          "1": ["q1"]
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
    }, skip: true);

    test('removeNoneAccessibleStates', () {
      final newFa = service.removeNoneAccessibleStates(fa);
      expect("q0,q1,q2,q3,q4", fa.transitions.keys.join(","));
      expect("q0,q1,q2,q3,q4", newFa.transitions.keys.join(","));
    }, skip: true);

    test('minialDFA', () {
      final newFa = service.minialDFA();
    });
  });
}
