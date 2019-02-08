import 'dart:_http';
import 'dart:convert';

import 'package:flutter_panda_service/restful_service/error.dart';
import 'package:flutter_panda_service/restful_service/request_encoder.dart';
import 'package:flutter_panda_service/restful_service/response.dart';

import 'http_network.dart';
import 'request_option.dart';

class HTTPTaskBase {
  // the option for http request
  final RequestOption _requestOption;
  RequestOption get requestOption => _requestOption;

  // consturctor
  HTTPTaskBase(this._requestOption);

  // generate encoded url
  String get uri {
    if (this.requestOption == null) return "";

    final String query = RestfulQueryHelper.query(_requestOption.parameters);
    String url = _requestOption.url;

    if (url.indexOf("?") != -1) {
      // has ?
      if (url.endsWith("&") == false) url += "&";
    } else {
      // no ?
      url += "?";
    }
    // append query
    url += query;
    url = Uri.encodeFull(url);

    return url;
  }

  // interface for inherited class to implementation
  void request() {}
}

class GET extends HTTPTaskBase {
  GET(RequestOption option) : super(option);

  @override
  void request() {
    Response httpResponse = Response();

    Uri uri = Uri.parse(this.uri);
    HttpClient().getUrl(uri).then((request) {
      request = RequestEncoder.encode(request, requestOption);
      httpResponse.requestOption = requestOption;
      return request.close();
    }).then((response) {
      httpResponse.originalResponse = response;
      return response.transform(utf8.decoder).join();
    }).then((jsonStr) {
      List<int> jsonData = JsonCodec().decode(jsonStr);
      httpResponse.data = jsonData;
      requestOption.completion(NetworkResult.success(httpResponse));
    }).timeout(Duration(seconds: requestOption.timeOut), onTimeout: () {
      requestOption.completion(NetworkResult.failure(httpResponse, RestfulError.getTimeout()));
    }).catchError((error) {
      requestOption.completion(NetworkResult.failure(httpResponse, RestfulError.getSystemError(error)));
    });
  }
}

class POST extends HTTPTaskBase {
  POST(RequestOption option) : super(option);

  @override
  void request() {
    // TODO: implement request
  }
}
