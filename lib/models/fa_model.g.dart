// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fa_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FaModelCWProxy {
  FaModel createdAt(DateTime? createdAt);

  FaModel finalStates(List<String> finalStates);

  FaModel startState(String startState);

  FaModel states(List<String> states);

  FaModel symbols(List<String> symbols);

  FaModel title(String? title);

  FaModel transitions(Map<String, Map<String, List<String>>> transitions);

  FaModel updatedAt(DateTime? updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FaModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FaModel(...).copyWith(id: 12, name: "My name")
  /// ````
  FaModel call({
    DateTime? createdAt,
    List<String>? finalStates,
    String? startState,
    List<String>? states,
    List<String>? symbols,
    String? title,
    Map<String, Map<String, List<String>>>? transitions,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFaModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFaModel.copyWith.fieldName(...)`
class _$FaModelCWProxyImpl implements _$FaModelCWProxy {
  final FaModel _value;

  const _$FaModelCWProxyImpl(this._value);

  @override
  FaModel createdAt(DateTime? createdAt) => this(createdAt: createdAt);

  @override
  FaModel finalStates(List<String> finalStates) =>
      this(finalStates: finalStates);

  @override
  FaModel startState(String startState) => this(startState: startState);

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
  FaModel updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FaModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FaModel(...).copyWith(id: 12, name: "My name")
  /// ````
  FaModel call({
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? finalStates = const $CopyWithPlaceholder(),
    Object? startState = const $CopyWithPlaceholder(),
    Object? states = const $CopyWithPlaceholder(),
    Object? symbols = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? transitions = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return FaModel(
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      finalStates:
          finalStates == const $CopyWithPlaceholder() || finalStates == null
              ? _value.finalStates
              // ignore: cast_nullable_to_non_nullable
              : finalStates as List<String>,
      startState:
          startState == const $CopyWithPlaceholder() || startState == null
              ? _value.startState
              // ignore: cast_nullable_to_non_nullable
              : startState as String,
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
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
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
      startState: json['start_state'] as String,
      finalStates: (json['final_states'] as List<dynamic>)
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
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FaModelToJson(FaModel instance) => <String, dynamic>{
      'title': instance.title,
      'states': instance.states,
      'symbols': instance.symbols,
      'start_state': instance.startState,
      'final_states': instance.finalStates,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'transitions': instance.transitions,
    };
