//
//  String+Extension.swift
//  TripBox
//
//  Created by james on 01/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit

extension String {
     func textToDouble() -> Double{
        if  let value = Double(self){
            return value
        }
        return 0.0
    }
}
