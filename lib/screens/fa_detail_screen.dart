import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/services/fa_cloud_service.dart';
import 'package:finite_automata_flutter/services/fa_service.dart';
import 'package:finite_automata_flutter/services/toast_service.dart';
import 'package:finite_automata_flutter/widgets/fa_feature_card.dart';
import 'package:finite_automata_flutter/widgets/fa_text_field.dart';
import 'package:finite_automata_flutter/widgets/fa_vertical_spacing.dart';
import 'package:flutter/material.dart';

class FaDetailScreen extends StatefulWidget {
  const FaDetailScreen({
    Key? key,
    this.faModel,
  }) : super(key: key);

  final FaModel? faModel;

  @override
  State<FaDetailScreen> createState() => _FaDetailScreenState();
}

class _FaDetailScreenState extends State<FaDetailScreen> {
  FaModel? faModel;

  @override
  void initState() {
    faModel = widget.faModel;
    super.initState();

    if (faModel != null) {
      title = faModel!.title;
      states = faModel!.states;
      symbols = faModel!.symbols;
      initialState = faModel!.initialState;
      finalState = faModel!.finalState;
      transitions = faModel!.transitions;
    }
  }

  final GlobalKey<FormState> basicInfosFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> transitionFormKey = GlobalKey<FormState>();

  List<String> states = ["q0", "q1", "q2", "q3"];
  List<String> symbols = ["0", "1"];

  String? title = "Finite Automata";
  String? initialState = "q0";
  List<String> finalState = ["q3"];

  Map<String, Map<String, List<String>>> transitions = {
    "q0": {
      "0": ["q1"],
      "1": ["q0"],
    },
    "q1": {
      "0": ["q2"],
      "1": ["q0"],
    },
    "q2": {
      "0": ["q3"],
      "1": ["q0"],
    },
    "q3": {
      "0": ["q3"],
      "1": ["q3"],
    }
  };

  Future<void> onSaveFa() async {
    String? message;

    if (basicInfosFormKey.currentState?.validate() == true && transitionFormKey.currentState?.validate() == true) {
      if (faModel?.firebaseDocumentId != null) {
        await FaCloudService().update(
          id: faModel!.firebaseDocumentId!,
          faModel: FaModel(
            title: title,
            states: states,
            symbols: symbols,
            initialState: initialState!,
            finalState: finalState,
            transitions: transitions,
          ),
        );
        message = "Updated * docID: ${faModel?.firebaseDocumentId}";
      } else {
        FaModel? result = await FaCloudService().create(FaModel(
          title: title,
          states: states,
          symbols: symbols,
          initialState: initialState!,
          finalState: finalState,
          transitions: transitions,
        ));
        faModel = result;
        message = "Created * docID: ${faModel?.firebaseDocumentId}";
        setState(() {});
      }
    } else {
      message = "Validation fails";
    }
    ToastService.showSnackbar(context: context, title: message);
  }

  String? validateState(String? state) {
    if (states.contains(state)) {
      return null;
    } else {
      return "State ($state) not in states";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          initialValue: title,
          decoration: const InputDecoration(border: InputBorder.none),
          onChanged: (text) {
            title = text;
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          // basic info
          buildBasicInfosForm(),
          const FaVerticalSpacing(),
          buildResetTransitionButton(),

          // transitions
          const FaHeader(title: "Transition"),
          buildTransitionTableForm(),
          const FaVerticalSpacing(),
          buildSaveFaButton(),

          // features
          const Divider(),
          const FaHeader(title: "Features"),
          buildFeatures(),
        ],
      ),
    );
  }

  Widget buildFeatures() {
    bool enable = faModel?.firebaseDocumentId != null;
    return Opacity(
      opacity: enable ? 1.0 : 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaFeatureCard(
            title: "Test if a FA is deterministic or non-deterministic",
            subtitle: "b",
            enable: enable,
            onPressed: () {},
          ),
          FaFeatureCard(
            title: "Test if a string is accepted by a FA",
            subtitle: "c",
            enable: enable,
            onPressed: () {},
          ),
          FaFeatureCard(
            title: "Construct an equivalent DFA from an NFA",
            subtitle: "d",
            enable: enable,
            onPressed: () {},
          ),
          FaFeatureCard(
            title: "Minimize a DFA",
            subtitle: "e",
            enable: enable,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget buildSaveFaButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          child: const Text("Save FA"),
          onPressed: () => onSaveFa(),
        ),
      ],
    );
  }

  Widget buildResetTransitionButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          child: const Text("Reset transitions"),
          onPressed: () {
            if (basicInfosFormKey.currentState?.validate() ?? false) {
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  Form buildBasicInfosForm() {
    return Form(
      key: basicInfosFormKey,
      child: Column(
        children: [
          FaTextField(
            hintText: "Eg: q0,q1",
            labelText: "States",
            initialValue: states.join(","),
            onChanged: (text) {
              List<String> value = text.split(",");
              states = value;
            },
          ),
          const FaVerticalSpacing(),
          FaTextField(
            hintText: "Eg: a,b,c",
            labelText: "Symbols",
            initialValue: symbols.join(","),
            onChanged: (text) {
              List<String> value = text.split(",");
              symbols = value;
            },
          ),
          const FaVerticalSpacing(),
          FaTextField(
            hintText: states.isNotEmpty ? "Eg. ${states.first}" : "Eg. q1",
            labelText: "Initial State",
            initialValue: initialState,
            validator: (state) => validateState(state),
            onChanged: (text) {
              initialState = text;
            },
          ),
          const FaVerticalSpacing(),
          FaTextField(
            hintText: states.isNotEmpty ? "Eg. ${states.last}" : "Eg. q3",
            labelText: "Final State",
            initialValue: finalState.join(","),
            validator: (state) => validateMultipleStates(state),
            onChanged: (text) {
              finalState = text.split(",");
            },
          ),
        ],
      ),
    );
  }

  Widget buildTransitionTableForm() {
    return Form(
      key: transitionFormKey,
      child: Table(
        border: TableBorder.all(color: Theme.of(context).dividerColor),
        children: [
          buildHeader(),
          for (String state in states)
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state),
                ),
                for (String symbol in symbols)
                  TextFormField(
                    initialValue: transitions[state]?[symbol]?.join(","),
                    validator: (states) => validateMultipleStates(states),
                    onChanged: (states) {
                      if (transitions[state] == null) transitions[state] = {};
                      if (validateMultipleStates(states) == null) {
                        transitions[state]![symbol] = states.split(",");
                      } else {
                        transitions[state]![symbol] = [];
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "state",
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      border: InputBorder.none,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  String? validateMultipleStates(String? text) {
    List<String>? states = text?.split(",");
    if (states != null) {
      for (String state in states) {
        String? error = validateState(state);
        return error;
      }
    }
    return null;
  }

  TableRow buildHeader() {
    return TableRow(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("QΣ"),
        ),
        for (String alp in symbols)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(alp),
          ),
      ],
    );
  }
}

class FaHeader extends StatelessWidget {
  const FaHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FaVerticalSpacing(mulitpleBy: 2),
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        const FaVerticalSpacing(),
      ],
    );
  }
}
