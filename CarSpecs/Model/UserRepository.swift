//
//  UserRepository.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/11/23.
//

import Foundation

enum KeyChainError: Error {
    case alreadyCreated
    case other
}

class UserRepository {

    func registerUser(user: String, password: String, completion: (KeyChainError?) -> Void) {
        guard let passwordData = password.data(using: .utf8) else {
            completion(.other)
            return
        }
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: user,
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
                completion(.other)
            }
        }
        // OR completion(result == noErr)
    }
    func login(typedPassword: String, typedUser: String, completion: (KeyChainError?) -> Void) {
        let consulta: [String: Any] = [
            kSecAttrAccount as String: typedUser,
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnData as String: true,
            kSecReturnAttributes as String: true
        ]
        var item: CFTypeRef?
        if SecItemCopyMatching(consulta as CFDictionary, &item) == noErr,
           let itemAsDict = item as? [String: Any],
           let passwordData = itemAsDict[kSecValueData as String] as? Data,
           let passwordString = String(data: passwordData, encoding: .utf8),
           typedPassword == passwordString {
            completion(nil)
        } else {
            completion(.other)
        }
   }
}

