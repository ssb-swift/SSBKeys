//
// This source file is part of the SSBKeys open source project.
//
// Copyright (c) 2020 project authors licensed under Mozilla Public License, v.2.0.
// If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// See LICENSE for license information.
// See AUTHORS for the list of the project authors.
//

import Foundation
import XCTest
import SSBKeys

final class StorageTests: XCTestCase {
    let path = "\(FileManager.default.temporaryDirectory.path)/secret"

    /// Remove the temporal *secret* file before running every test
    override func setUp() {
        super.setUp()
        try? FileManager.default.removeItem(atPath: path)
    }

    func testLoadOrCreate() {
        XCTAssertFalse(
            FileManager.default.fileExists(atPath: path),
            "The secret file doesn't exist before calling the function"
        )
        
        do {
            let keysOne = try SSBKeys.loadOrCreate(secretPath: path)
            XCTAssertTrue(FileManager.default.fileExists(atPath: path), "The secret file was created at the given path")
            
            let keysTwo = try SSBKeys.loadOrCreate(secretPath: path)
            XCTAssertEqual(
                keysOne.privateKey.rawRepresentation,
                keysTwo.privateKey.rawRepresentation,
                "The keys were loaded from the secret file, not by creating a new set of Keys"
            )
        } catch {
            XCTFail("Couldn't create Keys: \(error)")
        }
    }
    
    /// Remove the temporal *secret* file after running every test
    override func tearDown() { // 8.
            try? FileManager.default.removeItem(atPath: path)
            super.tearDown()
        }

    static var allTests = [
        ("testLoadOrCreate", testLoadOrCreate)
    ]
}

