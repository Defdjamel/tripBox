//
//  Device.swift
//  TripBox
//
//  Created by james on 04/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit

class Device: NSObject {
    class func getDeviceLangcode() -> String{
        let defaultLang = "en"
        guard let lang =  Locale.preferredLanguages.first else{
            return defaultLang
        }
        let languageDic =  NSLocale.components(fromLocaleIdentifier: lang)
        guard let langCode =  languageDic["kCFLocaleLanguageCodeKey"]   else {
            return defaultLang
        }
        return langCode
    }
}
