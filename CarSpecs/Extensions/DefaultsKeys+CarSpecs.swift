//
//  DefaultsKeys+CarSpecs.swift
//  CarSpecs
//
//  Created by Felipe Lima on 20/09/23.
//

import SwiftyUserDefaults


extension DefaultsKeys {
    static var favoriteCars: DefaultsKey<[Car]> { DefaultsKey("favoriteCarsKey", defaultValue: []) }
    var username: DefaultsKey<String?> { .init("username") }
}
