import 'package:finite_automata_flutter/models/fa_model.dart';

class MinimizeDFAService {
  final FaModel fa;
  MinimizeDFAService(this.fa);

  void minialDFA() {
    removeNoneAccessibleStates();
  }

  void removeNoneAccessibleStates() {}
}
