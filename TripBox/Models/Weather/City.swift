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
        let moc = AppDelegate.viewContext
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = moc
       // privateContext.persistentStoreCoordinator = moc.persistentStoreCoordinator
     //   let privateContext = AppDelegate.viewContext
      
        let object = City(context: privateContext)
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
        
        
        privateContext.performAndWait {
            do {
                try privateContext.save()
               
            } catch {
                fatalError("Failure to save context: \(error)")
            }
    
         }
        
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
    static func searchCityByKeyword(_ q :String) -> [City] {
        let request: NSFetchRequest<City> = City.fetchRequest()
        request.predicate = NSPredicate(format: "name contains[c] %@",q )
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.fetchLimit = 100
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return items
    }
}
