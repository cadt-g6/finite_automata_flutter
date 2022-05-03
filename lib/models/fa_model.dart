// states: q0,q1,q2
// alphabets: 0,1
// transition:
// {
//   "q0": {
//     "0": ["q0"],
//     "1": ["q0"],
//   },
// };
class FaModel {
  final List<String> states;
  final List<String> symbols;
  final String initialState;
  final String finalState;
  final Map<String, Map<String, List<String>>> transitions;

  FaModel({
    required this.states,
    required this.symbols,
    required this.initialState,
    required this.finalState,
    required this.transitions,
  });
}
