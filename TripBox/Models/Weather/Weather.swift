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
    
    func setCurrentPosition(_ value : Bool){
        self.isCurrentPosition = value
        try? AppDelegate.viewContext.save()
    }
    func remove(){
        let context = AppDelegate.viewContext
        context.delete(self)
        try? context.save()
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
    /** Add or update a weather
     */
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
        
        //       temp min
        if let main = dict.object(forKey: "main") as? NSDictionary,
            let temp_min =  main.object(forKey: "temp_min") as? NSNumber {
            weather.temp_min = temp_min
        }
        
        //       temp max
        if let main = dict.object(forKey: "main") as? NSDictionary,
            let temp_max =  main.object(forKey: "temp_max") as? NSNumber {
            weather.temp_max = temp_max
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
    /** get All Weathers
     */
    static var all: [Weather] {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: true)]
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return items
    }
    /** get Weather item with current position at true
     (should be one)
     */
    static var allCurrentPosition : [Weather]{
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        request.predicate = NSPredicate(format: "isCurrentPosition =  true"  )
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return items
    }
    /** remove all weather in current position
     */
    static func removeAllWeatherCurrentPosition(){
        let context = AppDelegate.viewContext
        for item in allCurrentPosition {
            context.delete(item)
        }
        try? context.save()
        
    }
    
    
    
}
/**
 RecipeInterface is an interface of Recipe
 Used to populate View and Cell.
 */
extension Weather : WeatherInterface {
    var temperature: String {
        guard var temp = self.temp else{
            return "_"
        }
        var unit = "C"
        if self.isCelcius {
            temp = temp.convertToCelsius()
        }else{
            unit = "F"
            temp = temp.convertToFarheneit()
        }
        
        return String(format: "%1.0f°%@", temp.floatValue,unit)
    }
    
    var imageUrl: String? {
        guard let icon = self.icon else{
            return nil
        }
        return "https://openweathermap.org/themes/openweathermap/assets/vendor/owm/img/widgets/\(icon).png"
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
    var currentLocation: Bool {
        return self.isCurrentPosition
    }
    var temperatureMinMax: String {
        guard var tempMin = self.temp_min, var tempMax = self.temp_max else{
            return ""
        }
        var unit = "C"
        if self.isCelcius {
            tempMin = tempMin.convertToCelsius()
            tempMax = tempMax.convertToCelsius()
        }else{
            unit = "F"
            tempMin = tempMin.convertToFarheneit()
            tempMax = tempMax.convertToFarheneit()
        }
      return String(format: "%1.0f - %1.0f °%@", tempMin.floatValue,tempMax.floatValue,unit)
    }
}
