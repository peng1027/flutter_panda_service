/*
 *
 * authentication.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/3/19 12:44 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';

import '../../lib/authentication/JSONWebToken.dart';

void testJSONWebToken() {
  test("JSONWebToken", () {
    List<TestCase> cases = [
      TestCase(
          name: "",
          input: [
            {"scope": "abc def"}
          ],
          output: (result) => result.scope == "abc def"),
      TestCase(
          name: "",
          input: [
            {
              "scope": ["abc", "def"]
            }
          ],
          output: (result) => result.scope == "abc def"),
    ];

    for (TestCase pCase in cases) {
      expect(pCase.output(ClaimsSet.fromJson(pCase.input[0])), true);
    }
  });
}
