import 'package:rapid_http/rapid_http.dart';

void main() async {
  // add default headers to singlton client (optional)
  RapidClient().setDefaultHeader('Content-Type', 'application/json');
  
  final response =
      await RapidClient().get('https://jsonplaceholder.typicode.com/todos');
}
