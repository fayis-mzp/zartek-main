import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;

import 'package:dio/dio.dart';
import 'package:zartek_test/controller/app_controller.dart';
import 'package:zartek_test/services/network/connectivity_request_retrier.dart';

class DioRequestHandler {
  dynamic responsebody;
  var dio = Dio();
  // ErrorResponse? error;
  AppController appCt = g.Get.find();

  Future<bool> getRequest(
      String urlExtension, Map<String, dynamic> body) async {
    // logSuccess('Bearer ${appCt.token}');
    print(urlExtension);
    print(body);

    Response response;

    var isSuccess;
    try {
      response = await dio.get(
        urlExtension,
        queryParameters: body,
        // options: Options(
        //     headers: appCt.token == null
        //         ? {
        //             "Accept": "application/json",
        //             "content-type": "application/json",
        //             "Accept-Language": appCt.language!
        //           }
        //         : {
        //             "Accept": "application/json",
        //             "content-type": "application/json",
        //             "Authorization": "Bearer " + appCt.token!,
        //             "Accept-Language": appCt.language!
        //           }
        //           )
      );
      print(response.data.toString());

      if (response.data != null) {
        responsebody = response.data;
      }
      if (response.statusCode == 200 || response.statusCode == 204) {
        isSuccess = true;
      }
    } on DioException catch (err) {
      if (err.error is SocketException &&
          err.type == DioExceptionType.unknown &&
          err.error != null) {
        response = await DioConnectivityRequestRetrier(
                dio: dio, connectivity: Connectivity())
            .scheduleRequestRetry(err.requestOptions);
        if (response.data.isNotEmpty) {
          responsebody = response.data;
        }
        if (response.statusCode == 200 || response.statusCode == 204) {
          isSuccess = true;
        }
      } else if (err.response!.statusCode == 400) {
        // if (err.response!.data.containsKey('responseMessage')) {
        //   print(err.response!.data);
        //   error = ErrorResponse.fromJson(err.response!.data);
        //   print(error?.responseMessage);
        //   if (error?.responseMessage != null) {
        //     g.Get.dialog(ErrorDialog(error?.responseMessage ?? ''));
        //   } else {
        //     g.Get.dialog(ErrorDialog('Something_went_wrong'.tr));
        //   }
        // }
        isSuccess = false;
      } else if (err.response!.statusCode == 401 &&
          err.response!.statusMessage == "Unauthorized") {
        //////////  do refresh token
        // await AuthApi().refreshToken();

        response = await retryRequest(err.requestOptions);
        responsebody = response.data;

        // if (appCt.myProfile == null) {
        //   await appCt.getProfile();
        // }

        isSuccess = true;
      } else if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.connectionError ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.sendTimeout) {
        print('check your connection');
        g.Get.snackbar(
          "Request timeout",
          "Check your internet connection",
          icon: const Icon(Icons.signal_cellular_connected_no_internet_4_bar,
              color: Colors.white),
          snackPosition: g.SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
        // print(err);
      }
      // print(err);
    }

    return isSuccess;
  }

  Future<bool> postRequest(String urlExtension, dynamic body) async {
    // logSuccess('Bearer ${appCt.token}');
    print(urlExtension);
    print(body);
    Response response;
    var isSuccess;
    try {
      var response = await dio.post(
        urlExtension,
        data: body,
        // options: Options(
        //     headers: appCt.token == null
        //         ? {
        //             "Accept": "application/json",
        //             "content-type": "application/json",
        //             "Accept-Language": appCt.language!
        //           }
        //         : {
        //             "Accept": "application/json",
        //             "content-type": "application/json",
        //             "Authorization": "Bearer " + appCt.token!,
        //             "Accept-Language": appCt.language!
        //           })
      );
      print(response.data.toString());

      if (response.data != null) {
        responsebody = response.data;
      }
      if (response.statusCode == 200 || response.statusCode == 204) {
        isSuccess = true;
      } else {
        isSuccess = false;
        // g.Get.dialog(ErrorDialog('Something_went_wrong'.tr));
      }
    } on DioException catch (err) {
      if (err.error is SocketException &&
          err.type == DioExceptionType.unknown &&
          err.error != null) {
        response = await DioConnectivityRequestRetrier(
                dio: dio, connectivity: Connectivity())
            .scheduleRequestRetry(err.requestOptions);
        // response = await retryRequest(err.requestOptions);
        if (response.data.isNotEmpty) {
          responsebody = response.data;
        }
        if (responsebody != null) {
          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else if (err.response!.statusCode == 400) {
        // if (err.response!.data.containsKey('responseMessage')) {
        //   print(err.response!.data);
        //   error = ErrorResponse.fromJson(err.response!.data);
        //   print(error?.responseMessage);
        //   if (error?.responseMessage != null) {
        //     g.Get.dialog(ErrorDialog(error?.responseMessage ?? ''));
        //   } else {
        //     g.Get.dialog(ErrorDialog('Something_went_wrong'.tr));
        //   }
        // }
        isSuccess = false;
      } else if (err.response!.statusCode == 401 &&
          err.response!.statusMessage == "Unauthorized") {
        //////////  do refresh token
        // await AuthApi().refreshToken();

        response = await retryRequest(err.requestOptions);
        responsebody = response.data;

        // if (appCt.myProfile == null) {
        //   await appCt.getProfile();
        // }

        isSuccess = true;
      } else if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.connectionError ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.sendTimeout) {
        print('check your connection');
        g.Get.snackbar(
          "Request timeout",
          "Check your internet connection",
          icon: const Icon(Icons.signal_cellular_connected_no_internet_4_bar,
              color: Colors.white),
          snackPosition: g.SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
        // print(err);
      }
      print(err);
    }

    return isSuccess;
  }

  Future<Response> retryRequest(RequestOptions requestOptions) async {
    Response response = await dio.request(requestOptions.path,
        cancelToken: requestOptions.cancelToken,
        data: requestOptions.data,
        onReceiveProgress: requestOptions.onReceiveProgress,
        onSendProgress: requestOptions.onSendProgress,
        queryParameters: requestOptions.queryParameters,
        options: Options(
          headers: requestOptions.headers,
          // method: requestOptions.method,
        ));
    return response;
  }
}
