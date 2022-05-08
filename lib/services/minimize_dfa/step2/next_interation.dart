import 'package:finite_automata_flutter/helpers/fa_helper.dart';
import 'package:finite_automata_flutter/models/fa_model.dart';

class NextInteration {
  final FaModel fa;
  NextInteration(this.fa);

  Set<String>? mergedEqualStates;
  Map<String, Map<String, List<String>>>? transitions;
  String? startState;
  List<String>? finalStates;

  void exec(Set<String> _markedSets, Set<String> _statesSets) {
    Set<String> nextMarkedSets = getNextMarkedSets(_markedSets, _statesSets);
    Set<String> equalPairStates = {..._statesSets}..removeAll(nextMarkedSets);

    mergedEqualStates = mergeEqualStates(equalPairStates);
    List<dynamic> result = equalStatesToDfaInfos(mergedEqualStates!);

    transitions = result[0];
    startState = result[1];
    finalStates = result[2];
  }

  Set<String> getNextMarkedSets(Set<String> markedSets, Set<String> statesSets) {
    // Found once but result not yet found or still in remain states
    Set<String> tryOnce = {};
    Set<String> remainStatesSets = {...statesSets}..removeWhere((state) => markedSets.contains(state));

    while (remainStatesSets.isNotEmpty) {
      String _statesSets = remainStatesSets.last;
      remainStatesSets.remove(_statesSets);

      for (String symbol in fa.symbols) {
        Set<String> nextStates = nextStatesByASymbol(_statesSets.split(",").toSet(), symbol);
        String nextStatesStr = FaHelper.constructStates(nextStates);

        // have found once & marked
        if (!remainStatesSets.contains(nextStatesStr) && markedSets.contains(nextStatesStr)) {
          markedSets.add(_statesSets);
        } else if (!tryOnce.contains(_statesSets)) {
          remainStatesSets.add(nextStatesStr);
          tryOnce.add(_statesSets);
        }
      }
    }

    return markedSets;
  }

  // states: {q1,q2}, symbol: a
  // => {q4,q6}
  Set<String> nextStatesByASymbol(Set<String> states, String symbol) {
    Set<String> nextStates = {};
    for (String state in states) {
      Set<String>? result = fa.transitions[state]?[symbol]?.toSet();
      if (result != null) nextStates.addAll(result);
    }
    return nextStates;
  }

  /// => [transitions, startState, finalStates]
  List<dynamic> equalStatesToDfaInfos(Set<String> mergedEqualStates) {
    Map<String, Map<String, List<String>>> transitions = {};
    String startState = "";
    List<String> finalStates = [];

    for (int i = 0; i < mergedEqualStates.length; i++) {
      String statesStr = mergedEqualStates.elementAt(i);
      Set<String> states = statesStr.split(",").toSet();

      String key = "q$i'";
      if (transitions[key] == null) transitions[key] = {};

      for (String symbol in fa.symbols) {
        Set<String> nextStatesList = {};
        for (String state in states) {
          String? nextStates = fa.transitions[state]?[symbol]?.join(",");
          for (String _state in nextStates?.split(",") ?? []) {
            int index = mergedEqualStates.toList().indexWhere((element) {
              return element.split(",").contains(_state);
            });
            nextStatesList.add("q$index'");
          }
        }
        transitions[key]?[symbol] = nextStatesList.join(",").split(",");
      }

      // find startState
      if (states.contains(fa.startState)) startState = key;

      // find finalStates
      for (String state in fa.finalStates) {
        if (states.contains(state)) {
          finalStates.add(key);
        }
      }
    }

    return [
      transitions,
      startState,
      finalStates,
    ];
  }

  // equal = {"q1,q2", "q1,q3", "q2,q3"}
  // => {"q1,q2,q3", "q0", "q4"}
  Set<String> mergeEqualStates(Set<String> equalPairStates) {
    Set<String> equalPairsGroup = {};

    for (String pair in equalPairStates) {
      Set<String> group = {};
      Set<String> pairInSet = pair.split(",").toSet();

      for (String state in pairInSet) {
        Set<String> result = equalPairStates.where((pair) {
          return pair.split(",").contains(state);
        }).toSet();

        Set<String> splittedStates = result.join(",").split(",").toSet();
        group.addAll(splittedStates);
      }

      equalPairsGroup.add(FaHelper.constructStates(group));
    }

    // q0,q4, q1,q7, q3,q5, which missing q2, q6. let's add them:
    Set<String> newStatesWithEqualCombined = {...equalPairsGroup};
    Set<String> equalStates = equalPairsGroup.join(",").split(",").toSet();
    for (String state in fa.states) {
      if (!equalStates.contains(state)) {
        newStatesWithEqualCombined.add(state);
      }
    }

    return newStatesWithEqualCombined;
  }
}
