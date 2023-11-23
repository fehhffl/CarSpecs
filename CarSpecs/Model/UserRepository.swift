//
//  UserRepository.swift
//  CarSpecs
//
//  Created by Felipe Lima on 09/11/23.
//

import Foundation
import SwiftyUserDefaults

enum KeyChainError: Error {
    case alreadyCreated
    case unexpectedError
}

class UserRepository {

    private let keychainDataSource = KeychainDataSource()
    private let userDefaultsDataSource = UserDefaultsDataSource()

    func registerUser(email: String, password: String, fullName: String, completion: (KeyChainError?) -> Void) {

        keychainDataSource.saveToKeychain(email: email, password: password) { error in
            if error == nil {
                userDefaultsDataSource.saveToUserDefaults(email: email, fullName: fullName)
            }
            completion(error)
        }
    }

    func getFullName(using email: String) -> String {
        return userDefaultsDataSource.getValueFromUserDefaultsAt(internalKeyName: "chave-full-name-do-email-" + email)
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
            completion(.unexpectedError)
        }
   }
}
