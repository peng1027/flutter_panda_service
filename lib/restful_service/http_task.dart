import 'dart:_http';
import 'dart:convert';

import 'error.dart';
import 'request_encoder.dart';
import 'response.dart';
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

  static Future<HttpClientRequest> generateUriRequest(String url, RequestOption option) async {
    if (option == null) throw "invalid HTTP requstion option.";

    HttpClientRequest request;
    Uri uri = Uri.parse(url);

    if (option.method == HTTPMethod.options) {
    } else if (option.method == HTTPMethod.get) {
      request = await HttpClient().getUrl(uri);
    } else if (option.method == HTTPMethod.post) {
      request = await HttpClient().postUrl(uri);
    } else if (option.method == HTTPMethod.delete) {
      request = await HttpClient().deleteUrl(uri);
    } else if (option.method == HTTPMethod.head) {
      request = await HttpClient().headUrl(uri);
    } else if (option.method == HTTPMethod.put) {
      request = await HttpClient().putUrl(uri);
    } else if (option.method == HTTPMethod.patch) {
      request = await HttpClient().patchUrl(uri);
    } else if (option.method == HTTPMethod.delete) {
      request = await HttpClient().deleteUrl(uri);
    } else {
      throw "invalid HTTP request method ${option.method.rawValue}";
    }

    return request;
  }

  // interface for inherited class to implementation
  void request() {
    Response httpResponse = Response();

    HTTPTaskBase.generateUriRequest(this.uri, this.requestOption).then((request) {
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
      requestOption.completion(NetworkResult.failure(httpResponse, RestfulError.timeout()));
    }).catchError((error) {
      requestOption.completion(NetworkResult.failure(httpResponse, RestfulError.systemError(error)));
    });
  }
}
