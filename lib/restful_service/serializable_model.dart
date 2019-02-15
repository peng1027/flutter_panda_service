/*
 * serializable_model.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/19/19 3:05 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

abstract class SerializableModelProtocol {
  factory SerializableModelProtocol.fromJson(Map<String, dynamic> json) => null;
  Map<String, dynamic> toJson();

//  static SerializableModelProtocol get zero => SerializableModel();
}

//class SerializableModel implements SerializableModelProtocol {
//  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
//}
