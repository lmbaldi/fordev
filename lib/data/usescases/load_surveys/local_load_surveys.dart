import 'package:meta/meta.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import 'package:flutter/material.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({@required this.cacheStorage});

  List<SurveyEntity> _mapToEntity(dynamic list) {
    return list
        .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
        .toList();
  }

  List<Map> _mapToJson(List<SurveyEntity> list) {
    return list
        .map((entity) => LocalSurveyModel.fromEntity(entity).toJson())
        .toList();
  }

  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      return _mapToEntity(data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      if (data?.isEmpty != false) {
        throw Exception();
      }
      debugPrint("validate load survey ==> $data");
      return _mapToEntity(data);
    } catch (error) {
      debugPrint("validate load survey ==> $error");
      await cacheStorage.delete('surveys');
    }
  }

  Future<void> save(List<SurveyEntity> surveys) async {
    try {
      await cacheStorage.save(key: 'surveys', value: _mapToJson(surveys));
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
