//
//  KeychainConstants.swift
//  KeychainWrapper
//  Copyright © 2019 AwesomeKeychain. All rights reserved.
//
//  Created by Lukas Schlechter on 11.03.22.
//

/// Name of service
internal let service: String = "MySecretService"

/**
 Private enum to return possible errors
 */
internal enum Errors: Error {
    /// Error with the keychain creting and checking
    case creatingError
    /// Error for operation
    case operationError
}
