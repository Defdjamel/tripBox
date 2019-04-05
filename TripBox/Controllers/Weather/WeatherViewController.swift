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
    let refreshCtrl = UIRefreshControl.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       addRefreshControl()
       getCurrentLocation()
       updateViewData()
       requesAllWeathers()
    }
    //MARK: UI
    private func addRefreshControl(){
        
        refreshCtrl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshCtrl.tintColor = UIColor.lightGray
        self.tableView.refreshControl = refreshCtrl
    }
    
    //MARK: -  Action
    @IBAction func onClickEdit(_ sender: Any) {
        self.tableView.isEditing = !self.tableView.isEditing
    }
    @objc func refreshData(){
        requesAllWeathers()
    }
    //MARK: -  Data
    private func updateViewData(){
        weathers = Weather.all
        self.tableView.reloadData()
    }
    
    //MARK: - Request Data
    /** requets Data for weather with location
     should be the current location
     */
    private func getWeatherForLocation(_ location : CLLocation){
        NetworkManager.sharedInstance.getWeather(nil, location, {weather in
            weather.setCurrentPosition(false)
            Weather.removeAllWeatherCurrentPosition()
            weather.setCurrentPosition(true)
            
            self.updateViewData()
        }) {
            
        }
    }
    /** requets Data for weather with Id city
     */
    private func getWeatherForIdCity(_ idCity : NSNumber, success : @escaping() -> Void){
        NetworkManager.sharedInstance.getWeather(idCity, nil, {weather in
            self.updateViewData()
            success()
        }) {
            
        }
    }
    
    /** requets Data for all weather in screen
     */
    private func requesAllWeathers(){
        var requestDone = 0
        for item in Weather.all {
            guard let id  = item.id_city else {
                return
            }
            self.getWeatherForIdCity(id) {
                requestDone += 1
                if requestDone == Weather.all.count {
                    self.refreshCtrl.endRefreshing()
                }
            }
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
    
        if editingStyle == .delete {
            // Delete the row from the data source
            self.weathers[indexPath.row].remove()
            self.weathers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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
            self.getWeatherForIdCity(id) {
            }
        }
    }
}
