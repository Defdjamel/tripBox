//
//  Weather.swift
//  TripBox
//
//  Created by james on 04/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
import CoreData

class Weather: NSManagedObject {
    
    func setCurrentPosition(){
        self.isCurrentPosition = true
        try? AppDelegate.viewContext.save()
    }
    

    /** this funtion return an existing object if exist else a new.
     Parameters: symbol
     */
    static func getWeather(_ idCity: NSNumber) -> Weather {
        let context = AppDelegate.viewContext
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        request.predicate = NSPredicate(format: "id_city == %@ " , idCity)
        if let duplicates = try? context.fetch(request), let item = duplicates.first  {
            return item
        }else{
            let object =  Weather(context: context )
            object.id_city = idCity
            object.created_at = Date()
            return object
        }
    }
    
    static func saveWeather(_ dict:NSDictionary) -> Weather{
        let context = AppDelegate.viewContext
        
        //       idCity
        guard let idCity = dict.object(forKey: "id") as? NSNumber else {
            return Weather(context: context)
        }
        let weather = self.getWeather(idCity)
        
        //       name
        if let name = dict.object(forKey: "name") as? String {
            weather.name_city = name
        }
        
         //       temp
        if let main = dict.object(forKey: "main") as? NSDictionary,
            let temp =  main.object(forKey: "temp") as? NSNumber {
            weather.temp = temp
        }
        
        //        weather
        if let weathers = dict.object(forKey: "weather") as? NSArray,
            let item =  weathers.firstObject as? NSDictionary,
            let description = item.object(forKey: "description") as? String,
              let icon = item.object(forKey: "icon") as? String
            
        {
            weather.weather = description
            weather.icon = icon
        }
        
        
        //       updated_at
        weather.updated_at = Date()
        
        try? context.save()
        return weather
    }
    
    static var all: [Weather] {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: true)]
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return items
    }
    
    
}
/**
 RecipeInterface is an interface of Recipe
 Used to populate View and Cell.
 */
extension Weather : WeatherInterface {
    var temperature: String {
        guard let temp = self.temp else{
            return "_"
        }
        return String(format: "%1.0f°", temp.floatValue)
    }
    
    var imageUrl: String? {
        return "https://openweathermap.org/themes/openweathermap/assets/vendor/owm/img/widgets/09d.png"
    }
    
    var title: String {
        guard let name =  self.name_city else {
            return "-"
        }
        return name
    }
    
    var subtitle: String {
        guard let weather =  self.weather else {
            return "-"
        }
        return weather
    }

}
