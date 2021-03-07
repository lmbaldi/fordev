import 'package:meta/meta.dart';
import '../../http/http.dart';
import '../../../domain/helpers/helpers.dart';

class RemoteSaveSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({@required this.url, @required this.httpClient});

  Future<void> save({String answer}) async {
     try{
       await httpClient.request(url: url, method: 'PUT', body: {'answer': answer} );
     } on HttpError catch(error){
       throw error == HttpError.forbidden
           ? DomainError.accessDenied
           : DomainError.unexpected;
     }
  }
}