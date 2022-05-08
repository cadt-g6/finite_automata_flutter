import 'package:finite_automata_flutter/helpers/fa_helper.dart';
import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

class NextInteration {
  final FaModel fa;
  NextInteration(this.fa);

  Set<String>? mergedEqualStates;
  Map<String, Map<String, List<String>>>? transitions;
  String? startState;
  List<String>? finalStates;

  bool allInFinalState(Set<String> state) {
    return state.where((e) => fa.finalStates.contains(e)).length == state.length;
  }

  void exec(Set<String> markedSets, Set<String> statesSets) {
    mergedEqualStates = findEqualStates(markedSets, statesSets);
    final nextItrResult = getNewTransitionsInfoWith(mergedEqualStates!);

    transitions = nextItrResult[0];
    startState = nextItrResult[1];
    finalStates = nextItrResult[2];
  }

  Set<String> findEqualStates(Set<String> markedSets, Set<String> statesSets) {
    markedSets = findNextMarkedSets(markedSets, statesSets);

    // {q1,q2, q1,q3, q2,q3}
    Set<String> equalPairStates = statesSets..removeAll(markedSets);

    // {q1,q2,q3, q0, q4}
    Set<String> mergedEqualStates = mergeEqualStates(equalPairStates);

    if (kDebugMode) {
      print("ALL PAIR: $statesSets");
      print("ALL MARKED: $markedSets");
      print("ALL EQUAL: $equalPairStates");
      print("NEW STATES GROUP: ${mergedEqualStates.mapIndexed((index, element) => "q$index': $element")}");
      print("\n");
    }

    return mergedEqualStates;
  }

  List<dynamic> getNewTransitionsInfoWith(Set<String> mergedEqualStates) {
    Map<String, Map<String, List<String>>> transitions = {};
    String startState = "";
    List<String> finalStates = [];

    for (int i = 0; i < mergedEqualStates.length; i++) {
      String statesStr = mergedEqualStates.elementAt(i);
      Set<String> states = statesStr.split(",").toSet();

      String key = "q$i'";
      if (transitions[key] == null) {
        transitions[key] = {};
      }

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
      if (states.contains(fa.startState)) {
        startState = key;
      }

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

  Set<String> findNextMarkedSets(Set<String> markedSets, Set<String> statesSets) {
    Set<String> newMarkedSets = {...markedSets};
    Set<String> foundStatesSets = {};

    // Try once but not yet in foundStatesSets.
    Set<String> tryOnce = {};

    while (foundStatesSets.length < statesSets.length) {
      for (String statesStr in statesSets) {
        Set<String> states = statesStr.split(",").toSet();
        foundStatesSets.add(statesStr);
        for (String symbol in fa.symbols) {
          Set<String> nextStates = nextStatesByASymbol(states, symbol);
          String nextStatesStr = FaHelper.constructStates(nextStates);
          if (foundStatesSets.contains(nextStatesStr) && newMarkedSets.contains(nextStatesStr)) {
            newMarkedSets.add(statesStr);
          } else if (!tryOnce.contains(statesStr)) {
            foundStatesSets.remove(nextStatesStr);
            tryOnce.add(statesStr);
          }
        }
      }
    }

    return newMarkedSets;
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

    Set<String> newDFAStates = {...equalPairsGroup};
    Set<String> merged = equalPairsGroup.join(",").split(",").toSet();

    for (String state in fa.states) {
      if (!merged.contains(state)) {
        newDFAStates.add(state);
      }
    }

    return newDFAStates;
  }
}
