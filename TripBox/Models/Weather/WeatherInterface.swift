//
//  WeatherInterface.swift
//  TripBox
//
//  Created by james on 04/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit

 /**
 WeatherInterface is an interface
 Used to populate View and Cell.
 */
protocol WeatherInterface {
    var title: String { get }
    var subtitle: String { get }
    var temperature: String { get }
    var temperatureMinMax: String { get }
    var imageUrl: String? { get }
    var currentLocation: Bool { get }
    
}
