import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/screens/fa_detail_screen.dart';
import 'package:finite_automata_flutter/services/minimize_dfa_service.dart';
import 'package:finite_automata_flutter/widgets/fa_toggle_theme_button.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MinimizeDFAScreen extends StatefulWidget {
  const MinimizeDFAScreen({
    Key? key,
    required this.fa,
  }) : super(key: key);

  final FaModel fa;

  @override
  State<MinimizeDFAScreen> createState() => _MinimizeDFAScreenState();
}

class _MinimizeDFAScreenState extends State<MinimizeDFAScreen> {
  late final FaModel step1;
  late final FaModel step2;

  late final MinimizeDFAService service;

  @override
  void initState() {
    service = MinimizeDFAService(widget.fa);
    step1 = service.step1(widget.fa);
    step2 = service.step2(step1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minimize DFA"),
        actions: [
          FaToggleThemeButton(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(bottom: kToolbarHeight),
        children: [
          buildFaSection(
            title: "Original DFA",
            fa: widget.fa,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          Text(
            "# Solution",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          buildFaSection(
            title: "Step1. Remove None Accessible States",
            fa: step1,
          ),
          const Divider(),
          buildFaSection(
            title: "Step2. Merge Equal States",
            fa: step2,
            appendItems: [
              buildText(
                "Equal States: ${toSentence(service.cachedStep2Service?.nextInteration.mergedEqualStates?.mapIndexed((index, element) => "q$index': {$element}").toList() ?? [])}",
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(),
          ),
          buildNavigateDFAButton(),
        ],
      ),
    );
  }

  Widget buildNavigateDFAButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          child: const Text("OPEN MINIMIZED DFA"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return FaDetailScreen(
                faModel: step2.copyWith(title: "Minimized DFA"),
              );
            }));
          },
        ),
      ],
    );
  }

  Widget buildText(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4.0),
        Text(label),
        const SizedBox(height: 4.0),
      ],
    );
  }

  String toSentence(List<String> states) {
    return states.join('  |  ');
  }

  Widget buildFaSection({
    required String title,
    required FaModel fa,
    List<Widget> appendItems = const [],
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        buildText("Start state: ${fa.startState}"),
        buildText("Final states: ${toSentence(fa.finalStates)}"),
        buildText("States: ${fa.states.join(" | ")}"),
        ...appendItems,
        const SizedBox(height: 8.0),
        const Text("Transitions:"),
        const SizedBox(height: 8.0),
        FaTransitions(fa: fa),
      ],
    );
  }
}

class FaTransitions extends StatelessWidget {
  const FaTransitions({
    Key? key,
    required this.fa,
  }) : super(key: key);

  final FaModel fa;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Theme.of(context).dividerColor),
      children: [
        buildHeader(),
        for (String state in fa.states)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(state),
              ),
              for (String symbol in fa.symbols)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${fa.transitions[state]?[symbol]?.join(",")}"),
                )
            ],
          ),
      ],
    );
  }

  TableRow buildHeader() {
    return TableRow(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("QΣ"),
        ),
        for (String alp in fa.symbols)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(alp),
          ),
      ],
    );
  }
}
