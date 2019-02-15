import 'dart:_http';
import 'dart:convert';

import 'package:flutter_panda_service/restful_service/http_result.dart';

import 'http_error.dart';
import 'http_network.dart';
import 'http_request_encoder.dart';
import 'http_request_option.dart';
import 'http_response.dart';

class HttpTask {
  // the option for http request
  final HttpRequestOption _requestOption;
  HttpRequestOption get requestOption => _requestOption;

  // constructor
  HttpTask(this._requestOption);

  // generate encoded url
  String get uri {
    if (this.requestOption == null) return "";

    String url = _requestOption.url;
    final String query = RestfulQueryHelper.query(_requestOption.parameters);

    if (query.isNotEmpty) {
      if (url.indexOf("?") != -1) if (url.endsWith("&") == false)
        url += "&"; // has ?
      else
        url += "?"; // no ?

      url += query; // append query
    }

    // encode url
    url = Uri.encodeFull(url);

    return url;
  }

  static Future<HttpClientRequest> generateUriRequest(
    String url,
    HttpRequestOption option,
  ) async {
    if (option == null) {
      throw "invalid HTTP requstion option.";
    }

    HttpClientRequest request;
    Uri uri = Uri.parse(url);

    if (option.method == HttpMethod.get) {
      request = await HttpClient().getUrl(uri);
    } else if (option.method == HttpMethod.post) {
      request = await HttpClient().postUrl(uri);
    } else if (option.method == HttpMethod.delete) {
      request = await HttpClient().deleteUrl(uri);
    } else if (option.method == HttpMethod.head) {
      request = await HttpClient().headUrl(uri);
    } else if (option.method == HttpMethod.put) {
      request = await HttpClient().putUrl(uri);
    } else if (option.method == HttpMethod.patch) {
      request = await HttpClient().patchUrl(uri);
    } else if (option.method == HttpMethod.delete) {
      request = await HttpClient().deleteUrl(uri);
    } else {
      throw "invalid HTTP request method ${option.method.rawValue}";
    }

    return request;
  }

  // interface for inherited class to implementation
  Future<HttpResult> request() async {
    HttpResponse httpResponse = HttpResponse();

    return await HttpTask.generateUriRequest(
      this.uri,
      this.requestOption,
    ).then((request) {
      request = RequestEncoder.encode(request, requestOption);
      httpResponse.requestOption = requestOption;
      return request.close();
    }).then((response) {
      httpResponse.originalResponse = response;
      return response.transform(utf8.decoder).join();
    }).then((jsonStr) {
      List<int> jsonData = JsonCodec().decode(jsonStr);
      httpResponse.data = jsonData;
      return HttpResult.success(httpResponse);
    }).timeout(Duration(seconds: requestOption.timeOut), onTimeout: () {
      return HttpResult.failure(httpResponse, HttpError.timeout());
    }).catchError((error) {
      return HttpResult.failure(httpResponse, HttpError.systemError(error));
    });
  }
}
