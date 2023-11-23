//
//  UserDefaultsDataSource.swift
//  CarSpecs
//
//  Created by Felipe Lima on 21/11/23.
//

import Foundation
import SwiftyUserDefaults

struct UserDefaultsDataSource {
    
    private let userDefaultsDict = SwiftyUserDefaults.Defaults
    /**
     Defaults = [
        "chave-full-name-do-email-felipe@gmail.com": "Felipe Lima",
        "chave-full-name-do-email-s.gabriel@gmail.com": "Gabriel Carvalho"
     ]
     */
    
    func saveToUserDefaults(email: String, fullName: String) {
        let internalKeyName = "chave-full-name-do-email-" + email
        // keyName = "chave-full-name-do-email-felipe@gmail.com"
        saveOnUserDefaultsAt(internalKeyName: internalKeyName, fullName: fullName)
    }
    
    private func saveOnUserDefaultsAt(internalKeyName: String, fullName: String) {
        let fullNameKey = DefaultsKey<String>(internalKeyName, defaultValue: "")
        userDefaultsDict[key: fullNameKey] = fullName
    }
   
    
    func getValueFromUserDefaultsAt(internalKeyName: String) -> String {
        let fullNameKey = DefaultsKey<String>(internalKeyName, defaultValue: "")
        return userDefaultsDict[key: fullNameKey]
    }
}
