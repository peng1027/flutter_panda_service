import 'package:flutter_panda_service/business_service/service_comon.dart';
import 'package:flutter_panda_service/restful_service/form_data_part.dart';
import 'package:meta/meta.dart';

import 'http_network.dart';
import 'endpoints.dart';
import 'service.dart';

class RestfulServiceManager {
  static RestfulService _service = RestfulService();
  static RestfulService get service => _service;

  static void get<T>({
    @required Endpoint endpoint,
    Map<String, String> headers,
    dynamic parameters,
    @required ServiceEntityCompletion<T> completion,
  }) {
    RestfulServiceManager.service.request<T>(
      endpoint: endpoint,
      method: HTTPMethod.get,
      headers: headers,
      parameters: parameters,
      completion: completion,
    );
  }

  static void post<T>({
    @required Endpoint endpoint,
    Map<String, String> headers,
    dynamic body,
    HTTPContentType contentType,
    @required ServiceEntityCompletion<T> completion,
  }) {
    RestfulServiceManager.service.request<T>(
      endpoint: endpoint,
      method: HTTPMethod.post,
      headers: headers,
      contentType: contentType,
      body: body,
      completion: completion,
    );
  }

  static void upload<T>(
      {Endpoint endpoint,
      Map<String, String> headers,
      List<FormDataPart> formDataParts,
      dynamic parameters,
      @required ServiceEntityCompletion<T> completion}) {
    RestfulServiceManager.service.request<T>(
        endpoint: endpoint,
        method: HTTPMethod.post,
        headers: headers,
        parameters: parameters,
        dataParts: formDataParts,
        completion: completion);
  }
}
