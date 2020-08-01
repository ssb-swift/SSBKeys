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

final class SSBKeysTests: XCTestCase {
    func testKeysInit() {
        let keysOne = Keys()
        let keysTwo = Keys()

        XCTAssertNotNil(keysOne.curve, "The curve property exist")
        XCTAssertNotNil(keysOne.privateKey, "The privateKey property exist")
        XCTAssertNotNil(keysOne.publicKey, "The publicKey property exist")
        XCTAssertNotNil(keysOne.id, "The id property exist")
        XCTAssertNotEqual(
            keysOne.publicKey.rawRepresentation,
            keysTwo.publicKey.rawRepresentation,
            "Public keys are different"
        )
    }

    func testKeysInitWithSeed() {
        let seed = "Z!6iT@z@g8U3y8CgpqM2yAuKc_ki!*Z8".data(using: .utf8)
        let keysOne = Keys(seed: seed)
        let keysTwo = Keys(seed: seed)

        XCTAssertEqual(
            keysOne.privateKey.rawRepresentation,
            keysTwo.privateKey.rawRepresentation,
            "Private keys are equal when seeded"
        )
        XCTAssertEqual(
            keysOne.publicKey.rawRepresentation,
            keysTwo.publicKey.rawRepresentation,
            "Public keys are equal when seeded"
        )
        XCTAssertEqual(keysOne.id, keysTwo.id, "Key IDs are equal when seeded")
    }

    func testKeysInitFromJSON() {
        let keys = Keys()
        let decoder = JSONDecoder()
        let jsonData = keys.toJSON().data(using: .utf8)!
        let keysFromJSON = try! decoder.decode(Keys.self, from: jsonData)

        XCTAssertEqual(
            keys.privateKey.rawRepresentation,
            keysFromJSON.privateKey.rawRepresentation,
            "Private keys are equal when created from JSON"
        )
        XCTAssertEqual(
            keys.publicKey.rawRepresentation,
            keysFromJSON.publicKey.rawRepresentation,
            "Public keys are equal when created from JSON"
        )
        XCTAssertEqual(keys.id, keysFromJSON.id, "Key IDs are equal when created from JSON")
    }

    func testKeysToJSON() {
        let keys = Keys()
        let json = keys.toJSON()
        let jsonObject = try? JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: [])

        XCTAssertTrue(JSONSerialization.isValidJSONObject(jsonObject!), "The function returns a valid JSON")

        if let data = jsonObject as? [String: Any] {
            XCTAssertTrue(data.keys.contains("curve"), "Contains a \"curve\" key")
            XCTAssertTrue(data.keys.contains("private"), "Contains a \"private\" key")
            XCTAssertTrue(data.keys.contains("public"), "Contains a \"public\" key")
            XCTAssertTrue(data.keys.contains("id"), "Contains a \"id\" key")
        }
    }

    static var allTests = [
        ("testKeysInit", testKeysInit),
        ("testKeysInitWithSeed", testKeysInitWithSeed),
        ("testKeysInitFromJSON", testKeysInitFromJSON),
        ("testKeysToJSON", testKeysToJSON)
    ]
}
