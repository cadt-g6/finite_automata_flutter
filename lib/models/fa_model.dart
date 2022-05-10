import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fa_model.g.dart';

@CopyWith()
@JsonSerializable()
class FaModel {
  final String? title;
  final List<String> states;
  final List<String> symbols;
  final String startState;
  final List<String> finalStates;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// ```dart
  /// final transitions = {
  ///   "q0": {
  ///     "0": ["q1"],
  ///     "1": ["q3"]
  ///   },
  ///   ...
  /// }
  /// ```
  final Map<String, Map<String, List<String>>> transitions;

  @JsonKey(ignore: true)
  String? firebaseDocumentId;

  void validateSymbols() {
    Map<String, Map<String, List<String>>> validatedTransition = {};
    for (final transition in transitions.entries) {
      validatedTransition[transition.key] = {};
      for (final symbolsMap in transition.value.entries) {
        if (symbols.contains(symbolsMap.key)) {
          validatedTransition[transition.key]?[symbolsMap.key] = symbolsMap.value;
        }
      }
    }
    transitions.clear();
    transitions.addAll(validatedTransition);
  }

  FaModel({
    required this.title,
    required this.states,
    required this.symbols,
    required this.startState,
    required this.finalStates,
    required this.transitions,
    required this.createdAt,
    required this.updatedAt,
  }) {
    validateSymbols();
  }

  factory FaModel.fromJson(Map<String, dynamic> json) => _$FaModelFromJson(json);
  Map<String, dynamic> toJson() => _$FaModelToJson(this);
}
