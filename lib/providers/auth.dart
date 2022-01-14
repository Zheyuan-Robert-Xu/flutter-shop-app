import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token; // might have the value null, just add ?
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != ''; //
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!; //conversion from a nullable to a non-nullable type,absolutely sure that the value will never be null
    }
    return ''; //avoid cannot logout bug
  }

  String get userId {
    return _userId.toString();
  }

  Future<void> _authenticate(
      String? email, String? password, String? urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDq0-tz7N0-MyRwbLwq3BJEaGQ2QOebTMk'); //runtime constant not compilation constant
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      //print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message'].toString());
      }
      _token = responseData['idToken'].toString();
      _userId = responseData['localId'].toString();
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password,
        'signUp'); // without return, it would not wait for the future of authenticate to do the job
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }
}
