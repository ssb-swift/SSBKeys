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

///
/// Loads the user's SSB credentials as `<Keys>`, contained in a given file path. If the file does not exist, it will
/// create a new set of SSB credentials `<Keys>` and will store them in a file located in the given path.
///
/// - Parameter secretPath: Path to the *secret* file containing the user's SSB credentials `<Keys>`. If a path is not
///                         provided this defaults to `~/.ssb/secret`.
/// - Returns:              The user's SSB credentials as `<Keys>`.
/// - Throws:               Throws an error if the *secret* file does not contains valid SSB credentials `<Keys>`.
///
public func loadOrCreate(secretPath: String?) throws -> Keys {
    let path = secretPath ?? "\(FileManager.default.homeDirectoryForCurrentUser)/.ssb/secret"
    let keys: Keys
    
    if FileManager.default.fileExists(atPath: path) {
        keys = try loadKeys(fromPath: path)
    } else {
        keys = createKeys(atPath: path)
    }
    
    return keys
}

// MARK: Load Keys

///
/// Loads the user's SSB credentials from a `secret` file using a given path and returns them as `<Keys>`.
///
/// - Parameter path:   Path to the *secret* file containing the user's SSB credentials `<Keys>`.
/// - Returns:          The user's SSB credentials as `<Keys>`.
/// - Throws:           Throws an error if the *secret* file does not contains valid SSB credentials `<Keys>`.
///
private func loadKeys(fromPath path: String) throws -> Keys {
    let decoder = JSONDecoder()
    let content = try? String(contentsOfFile: path, encoding: .utf8)
    let credentials = retrieveCredentials(fromContent: content!)

    return try! decoder.decode(Keys.self, from: credentials.data(using: .utf8)!)
}

///
/// Extracts the content user's SSB credentials content from the file by removing the commented out text and returning
/// only the JSON representation of the SSB credentials.
///
/// - Parameter content:    *Secret* file content.
/// - Returns:              The user's SSB Credentials as a JSON representation.
///
private func retrieveCredentials(fromContent content: String) -> String {
    let start = content.firstIndex(of: "{") ?? content.startIndex
    let end = content.firstIndex(of: "}") ?? content.endIndex

    return String(content[start...end])
}

// MARK: Create Keys

///
/// Initializes a new set of SSB credentials `<Keys>` and store them in a system file using a given path.
///
/// - Parameter path:   Path to the file where the user's SSB credentials `<Keys>` will be stored.
/// - Returns:          Set of new user credentials.
///
private func createKeys(atPath path: String) -> Keys {
    let keys = Keys()

    storeCredentials(withKeys: keys, atPath: path)

    return keys
}

///
/// Writes the *secret* file containing the user's SSB credentials `<Keys>` and a warning message at a given path.
///
/// - Parameters:
///     - keys: User's SSB credentials `<Keys>` to store in the *secret* file.
///     - path: Path where the *secret* file will be created.
///
private func storeCredentials(withKeys keys: Keys, atPath path: String) {
    let content = """
    # WARNING: Never show this to anyone.
    # WARNING: Never edit it or use it on multiple devices at once.
    #
    # This is your SECRET, it gives you magical powers. With your secret you can
    # sign your messages so that your friends can verify that the messages came
    # from you. If anyone learns your secret, they can use it to impersonate you.
    #
    # If you use this secret on more than one device you will create a fork and
    # your friends will stop replicating your content.
    #
    \(keys.toJSON())
    #
    # The only part of this file that's safe to share is your public name:
    #
    #   "@\(keys.publicKey.rawRepresentation.base64EncodedString()).\(keys.encryption)"
    """

    try? content.write(toFile: path, atomically: true, encoding: .utf8)
}
