import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/services/minimize_dfa/step1_minimize_dfa.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Step1MinimizeDfa: Some states are not accessible', () {
    final service = Step1MinimizeDfa(FaModel.fromJson({
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

    test('#findAccessibleStates: it return accessibleStates without q3 since it\'s not accessible', () {
      final newFa = service.exec();
      expect("q0,q1,q2,q3,q4,q5,q6,q7", service.fa.states.join(","));
      expect("q7,q1,q4,q2,q5,q3,q0,q6", service.fa.transitions.keys.join(","));

      expect("q0,q1,q2,q4,q5,q6,q7", newFa.states.join(","));
      expect("q7,q1,q4,q2,q5,q0,q6", newFa.transitions.keys.join(","));
    });
  });

  group('Step1MinimizeDfa: All state are accessible', () {
    final service = Step1MinimizeDfa(FaModel.fromJson({
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

    test('#exec: it return states that all of them are accessible', () {
      final newFa = service.exec();
      expect("q0,q1,q2,q3,q4,q5", service.fa.states.join(","));
      expect("q0,q1,q2,q3,q4,q5", newFa.states.join(","));
    });
  });

  group('Step1MinimizeDfa: All state are accessible', () {
    final service = Step1MinimizeDfa(FaModel.fromJson({
      "title": "Finite Automata",
      "states": ["q0", "q1", "q2", "q3"],
      "symbols": ["0", "1"],
      "start_state": "q0",
      "final_states": ["q3"],
      "transitions": {
        "q0": {
          "0": ["q1"],
          "1": ["q0"]
        },
        "q1": {
          "0": ["q2"],
          "1": ["q0"]
        },
        "q2": {
          "0": ["q3"],
          "1": ["q0"]
        },
        "q3": {
          "0": ["q3"],
          "1": ["q3"]
        }
      }
    }));

    test('#exec: it return states that all of them are accessible', () {
      final newFa = service.exec();
      expect("q0,q1,q2,q3", service.fa.states.join(","));
      expect("q0,q1,q2,q3", newFa.states.join(","));
    });
  });
}
