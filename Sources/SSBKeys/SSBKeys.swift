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

enum Encryption: String, Codable {
    case ed25519
}
public struct Keys {
    let encryption: Encryption
    let privateKey: Curve25519.Signing.PrivateKey
    let publicKey: Curve25519.Signing.PublicKey

    enum CodingKeys: String, CodingKey {
        case encryption = "curve"
        case privateKey = "private"
        case publicKey = "public"
        case keyId = "id"
    }
}

extension Keys {
    init(encryption: Encryption = .ed25519, seed: Data? = nil) {
        let privateKey: Curve25519.Signing.PrivateKey

        if let buffer = seed {
            privateKey = try! Curve25519.Signing.PrivateKey(rawRepresentation: buffer)
        } else {
            privateKey = Curve25519.Signing.PrivateKey()
        }

        self.encryption = encryption
        self.privateKey = privateKey
        self.publicKey = privateKey.publicKey
    }
}

extension Keys: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let privateKeyValue = try values.decode(String.self, forKey: .privateKey)
        let keyData = getData(from: privateKeyValue)

        encryption = .ed25519
        privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: keyData)
        publicKey = privateKey.publicKey
    }
}

extension Keys: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(encryption, forKey: .encryption)
        try container.encode("\(privateKey.rawRepresentation.base64EncodedString()).\(encryption)", forKey: .privateKey)
        try container.encode("\(publicKey.rawRepresentation.base64EncodedString()).\(encryption)", forKey: .publicKey)
        try container.encode("@\(publicKey.rawRepresentation.base64EncodedString()).\(encryption)", forKey: .keyId)
    }
}

extension Keys {
    public func toJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try! encoder.encode(self)

        return String(data: data, encoding: .utf8)!
    }
}

private func getData(from value: String) -> Data {
    let rawValue = String(value.prefix(upTo: value.firstIndex(of: ".") ?? value.endIndex))
    return Data(base64Encoded: rawValue)!
}
