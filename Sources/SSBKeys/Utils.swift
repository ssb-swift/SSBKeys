import Foundation
import Crypto

public func getTag(from id: String) -> String {
    let index = id.index(after: id.lastIndex(of: ".") ?? id.endIndex)
    return String(id[index..<id.endIndex])
}

public func hash(data: String, encoding: String.Encoding = .utf8) -> String {
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
