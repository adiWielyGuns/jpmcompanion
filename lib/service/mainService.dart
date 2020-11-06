import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jpmcompanion/apiConst.dart';
import 'package:jpmcompanion/model/RequestModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../const.dart';

class MainService extends Model {
  Future<Map<String, dynamic>> login(input) async {
    var responseJson;

    try {
      final response = await http.post("$loginApi", body: input);
      responseJson = _response(response);
    } on SocketException {
      responseJson = {"status": 502, "message": "No Internet connection"};
    }
    return responseJson;
  }

  Future<Map<String, dynamic>> getNopolActive(TrackingPosition data) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'token': '$easygoToken',
    };

    if (data.listNopol == null) {
      data.listNopol = [];
    }

    var body = jsonEncode(data.toJson());
    var responseJson;
    try {
      final response = await http.post(
        "$lastPositionApi",
        headers: headers,
        body: body,
      );
      responseJson = _response(response);
    } on SocketException {
      responseJson = {"status": 502, "message": "No Internet connection"};
    }
    return responseJson;
  }

  Future<Map<String, dynamic>> getKota(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var responseJson;
    try {
      final response = await http.post(
        "$getAsalApi",
        headers: {
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: data,
      );
      responseJson = await _response(response);
    } on SocketException {
      responseJson = {"status": 502, "message": "No Internet connection"};
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    try {
      switch (response.statusCode) {
        case 201:
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        case 200:
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        case 301:
          var responseJson = {
            "status": response.statusCode,
            "message": "Api redirect error"
          };
          return responseJson;
        case 400:
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        case 401:
          var responseJson = json.decode(response.body.toString());
          messageToast(responseJson['message'], Colors.red);
          return responseJson;
          break;
        case 404:
        case 403:
          var responseJson = json.decode(response.body.toString());
          return responseJson;
        case 500:
        default:
          var responseJson = {
            "status": 502,
            "message": "No Internet connection"
          };
          return responseJson;
      }
    } catch (e) {
      print('${response.body.toString()}');
      var responseJson = {"status": 502, "msg": "No Internet connection"};
      return responseJson;
    }
  }
}
