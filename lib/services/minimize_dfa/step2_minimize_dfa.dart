import 'package:finite_automata_flutter/helpers/fa_helper.dart';
import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

class Step2MinimizeDfa {
  Step2MinimizeDfa(this.fa);
  final FaModel fa;

  Set<String>? mergedEqualStates;

  FaModel exec() {
    mergedEqualStates = null;

    // 1st next iteration
    final List<Set<String>> firstItrResult = firstIteration();

    // {q1,q2,q3, q0, q4}
    final Set<String> markedSets = firstItrResult[0];
    final Set<String> statesSets = firstItrResult[1];

    print("V1 MARKED: $markedSets");

    // 2nd next iteration
    mergedEqualStates = findEqualStates(markedSets, statesSets);
    final nextItrResult = getNewTransitionsInfoWith(mergedEqualStates!);

    Map<String, Map<String, List<String>>> transitions = nextItrResult[0];
    String initialState = nextItrResult[1];
    List<String> finalStates = nextItrResult[2];

    return fa.copyWith(
      states: transitions.keys.toList(),
      initialState: initialState,
      finalState: finalStates,
      transitions: transitions,
    );
  }

  bool allInFinalState(Set<String> state) {
    return state.where((e) => fa.finalState.contains(e)).length == state.length;
  }

  List<Set<String>> firstIteration() {
    final Set<String> markedSets = {};
    final Set<String> statesSets = {};

    print("ONCE: ${fa.finalState}");
    for (String stateR in fa.states) {
      for (String stateC in fa.states) {
        if (stateR != stateC) {
          Set<String> sets = {stateC, stateR};
          String states = FaHelper.constructStates(sets);
          statesSets.add(states);

          for (String fstate in fa.finalState) {
            if (sets.contains(fstate)) {
              if (!allInFinalState(sets)) {
                markedSets.add(states);
              }
            }
          }
        }
      }
    }

    print("FIRST: $markedSets");

    return [markedSets, statesSets];
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
    String initialState = "";
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

      // find initialState
      if (states.contains(fa.initialState)) {
        initialState = key;
      }

      // find finalStates
      for (String state in fa.finalState) {
        if (states.contains(state)) {
          finalStates.add(key);
        }
      }
    }

    return [
      transitions,
      initialState,
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
