// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fa_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaModel _$FaModelFromJson(Map<String, dynamic> json) => FaModel(
      states:
          (json['states'] as List<dynamic>).map((e) => e as String).toList(),
      symbols:
          (json['symbols'] as List<dynamic>).map((e) => e as String).toList(),
      initialState: json['initial_state'] as String,
      finalState: json['final_state'] as String,
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
      'states': instance.states,
      'symbols': instance.symbols,
      'initial_state': instance.initialState,
      'final_state': instance.finalState,
      'transitions': instance.transitions,
    };
