import Crypto
import XCTest
@testable import SSBKeys

final class SSBKeysTests: XCTestCase {
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
        ("testHash", testHash)
    ]
}
