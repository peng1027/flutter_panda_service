/*
 * service_comon.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 1/30/19 11:20 PM
 * Copyright (c) 2019. Farfetch. All rights reserved.
 *
 */

import '../restful_service/response.dart';

typedef ServiceCompletion(Response response, Error error);
typedef ServiceEntityCompletion<T>(T data, Response response, Error error);
