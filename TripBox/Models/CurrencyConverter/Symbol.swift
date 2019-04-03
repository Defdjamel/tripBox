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
    
    func setSelected(){
        self.selected_at = Date.init()
        try? AppDelegate.viewContext.save()
    }
    
    /** this funtion return an existing object if exist else a new.
     Parameters: symbol
     */
    static func getSymbol(_ symb: String) -> Symbol {
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Symbol> = Symbol.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@ " , symb)
        if let duplicates = try? context.fetch(request), let item = duplicates.first  {
            return item
        }else{
            let symbol =  Symbol(context: context )
            symbol.name = symb
            return symbol
        }
    }
   
    static func saveSymbol(_ dict:NSDictionary) -> Symbol{
        let context = AppDelegate.viewContext
       
        //       symbol
        guard let name = dict.object(forKey: "name") as? String else {
           return Symbol(context: context)
        }
        let symbol = self.getSymbol(name)
        
       
        //       name
        if let detail = dict.object(forKey: "detail") as? String {
            symbol.detail = detail
        }
        
        try? context.save()
        return symbol
    }
    
    static var all: [Symbol] {
        let request: NSFetchRequest<Symbol> = Symbol.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return items
    }
    static var lastSelected: [Symbol] {
        let request: NSFetchRequest<Symbol> = Symbol.fetchRequest()
        request.predicate = NSPredicate(format: "selected_at != null ")
        request.sortDescriptors = [NSSortDescriptor(key: "selected_at", ascending: false)]
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return Array(items.prefix(5))
    }
    
}
