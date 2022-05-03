import 'package:finite_automata_flutter/models/fa_model.dart';
import 'package:finite_automata_flutter/widgets/fa_text_field.dart';
import 'package:finite_automata_flutter/widgets/fa_vertical_spacing.dart';
import 'package:flutter/material.dart';

class FaDetailScreen extends StatefulWidget {
  const FaDetailScreen({Key? key}) : super(key: key);

  @override
  State<FaDetailScreen> createState() => _FaDetailScreenState();
}

class _FaDetailScreenState extends State<FaDetailScreen> {
  List<String> states = ["q0", "q1", "q2", "q3"];
  List<String> symbols = ["0", "1"];

  String? initialState;
  String? finalState;

  Map<String, Map<String, List<String>>> transitions = {
    // "q0": {
    //   "0": ["q1"],
    //   "1": ["q0"],
    // },
    // "q1": {
    //   "0": ["q2"],
    //   "1": ["q0"],
    // },
    // "q2": {
    //   "0": ["q3"],
    //   "1": ["q0"],
    // },
    // "q3": {
    //   "0": ["q3"],
    // }
  };

  final GlobalKey<FormState> basicInfosFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> transitionFormKey = GlobalKey<FormState>();

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
        title: const Text("Add FA"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          buildBasicInfosForm(),
          const FaVerticalSpacing(),
          buildResetTransitionButton(),
          buildTransitionHeader(context),
          buildTransitionTableForm(),
          const FaVerticalSpacing(),
          buildSaveFaButton(),
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
          onPressed: () {
            if (basicInfosFormKey.currentState?.validate() == true &&
                transitionFormKey.currentState?.validate() == true) {
              FaModel(
                states: states,
                symbols: symbols,
                initialState: initialState!,
                finalState: finalState!,
                transitions: transitions,
              );
            }
          },
        ),
      ],
    );
  }

  Column buildResetTransitionButton() {
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

  Column buildTransitionHeader(BuildContext context) {
    return Column(
      children: [
        const FaVerticalSpacing(),
        const FaVerticalSpacing(),
        Text(
          "Transition",
          style: Theme.of(context).textTheme.headline6,
        ),
        const FaVerticalSpacing(),
      ],
    );
  }

  Form buildBasicInfosForm() {
    return Form(
      key: basicInfosFormKey,
      child: Column(
        children: [
          FaTextField(
            hintText: "States. eg: q0,q1",
            initialValue: states.join(","),
            onChanged: (text) {
              List<String> value = text.split(",");
              states = value;
            },
          ),
          const FaVerticalSpacing(),
          FaTextField(
            hintText: "symbols. eg: a,b,c",
            initialValue: symbols.join(","),
            onChanged: (text) {
              List<String> value = text.split(",");
              symbols = value;
            },
          ),
          const FaVerticalSpacing(),
          FaTextField(
            hintText: "Initial State",
            initialValue: initialState,
            validator: (state) => validateState(state),
            onChanged: (text) {
              if (validateState(text) != null) {
                initialState = text;
              } else {
                initialState = null;
              }
            },
          ),
          const FaVerticalSpacing(),
          FaTextField(
            hintText: "Final State",
            initialValue: finalState,
            validator: (state) => validateState(state),
            onChanged: (text) {
              if (validateState(text) != null) {
                finalState = text;
              } else {
                finalState = null;
              }
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
                      if (validateMultipleStates(states) == null) {
                        transitions[state]?[symbol] = states.split(",");
                      } else {
                        transitions[state]?[symbol] = [];
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
