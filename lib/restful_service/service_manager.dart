import 'http_form_data_part.dart';
import 'package:meta/meta.dart';

import 'http_network.dart';
import 'endpoints.dart';
import 'service.dart';
import 'service_result.dart';

class RestfulServiceManager {
  static RestfulService _service = RestfulService();

  static Future<ServiceEntityResultProtocol> get({
    @required Endpoint endpoint,
    Map<String, String> headers,
    dynamic parameters,
  }) async {
    ServiceEntityResultProtocol result = await RestfulServiceManager._service.request(
      endpoint: endpoint,
      method: HttpMethod.get,
      headers: headers,
      parameters: parameters,
    );
    return result;
  }

  static Future<ServiceEntityResultProtocol> post({
    @required Endpoint endpoint,
    Map<String, String> headers,
    dynamic body,
    HTTPContentType contentType,
  }) async {
    ServiceEntityResultProtocol result = await RestfulServiceManager._service.request(
      endpoint: endpoint,
      method: HttpMethod.post,
      headers: headers,
      contentType: contentType,
      body: body,
    );
    return result;
  }

  // TODO: other HTTP request type should be written at here. for example, PUT, DELETE etc.

  static Future<ServiceEntityResultProtocol> upload({
    Endpoint endpoint,
    Map<String, String> headers,
    List<HttpFormDataPart> formDataParts,
    dynamic parameters,
  }) async {
    ServiceEntityResultProtocol result = await RestfulServiceManager._service.request(
      endpoint: endpoint,
      method: HttpMethod.post,
      headers: headers,
      parameters: parameters,
      dataParts: formDataParts,
    );
    return result;
  }
}
