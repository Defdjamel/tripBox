//
//  Rate.swift
//  TripBox
//
//  Created by james on 31/03/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
import CoreData
class Rate: NSManagedObject {
    static func saveRate(_ dict:NSDictionary) -> Rate{
        let context = AppDelegate.viewContext
        let rate = Rate(context: context)
       
        //       symbol
        if let symbol = dict.object(forKey: "symbol") as? String {
            rate.symbol = symbol
        }
       
        //       value
        if let value = dict.object(forKey: "value") as? Double {
            rate.value = value
        }
        
        //       time
        if let timestamp = dict.object(forKey: "timestamp") as? Double {
            rate.date = Date.init(timeIntervalSince1970: TimeInterval(timestamp))
        }
        
        //       base
        if let base = dict.object(forKey: "base") as? String {
            rate.base = base
        }
        
        try? context.save()
        return rate
    }
    
    /** Search Rate with Symbol
     ex : getRateWithSymbol("EUR")
     */
    static func getRateWithSymbol(_ symbol : String) -> Rate? {
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Rate> = Rate.fetchRequest()
        request.predicate = NSPredicate(format: "symbol = %@", symbol)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        if let rates = try? context.fetch(request), let rate = rates.first  {
            return rate
        }
        return nil
    }
    
    /** Get last date where rate updated
     */
    static func getLastUpdateDate() -> Date? {
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Rate> = Rate.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        if let rates = try? context.fetch(request), let rate = rates.first  {
            return rate.date
        }
        return nil
    }
    
    /** Get last date where rate updated
     */
    static func needUpdate() -> Bool{
        guard let lastDate = getLastUpdateDate()   else{
            return true
        }
        if  Date().hours(from:lastDate) > 24 {
            return true
        }
        return false
    }
    
    /** Calcul Converter
    */
   static func convert(fromVal: Double, fromRate: Rate,toRate: Rate) -> Double{
        //convert to base (EUR)
        let baseVal = fromVal / fromRate.value
        
        //convert from base (EUR) to new Currency
        let finalVal =  baseVal * toRate.value
        return finalVal
    }
    
}
