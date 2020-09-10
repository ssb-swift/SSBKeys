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
        do {
            let keysOne = try Keys()
            let keysTwo = try Keys()

            XCTAssertNotNil(keysOne.curve, "The curve property exist")
            XCTAssertNotNil(keysOne.private, "The privateKey property exist")
            XCTAssertNotNil(keysOne.public, "The publicKey property exist")
            XCTAssertNotNil(keysOne.id, "The id property exist")
            XCTAssertNotEqual(
                keysOne.public.rawRepresentation,
                keysTwo.public.rawRepresentation,
                "Public keys are different"
            )
        } catch {
            XCTFail("Couldn't initialize Keys: \(error)")
        }
        
        
    }

    func testKeysInitWithSeed() {
        do {
            let seed = "Z!6iT@z@g8U3y8CgpqM2yAuKc_ki!*Z8".data(using: .utf8)
            let keysOne = try Keys(seed: seed)
            let keysTwo = try Keys(seed: seed)

            XCTAssertEqual(
                keysOne.private.rawRepresentation,
                keysTwo.private.rawRepresentation,
                "Private keys are equal when seeded"
            )
            XCTAssertEqual(
                keysOne.public.rawRepresentation,
                keysTwo.public.rawRepresentation,
                "Public keys are equal when seeded"
            )
            XCTAssertEqual(keysOne.id, keysTwo.id, "Key IDs are equal when seeded")
        } catch {
            XCTFail("Couldn't initialize Keys with seed: \(error)")
        }
    }

    func testKeysInitFromJSON() {
        do {
            let keys = try Keys()
            let decoder = JSONDecoder()
            let jsonData = try keys.toJSON().data(using: .utf8)
            let keysFromJSON = try decoder.decode(Keys.self, from: jsonData!)

            XCTAssertEqual(
                keys.private.rawRepresentation,
                keysFromJSON.private.rawRepresentation,
                "Private keys are equal when created from JSON"
            )
            XCTAssertEqual(
                keys.public.rawRepresentation,
                keysFromJSON.public.rawRepresentation,
                "Public keys are equal when created from JSON"
            )
            XCTAssertEqual(keys.id, keysFromJSON.id, "Key IDs are equal when created from JSON")
        } catch {
            XCTFail("Couldn't decode and initialize Keys from JSON: \(error)")
        }
        
    }

    func testKeysToJSON() {
        do {
            let keys = try Keys()
            let json = try keys.toJSON()
            let jsonObject = try? JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options: [])

            XCTAssertTrue(JSONSerialization.isValidJSONObject(jsonObject!), "The function returns a valid JSON")

            if let data = jsonObject as? [String: Any] {
                XCTAssertTrue(data.keys.contains("curve"), "Contains a \"curve\" key")
                XCTAssertTrue(data.keys.contains("private"), "Contains a \"private\" key")
                XCTAssertTrue(data.keys.contains("public"), "Contains a \"public\" key")
                XCTAssertTrue(data.keys.contains("id"), "Contains a \"id\" key")
            }
        } catch {
            XCTFail("Couldn't encode Keys to JSON: \(error)")
        }
    }

    static var allTests = [
        ("testKeysInit", testKeysInit),
        ("testKeysInitWithSeed", testKeysInitWithSeed),
        ("testKeysInitFromJSON", testKeysInitFromJSON),
        ("testKeysToJSON", testKeysToJSON)
    ]
}
