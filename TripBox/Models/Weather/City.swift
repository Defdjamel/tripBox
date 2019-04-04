//
//  City.swift
//  TripBox
//
//  Created by james on 04/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
import CoreData

class City: NSManagedObject {

    static func save(_ dict:NSDictionary){
        let moc = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = moc
        
        //let context = AppDelegate.viewContext
        let object = City(context: context)
        
        //       id
        if let id = dict.object(forKey: "id") as? NSNumber {
            object.id = id
        }
        
        //       name
        if let name = dict.object(forKey: "name") as? String {
            object.name = name
        }
        
        //       country
        if let country = dict.object(forKey: "country") as? String {
            object.country = country
        }
        
        //       coord
        if let coord = dict.object(forKey: "coord") as? NSDictionary,
            let lat = coord.object(forKey: "lat") as? Double ,
            let lon = coord.object(forKey: "lon") as? Double
        {
                 object.lon = lon
                 object.lat = lat
        }
        
        //try? context.save()
        
        
      
        
        context.perform({
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        })
        
        
    }
    
    
    /** Get all  sorted by A-Z
     */
    static var all: [City] {
        let request: NSFetchRequest<City> = City.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
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
