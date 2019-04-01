//
//  Symbol.swift
//  TripBox
//
//  Created by james on 01/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
import CoreData
class Symbol: NSManagedObject {
   
    static func saveSymbol(_ dict:NSDictionary) -> Symbol{
        let context = AppDelegate.viewContext
        
        let symbol = Symbol(context: context)
        
        //       symbol
        if let name = dict.object(forKey: "name") as? String {
            symbol.name = name
        }
        
        //       name
        if let detail = dict.object(forKey: "detail") as? String {
            symbol.detail = detail
        }

        try? context.save()
        return symbol
    }
    
    static var all: [Symbol] {
        let request: NSFetchRequest<Symbol> = Symbol.fetchRequest()
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return items
    }
    
    static func removeAll(){
        let context = AppDelegate.viewContext
        for item in all {
            context.delete(item)
        }
    }
}
