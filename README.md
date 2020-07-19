# SSBKeys

Key loading and other cryptographic functions needed in Secure Scuttlebutt apps.

## Usage

TBD

## API

### `> init(encryption:seed:)`

Creates and returns a Keys type with encryption Curve25519 `<ed25519>` by default (no other type of encryption is supported yet) and accepts an optional seed that has to be a 32-byte [Data][data] type buffer.

**Note**: if the provided seed is not 32-byte long, this function throws.

### Declaration

```swift
init(encryption: Encryption = .curve25519, seed: Data? = nil) -> Keys
```

### Parameters

- **encryption**: [Encryption](). Default value is `.curve25519`.
- **seed**: Optional 32-byte [Data][data] type buffer.

### `> getTag(from:)`

Returns the tag from a given SSB ID or Key.

#### Declaration

```swift
func getTag(from id: String) -> String
```

#### Parameters

- **from**: SSB ID or Key.

### `> hash(data:encoding:)`

Returns a Base-64 encoded string of the SHA256 of a given data.

#### Declaration

```swift
func hash(data: String, encoding: String.Encoding = .utf8) -> String
```

#### Parameters

- **data**: String representation of the data to encode.
- **encoding**: [String encoding property][string_encoding]. Default value is `.utf8`.

[data]: https://developer.apple.com/documentation/foundation/data
[string_encoding]: https://developer.apple.com/documentation/swift/string/encoding
