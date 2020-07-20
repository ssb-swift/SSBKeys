/*
 This source file is part of the SSBKeys open source project
 
 Copyright (c) 2020 project authors licensed under Mozilla Public License, v.2.0
 If a copy of the MPL was not distributed with this file, You can obtain one at
 http://mozilla.org/MPL/2.0/.

 See LICENSE for license information
 See AUTHORS for the list of the project authors
*/

import Foundation
import Crypto
import XCTest
@testable import SSBKeys

final class SSBKeysTests: XCTestCase {
    func testKeysInit() {
        let keysOne = Keys()
        let keysTwo = Keys()

        XCTAssertNotNil(keysOne.encryption, "The Encryption property exist")
        XCTAssertNotNil(keysOne.privateKey, "The privateKey property exist")
        XCTAssertNotNil(keysOne.publicKey, "The publicKey property exist")
        XCTAssertNotEqual(keysOne, keysTwo, "Public keys are different")
    }

    func testKeysInitWithSeed() {
        let seed = "Z!6iT@z@g8U3y8CgpqM2yAuKc_ki!*Z8".data(using: .utf8)
        let keysOne = Keys(seed: seed)
        let keysTwo = Keys(seed: seed)

        XCTAssertEqual(keysOne, keysTwo, "Public keys are equal when seeded")
    }

    func testGetTag() {
        let id = "@gaQw6zD4pHrg8zmrqku24zTSAINhRg=.ed25519"
        XCTAssertEqual(SSBKeys.getTag(from: id), "ed25519", "Tag from SSB ID")
    }

    func testHash() {
        // Get the correct SHA256 hash of a given data and encoding
        let utf8Data = "SSB".data(using: .utf8)
        let utf16Data = "SSB".data(using: .utf16)
        let utf8Hash = SHA256.hash(data: utf8Data.unsafelyUnwrapped)
        let utf16Hash = SHA256.hash(data: utf16Data.unsafelyUnwrapped)
        let utf8Base64String = utf8Hash.description.data(using: .utf8)!.base64EncodedString()
        let utf16Base64String = utf16Hash.description.data(using: .utf16)!.base64EncodedString()

        XCTAssertEqual(
            SSBKeys.hash(data: "SSB"),
            "\(utf8Base64String).sha256",
            "SHA256 hash with default UTF8 encoding"
        )
        XCTAssertEqual(
            SSBKeys.hash(data: "SSB", encoding: .utf8),
            "\(utf8Base64String).sha256",
            "SHA256 hash with UTF8 encoding"
        )
        XCTAssertEqual(
            SSBKeys.hash(data: "SSB", encoding: .utf16),
            "\(utf16Base64String).sha256",
            "SHA256 hash with UTF16 encoding"
        )
    }

    static var allTests = [
        ("testKeysInit", testKeysInit),
        ("testKeysInitWithSeed", testKeysInitWithSeed),
        ("testHash", testHash),
        ("testGetTag", testGetTag)
    ]
}
