import 'package:http/http.dart';
import 'package:fordev/data/http/http.dart';
import 'package:fordev/infra/http/http.dart';

HttpClient makeHttpAdapter() => HttpAdapter(Client());

