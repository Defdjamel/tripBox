//
//  Lang.swift
//  TripBox
//
//  Created by james on 03/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
import CoreData

class Lang: NSManagedObject {
    /** Add new Item
     */
    static func saveLang(_ dict:NSDictionary) -> Lang{
        let context = AppDelegate.viewContext
        
        let lang = Lang(context: context)
        
        //       language
        if let language = dict.object(forKey: "language") as? String {
            lang.language = language
        }
        
        //       name
        if let name = dict.object(forKey: "name") as? String {
            lang.name = name
        }
        
        try? context.save()
        return lang
    }
    
    /** Search Rate with Symbol
     ex : getRateWithSymbol("fr")
     */
    static func getLangWithSymbol(_ symbol : String) -> Lang? {
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Lang> = Lang.fetchRequest()
        request.predicate = NSPredicate(format: "language = %@", symbol)
        if let langs = try? context.fetch(request), let lang = langs.first  {
            return lang
        }
        return nil
    }
    
    /** Get all Lang sorted by A-Z
     */
    static var all: [Lang] {
        let request: NSFetchRequest<Lang> = Lang.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "language", ascending: true)]
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return items
    }
    
    /** Remove all data
     */
    static func removeAll(){
        let context = AppDelegate.viewContext
        for item in all {
            context.delete(item)
        }
    }
}
