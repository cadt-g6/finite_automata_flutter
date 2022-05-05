// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fa_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FaModelCWProxy {
  FaModel finalState(List<String> finalState);

  FaModel initialState(String initialState);

  FaModel states(List<String> states);

  FaModel symbols(List<String> symbols);

  FaModel title(String? title);

  FaModel transitions(Map<String, Map<String, List<String>>> transitions);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FaModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FaModel(...).copyWith(id: 12, name: "My name")
  /// ````
  FaModel call({
    List<String>? finalState,
    String? initialState,
    List<String>? states,
    List<String>? symbols,
    String? title,
    Map<String, Map<String, List<String>>>? transitions,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFaModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFaModel.copyWith.fieldName(...)`
class _$FaModelCWProxyImpl implements _$FaModelCWProxy {
  final FaModel _value;

  const _$FaModelCWProxyImpl(this._value);

  @override
  FaModel finalState(List<String> finalState) => this(finalState: finalState);

  @override
  FaModel initialState(String initialState) => this(initialState: initialState);

  @override
  FaModel states(List<String> states) => this(states: states);

  @override
  FaModel symbols(List<String> symbols) => this(symbols: symbols);

  @override
  FaModel title(String? title) => this(title: title);

  @override
  FaModel transitions(Map<String, Map<String, List<String>>> transitions) =>
      this(transitions: transitions);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FaModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FaModel(...).copyWith(id: 12, name: "My name")
  /// ````
  FaModel call({
    Object? finalState = const $CopyWithPlaceholder(),
    Object? initialState = const $CopyWithPlaceholder(),
    Object? states = const $CopyWithPlaceholder(),
    Object? symbols = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? transitions = const $CopyWithPlaceholder(),
  }) {
    return FaModel(
      finalState:
          finalState == const $CopyWithPlaceholder() || finalState == null
              ? _value.finalState
              // ignore: cast_nullable_to_non_nullable
              : finalState as List<String>,
      initialState:
          initialState == const $CopyWithPlaceholder() || initialState == null
              ? _value.initialState
              // ignore: cast_nullable_to_non_nullable
              : initialState as String,
      states: states == const $CopyWithPlaceholder() || states == null
          ? _value.states
          // ignore: cast_nullable_to_non_nullable
          : states as List<String>,
      symbols: symbols == const $CopyWithPlaceholder() || symbols == null
          ? _value.symbols
          // ignore: cast_nullable_to_non_nullable
          : symbols as List<String>,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      transitions:
          transitions == const $CopyWithPlaceholder() || transitions == null
              ? _value.transitions
              // ignore: cast_nullable_to_non_nullable
              : transitions as Map<String, Map<String, List<String>>>,
    );
  }
}

extension $FaModelCopyWith on FaModel {
  /// Returns a callable class that can be used as follows: `instanceOfclass FaModel.name.copyWith(...)` or like so:`instanceOfclass FaModel.name.copyWith.fieldName(...)`.
  _$FaModelCWProxy get copyWith => _$FaModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaModel _$FaModelFromJson(Map<String, dynamic> json) => FaModel(
      title: json['title'] as String?,
      states:
          (json['states'] as List<dynamic>).map((e) => e as String).toList(),
      symbols:
          (json['symbols'] as List<dynamic>).map((e) => e as String).toList(),
      initialState: json['initial_state'] as String,
      finalState: (json['final_state'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      transitions: (json['transitions'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as Map<String, dynamic>).map(
              (k, e) => MapEntry(
                  k, (e as List<dynamic>).map((e) => e as String).toList()),
            )),
      ),
    );

Map<String, dynamic> _$FaModelToJson(FaModel instance) => <String, dynamic>{
      'title': instance.title,
      'states': instance.states,
      'symbols': instance.symbols,
      'initial_state': instance.initialState,
      'final_state': instance.finalState,
      'transitions': instance.transitions,
    };
