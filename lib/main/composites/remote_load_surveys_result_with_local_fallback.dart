import 'package:meta/meta.dart';
import '../../data/usescases/usecases.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../domain/entities/entities.dart';

class RemoteLoadSurveysResultWithLocalFallback implements LoadSurveyResult{
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveysResultWithLocalFallback({
    @required this.remote,
    @required this.local
  });

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try{
      final surveyResult =  await remote.loadBySurvey(surveyId: surveyId);
      await local.save(surveyId: surveyId, surveyResult: surveyResult);
      return surveyResult;
    } catch(error){
      if(error == DomainError.accessDenied){
        rethrow;
      }
      await local.validate(surveyId);
      return await local.loadBySurvey(surveyId: surveyId);
    }
  }
}