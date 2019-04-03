//
//  Network.swift
//  wzp_challenge
//
//  Created by james on 14/03/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit

let fixer_api_key = "dad4ac5d5c79883878b26df0569bbb2b"
let google_api_key = "AIzaSyChV4pTet6skRJEpCZkt1RX124HlwRUbwo"

struct Api {
    //currency conveter
    static let getLatestRate = "http://data.fixer.io/api/latest?access_key=" + fixer_api_key
    static let getSymbols = "http://data.fixer.io/api/symbols?access_key=" + fixer_api_key
    
    //google transation
    static let translate = "https://translation.googleapis.com/language/translate/v2?key=" + google_api_key
    static let getLanguages = "https://translation.googleapis.com/language/translate/v2/languages?key=" + google_api_key
}
