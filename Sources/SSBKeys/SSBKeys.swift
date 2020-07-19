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

enum Encryption: String {
    case curve25519 = "ed25519"
}
public struct Keys: Equatable {
    let encryption: Encryption
    let privateKey: Data
    let publicKey: Data

    init(encryption: Encryption = .curve25519, seed: Data? = nil) {
        let key: Curve25519.Signing.PrivateKey

        if let buffer = seed {
            key = try! Curve25519.Signing.PrivateKey(rawRepresentation: buffer)
        } else {
            key = Curve25519.Signing.PrivateKey()
        }

        self.encryption = encryption
        self.privateKey = key.rawRepresentation
        self.publicKey = key.publicKey.rawRepresentation
    }
}

func getTag(from id: String) -> String {
    let index = id.index(after: id.lastIndex(of: ".") ?? id.endIndex)
    return String(id[index..<id.endIndex])
}

func hash(data: String, encoding: String.Encoding = .utf8) -> String {
    let encodedData = data.data(using: encoding)
    let hashedData = SHA256.hash(data: encodedData.unsafelyUnwrapped)

    return "\(hashedData.description.toBase64(using: encoding)).sha256"
}

extension String {
    func fromBase64(using encoding: String.Encoding = .utf8) -> String {
        guard let data = Data(base64Encoded: self) else {
            return ""
        }

        return String(data: data, encoding: encoding)!
    }

    func toBase64(using encoding: String.Encoding = .utf8) -> String {
        return self.data(using: encoding)!.base64EncodedString()
    }
}
