/*
 This source file is part of the SSBKeys open source project
 
 Copyright (c) 2020 project authors licensed under Mozilla Public License, v.2.0
 If a copy of the MPL was not distributed with this file, You can obtain one at
 http://mozilla.org/MPL/2.0/.

 See LICENSE for license information
 See AUTHORS for the list of the project authors
*/

import Crypto

func hash(data: String, encoding: String.Encoding = .utf8) -> String {
    let encodedData = data.data(using: encoding)
    let hashedData = SHA256.hash(data: encodedData.unsafelyUnwrapped)

    return "\(hashedData.description.toBase64(using: encoding)).sha256"
}

extension String {
    func toBase64(using encoding: String.Encoding = .utf8) -> String {
        return self.data(using: encoding)!.base64EncodedString()
    }
}
