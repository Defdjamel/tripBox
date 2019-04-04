//
//  WeatherViewController.swift
//  TripBox
//
//  Created by james on 04/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
import MapKit
class WeatherViewController: UIViewController {
    var weathers :[Weather] = []
     let locationManager = CLLocationManager.init()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       getCurrentLocation()
       updateViewData()
       requesAllWeathers()
    }
    //MARK: -  Action
    @IBAction func onClickEdit(_ sender: Any) {
        self.tableView.isEditing = !self.tableView.isEditing
    }
    
    //MARK: -  Data
    private func updateViewData(){
        weathers = Weather.all
        self.tableView.reloadData()
    }
    
     private func requesAllWeathers(){
      
        for item in Weather.all {
            if let id  = item.id_city {
                self.getWeatherForIdCity(id)
            }
        }
    }
    
    //MARK: - Request Data
    private func getWeatherForLocation(_ location : CLLocation){
        NetworkManager.sharedInstance.getWeather(nil, location, {weather in
            weather.setCurrentPosition()
            self.updateViewData()
            
        }) {
            
        }
    }
    
    private func getWeatherForIdCity(_ idCity : NSNumber){
        NetworkManager.sharedInstance.getWeather(idCity, nil, {weather in
            weather.setCurrentPosition()
            self.updateViewData()
        }) {
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  let nc = segue.destination as? UINavigationController,
            let vc = nc.viewControllers.first as? WeatherCitySearchViewController{
            vc.delegate = self
        }
    }
    

   
}

// MARK: - Location
extension WeatherViewController : CLLocationManagerDelegate{
    private func getCurrentLocation(){
        
        // Ask for Authorisation from the User.
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            //locationManager.desiredAccuracy = kCLLocationAccuracy
            locationManager.startUpdatingLocation()
        }
        
    }
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("new location")
        print(locations)
        manager.stopUpdatingLocation()
        if let location = locations.first {
             self.getWeatherForLocation(location)
        }
       
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error.localizedDescription)
    }
    
}



// MARK: - TableView
extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
}
extension WeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell",
                                                 for: indexPath) as! WeatherTableViewCell
        
        
       cell.setInterface(weathers[indexPath.row])
        
        return cell
    }
    
  
}

extension WeatherViewController : WeatherCitySearchDelegate{
    func weatherCitySearchDelegate_didSelect(city: City) {
        if let id = city.id {
             self.getWeatherForIdCity(id)
        }
       
    }
}
