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
