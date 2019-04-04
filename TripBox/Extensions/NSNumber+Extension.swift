//
//  NSNumber+Extension.swift
//  TripBox
//
//  Created by james on 01/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit

extension  NSNumber {
    func getFormattedCurrency() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale.current // This is the default
        return  formatter.string(from: self)!
    }

    func convertToCelsius () -> NSNumber {
        return NSNumber(value: self.doubleValue - 273.15)
    }
    func convertToFarheneit() -> NSNumber {
        return NSNumber(value: 1.8 * (self.doubleValue - 273.0 ) + 32 )
    }
}
