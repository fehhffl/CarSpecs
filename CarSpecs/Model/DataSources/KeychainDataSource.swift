//
//  KeychainDataSource.swift
//  CarSpecs
//
//  Created by Felipe Lima on 21/11/23.
//

import Foundation

struct KeychainDataSource {
    func saveToKeychain(email: String, password: String, completion: (KeyChainError?) -> Void) {
        guard let passwordData = password.data(using: .utf8) else {
            completion(.unexpectedError)
            return
        }
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecValueData as String: passwordData
        ]
        // Creating Account with the given information
        let result = SecItemAdd(attributes as CFDictionary, nil)
        if result == noErr {
            completion(nil)
        } else {
            if result == errSecDuplicateItem {
                completion(.alreadyCreated)
            } else {
                completion(.unexpectedError)
            }
        }
        // OR completion(result == noErr)
    }
}
