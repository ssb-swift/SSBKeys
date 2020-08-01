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
import Crypto

///
/// Encryption types supported by SSBKeys. Currently, SSB supports Ed25519 only, so Swift SSB will keep it that way
/// unless there is interest in the community to support additional encryption types across the different
/// implementations of SSB.
///
public enum Encryption: String, Codable {
    /// EdDSA signature scheme using SHA-512 (SHA-2) and Curve25519.
    case ed25519
}

///
///Keys is a struct that follows the SSB's keys object form, but using Swift native types instead of a serialized JSON
///for easy manipulation during development.
///
/// ```JSON
/// {
///   "curve": "ed25519",
///   "private": "<base64_private_key>.ed25519",
///   "public": "<base64_public_key>.ed25519",
///   "id": "@<base64_public_key>.ed25519"
/// }
/// ```
///
public struct Keys {
    public let curve: Encryption
    public let `private`: Curve25519.Signing.PrivateKey
    public let `public`: Curve25519.Signing.PublicKey
    public let id: String

    enum CodingKeys: String, CodingKey {
        case curve
        case `private`
        case `public`
        case id
    }
}

extension Keys {
    ///
    /// Initializes a new private key using Ed25519 over Curve25519 as encryption type with a random seed or using an
    /// optional seed.
    ///
    /// - Parameters:
    ///     - encryption:   Encryption type. Default value is `.ed25519`.
    ///     - seed:         Optional 32-byte [Data](https://developer.apple.com/documentation/foundation/data) type
    ///                     buffer.
    /// - Returns:          A Keys type with EdDSA signature scheme using SHA-512 (SHA-2) over Curve25519 by default (no
    ///                     other type of encryption is supported yet), and accepts an optional seed that has to be a
    ///                     32-byte Data type buffer.
    ///
    public init(encryption: Encryption = .ed25519, seed: Data? = nil) {
        let privateKey: Curve25519.Signing.PrivateKey

        if let buffer = seed {
            privateKey = try! Curve25519.Signing.PrivateKey(rawRepresentation: buffer)
        } else {
            privateKey = Curve25519.Signing.PrivateKey()
        }

        self.curve = encryption
        self.private = privateKey
        self.public = self.private.publicKey
        self.id = "@\(self.public.rawRepresentation.base64EncodedString()).\(self.curve)"
    }
}

extension Keys: Decodable {
    ///
    /// Conforms to Codable *<[Decodable](https://developer.apple.com/documentation/swift/decodable)>* protocol creating
    /// a new Keys instance from an external representation like a JSON string.
    ///
    /// - Parameter decoder:  The decoder to read data from.
    /// - Throws:       Throws an error if reading from the decoder fails, or if the data read is corrupted or otherwise
    ///                 invalid.
    ///
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let privateKeyValue = try values.decode(String.self, forKey: .private)
        let keyData = getData(from: privateKeyValue)

        self.curve = .ed25519
        self.private = try Curve25519.Signing.PrivateKey(rawRepresentation: keyData)
        self.public = self.private.publicKey
        self.id = "@\(self.public.rawRepresentation.base64EncodedString()).\(self.curve)"
    }
}

extension Keys: Encodable {
    ///
    /// Conforms to Codable *<[Encodable](https://developer.apple.com/documentation/swift/encodable)>* protocol to
    /// transform the Keys values to strings appending the encryption type and adds a new value named `id` prefixed with
    /// the `@` symbol. If the value fails to encode anything, encoder will encode an empty keyed container in its
    /// place.
    ///
    /// - Parameter encoder:  The encoder to write data to.
    /// - Throws:       Throws an error if any values are invalid for the given encoder’s format.
    ///
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(curve, forKey: .curve)
        try container.encode("\(self.private.rawRepresentation.base64EncodedString()).\(self.curve)", forKey: .private)
        try container.encode("\(self.public.rawRepresentation.base64EncodedString()).\(self.curve)", forKey: .public)
        try container.encode(id, forKey: .id)
    }
}

extension Keys {
    ///
    /// Transform Keys to a JSON representation including an additional property named `id` which is the public key
    /// prefixed by the symbol `@`.
    ///
    /// - Returns:  Keys as a JSON string.
    ///
    public func toJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try! encoder.encode(self)

        return String(data: data, encoding: .utf8)!
    }
}

// MARK: Private Functions

///
/// Extracts the data contained in the Base-64 encoded values of the user's private or public keys by removing the curve
/// and encoding the value into a data `<buffer>`.
///
/// - Parameter value: Base-64 encoded string representing the data of the private or public keys.
/// - Returns: Data `<buffer>` representation of the string value.
///
private func getData(from value: String) -> Data {
    let rawValue = String(value.prefix(upTo: value.firstIndex(of: ".") ?? value.endIndex))
    return Data(base64Encoded: rawValue)!
}
