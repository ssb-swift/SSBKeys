//
// This source file is part of the SSBKeys open source project.
//
// Copyright (c) 2020 project authors licensed under Mozilla Public License, v.2.0.
// If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// See LICENSE for license information.
// See AUTHORS for the list of the project authors.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(KeysTests.allTests),
        testCase(StorageTests.allTests),
        testCase(UtilsTests.allTests)
    ]
}
#endif
