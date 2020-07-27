# SSBKeys

Key loading and other cryptographic functions needed in Secure Scuttlebutt apps.

## Usage

TBD

## Keys API

### `> init(encryption:seed:)`

Initializes a new private key using Ed25519 over Curve25519 (no other type of encryption is supported yet) as encryption type with a random seed or using an optional seed.

**Throws:** Throws an error if the provided seed is not 32-byte long [Data][data] buffer.

### Declaration

```swift
init(encryption: Encryption = .curve25519, seed: Data? = nil)
```

### Parameters

- **encryption**: [Encryption](). Default value is `.curve25519`.
- **seed**: Optional 32-byte [Data][data] type buffer.

### `> init(from decoder:)`

Conforms to Codable *<[Decodable][decodable]>* protocol creating a new Keys instance from an external representation, like a JSON string.

**Throws:** Throws an error if reading from the decoder fails, or if the data read is corrupted or otherwise invalid.

### Declaration

```swift
init(from decoder: Decoder) throws
```

### Parameters

- **decoder**: The decoder to read data from.

### `> toJSON() -> String`

Transform Keys to a JSON representation including an additional property named `id` which is the public key prefixed by the symbol `@`.

### Declaration

```swift
public func toJSON() -> String
```

## Utilities API

### `> getTag(from value:)`

Tag from a given value that corresponds to the type of encryption used to create those Keys.

### Declaration

```swift
func getTag(from id: String) -> String
```

### Parameters

- **value**: Value to get the tag from i.e., an SSB private/public key or id.

### `> hash(data:encoding:)`

Base-64 encoded string using a SHA-2 (Secure Hash Algorithm 2) *<SHA-256>* of a given data.

### Declaration

```swift
func hash(data: String, encoding: String.Encoding = .utf8) -> String
```

### Parameters

- **data**: String representation of the data to encode.
- **encoding**: [String encoding property][string_encoding]. Default value is `.utf8`.

[data]: https://developer.apple.com/documentation/foundation/data
[string_encoding]: https://developer.apple.com/documentation/swift/string/encoding
[decodable]: https://developer.apple.com/documentation/swift/decodable
[encodable]: https://developer.apple.com/documentation/swift/encodable
