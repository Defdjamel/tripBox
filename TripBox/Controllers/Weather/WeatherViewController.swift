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
       updateWeathers()
    }
   
    //MARK: -  Data
    private func updateWeathers(){
        weathers = Weather.all
        self.tableView.reloadData()
    }
    
    //MARK: - Request Data
    private func getWeatherForLocation(_ location : CLLocation){
        NetworkManager.sharedInstance.getWeather(nil, location, {weather in
            weather.setCurrentPosition()
            self.updateWeathers()
            
        }) {
            
        }
    }
    
    private func getWeatherForIdCity(_ idCity : NSNumber){
        NetworkManager.sharedInstance.getWeather(idCity, nil, {weather in
            
            
        }) {
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func startImporting(){
        DispatchQueue.global(qos: .background).async {
            // Background thread
            DispatchQueue.main.async(execute: {
                ANLoader.showLoading("0.0%", disableUI: true)
            })
            self.importCityList()
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
extension WeatherViewController {
    private func importCityList(){
        //check if already imported
        
        //get local Json file
     
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Array<NSDictionary>  {
                    // do stuff
                    print("start importing \(jsonResult.count )")
                    var i : Float = 0
                    for city in jsonResult{
                        City.save(city)
                          i += 1
                     
                        let percent  = String(format: "%.2f", arguments: [i/Float(jsonResult.count) * 100])
                        DispatchQueue.main.async(execute: {
                            ANLoader.instance?.textLabel.text = percent + " %"
                        })
                       
                    }
                    print("finish")
                    DispatchQueue.main.async(execute: {
                         ANLoader.hide()
                    })
                   
                }
            } catch {
                // handle error
            }
        }
        
    }
}


// MARK: - WeatherViewController
extension WeatherViewController: UITableViewDataSource , UITableViewDelegate{
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
