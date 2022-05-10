import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/services/minimize_dfa/step2_minimize_dfa.dart';
import 'package:finite_automata_flutter/services/minimize_dfa_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Step2MinimizeDfa: Single final state', () {
    final service = Step2MinimizeDfa(FaModel.fromJson({
      "title": "Finite Automata",
      "states": ["q0", "q1", "q2", "q3"],
      "symbols": ["0", "1"],
      "start_state": "q0",
      "final_states": ["q3"],
      "transitions": {
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
        },
        "q0": {
          "0": ["q1"],
          "1": ["q0"]
        }
      }
    }));

    test('it return same DFA even after minimize', () {
      final result = service.exec();
      expect("q0',q1',q2',q3'", result.states.join(","));
      expect("q0,q1,q2,q3", service.nextInteration.mergedEqualStates?.join(","));
    });
  }, skip: true);

  group('Step2MinimizeDfa: Single final state', () {
    final service = MinimizeDFAService(FaModel.fromJson({
      "title": "Minimizable  FA (Some states are not accessible)",
      "states": ["q0", "q1", "q2", "q3", "q4", "q5", "q6", "q7"],
      "symbols": ["a", "b"],
      "start_state": "q0",
      "final_states": ["q2"],
      "transitions": {
        "q0": {
          "a": ["q1"],
          "b": ["q5"]
        },
        "q4": {
          "a": ["q7"],
          "b": ["q5"]
        },
        "q7": {
          "a": ["q6"],
          "b": ["q2"]
        },
        "q2": {
          "a": ["q0"],
          "b": ["q2"]
        },
        "q3": {
          "b": ["q6"],
          "a": ["q2"]
        },
        "q5": {
          "a": ["q2"],
          "b": ["q6"]
        },
        "q1": {
          "a": ["q6"],
          "b": ["q2"]
        },
        "q6": {
          "b": ["q4"],
          "a": ["q6"]
        }
      }
    }));

    test('it return 4 new states & has 3 equal states', () {
      final fa1 = service.step1(service.fa);
      final result = service.step2(fa1);

      expect("q0',q1',q2',q3',q4'", result.states.join(","));
      expect(
        '{q0,q4}, {q1,q7}, {q3,q5}, {q2}, {q6}',
        service.cachedStep2Service?.nextInteration.mergedEqualStates?.map((e) => "{$e}").join(", "),
      );
    });
  });
}
