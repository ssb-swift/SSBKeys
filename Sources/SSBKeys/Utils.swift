import Foundation
import Crypto

/**
 Tag from a given value that corresponds to the type of encryption used to create those Keys.
 
 - Parameter value: Value to get the tag from i.e., an SSB private/public key or id.
 
 - Returns: Tag or encryption type used to encode the value.
 */
public func getTag(from value: String) -> String {
    let index = value.index(after: value.lastIndex(of: ".") ?? value.endIndex)
    return String(value[index..<value.endIndex])
}

/**
 Base-64 encoded string using a SHA-2 (Secure Hash Algorithm 2) *<SHA-256>* of a given data.
 
 - Parameters:
    - data: String representation of the data to encode.
    - encoding: String encoding property. Default value is `.utf8`.
 
 - Returns: Base-64 data hash.
 */
public func hash(data: String, encoding: String.Encoding = .utf8) -> String {
    let encodedData = data.data(using: encoding)
    let hashedData = SHA256.hash(data: encodedData.unsafelyUnwrapped)

    return "\(hashedData.description.toBase64(using: encoding)).sha256"
}

// MARK: - String Extensions

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
