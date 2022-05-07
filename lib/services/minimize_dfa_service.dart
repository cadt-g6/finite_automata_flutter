import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/services/minimize_dfa/step1_minimize_dfa.dart';
import 'package:finite_automata_flutter/services/minimize_dfa/step2_minimize_dfa.dart';

class MinimizeDFAService {
  FaModel fa;
  MinimizeDFAService(this.fa);

  Step1MinimizeDfa? cachedStep1Service;
  Step2MinimizeDfa? cachedStep2Service;

  FaModel minialDFA() {
    fa = step1(fa);
    fa = step2(fa);
    return fa;
  }

  FaModel step1(FaModel fa) {
    cachedStep1Service = Step1MinimizeDfa(fa);
    fa = cachedStep1Service!.exec();
    return fa;
  }

  FaModel step2(FaModel fa) {
    cachedStep2Service = Step2MinimizeDfa(fa);
    fa = cachedStep2Service!.exec();
    return fa;
  }
}
