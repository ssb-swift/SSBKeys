# SSBKeys

Key loading and other cryptographic functions needed in Secure Scuttlebutt apps.

## Usage

TBD

## API

### `getTag(from:)`

Returns the tag from a given SSB ID or Key.

#### Declaration

```swift
func getTag(from id: String) -> String
```

#### Parameters

- **from**: SSB ID or Key.

### `hash(data:encoding:)`

Returns a Base-64 encoded string of the SHA256 of a given data.

#### Declaration

```swift
func hash(data: String, encoding: String.Encoding = .utf8) -> String
```

#### Parameters

- **data**: String representation of the data to encode.
- **encoding**: [String encoding property](https://developer.apple.com/documentation/swift/string/encoding). Default value is `.utf8`.
