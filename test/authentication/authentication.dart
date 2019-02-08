/*
 *
 * authentication.dart
 * flutter_panda_service
 *
 * Developed by zhudelun on 2/3/19 12:44 AM.
 * Copyright (c) 2019 by Farfetch. All rights reserved.
 *
 */

import 'package:flutter_panda_foundation/flutter_panda_foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/authentication/json_web_token.dart';

void testJSONWebToken() {
  test("JSONWebToken", () {
    List<TestCase> cases = [
      TestCase(
        name: "",
        input: [
          {"scope": "abc def"}
        ],
        customTestCase: ((val) => ClaimsSet.fromJson((val as TestCase).input[0]).scope == (val as TestCase).wanted),
        wanted: "abc def",
      ),
      TestCase(
        name: "",
        input: [
          {
            "scope": ["abc", "def"]
          }
        ],
        customTestCase: ((val) => ClaimsSet.fromJson((val as TestCase).input[0]).scope == (val as TestCase).wanted),
        wanted: "abc def",
      ),
    ];

    for (TestCase pCase in cases) {
      expect(pCase.customTestCase(pCase), true);
    }
  });
}
