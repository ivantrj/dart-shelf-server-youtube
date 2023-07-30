import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/rcu', _catHandler)
  ..get('/campaign', _personHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

// create a response for the rcu endpoint
Response _catHandler(Request request) {
  final cats = [
    Cat('luna', 2),
    Cat('tiger', 1),
  ];

  final catsJson = cats.map((cat) => cat.toJson()).toList();
  final jsonString = jsonEncode(catsJson);

  return Response.ok(jsonString, headers: {'content-type': 'application/json'});
}

Response _personHandler(Request request) {
  final people = [
    Person("john", 32),
    Person("huey", 27),
  ];

  final peopleJson = people.map((person) => person.toJson()).toList();
  final jsonString = jsonEncode(peopleJson);

  return Response.ok(jsonString, headers: {'content-type': 'application/json'});
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

class Cat {
  final String name;
  final int age;

  Cat(this.name, this.age);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }
}

class Person {
  final String name;
  final int age;

  Person(this.name, this.age);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }
}
