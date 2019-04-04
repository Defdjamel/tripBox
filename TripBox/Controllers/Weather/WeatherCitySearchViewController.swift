//
//  WeatherCitySearchViewController.swift
//  TripBox
//
//  Created by james on 04/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
import SVProgressHUD
//MARK: - DecimalKeyboardDelegate
@objc protocol WeatherCitySearchDelegate: AnyObject {
    // protocol definition goes here
    @objc func weatherCitySearchDelegate_didSelect(city : City)
}



class WeatherCitySearchViewController: UIViewController {
    var cities : [City] = []
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: WeatherCitySearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //import jsonFile to CoreData
        if City.all.count ==  0{
            startImporting()
        }
    }
    // MARK: - Action
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Data
    private func startImporting(){
        City.removeAll()
        DispatchQueue.global(qos: .utility).async {
            // Background thread
            DispatchQueue.main.async(execute: {
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show(withStatus: "Import city database...")
            })
            self.importCityList({ (array) in
                self.saveCities(array)
            })
        }
    }
}

// MARK: - searchDelegate
extension WeatherCitySearchViewController : UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if let q = searchBar.text {
              cities =  City.searchCityByKeyword(q)
            self.tableView.reloadData()
        }
    }
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension WeatherCitySearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.weatherCitySearchDelegate_didSelect(city: cities[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UITableViewDataSource
extension WeatherCitySearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier",
                                                 for: indexPath)
        
        let city = cities[indexPath.row]
       
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
//MARK: - Data importing
extension WeatherCitySearchViewController {
    /** get array of cities from JsonFile
     */
    private func importCityList(_ success : @escaping(Array<NSDictionary> ) -> Void){
        //get local Json file
        if let path = Bundle.main.path(forResource: "city.list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Array<NSDictionary>  {
                    // do stuff
                    print("start importing \(jsonResult.count )")
                    success(jsonResult)
                }
            } catch {
                // handle error
            }
        }
    }
    /** Save array in CoreData in background queu
     */
    private func saveCities(_ jsonResult : Array<NSDictionary>){
        
        for i in 0..<jsonResult.count{
           let city = jsonResult[i]
            City.save(city)
            //update screen every 0.5%
            if  i % (jsonResult.count / 200) == 0 {
                let progress = Float(i)/Float(jsonResult.count)
                let percent  = String(format: "%.1f", progress * 100)
                DispatchQueue.main.async(execute: {
                    SVProgressHUD.showProgress(progress, status:"import database\r\n" + percent + "%")
                })
            }
        }
        DispatchQueue.main.async(execute: {
            SVProgressHUD.dismiss()
            try? AppDelegate.viewContext.save()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory warning !!!")
    }
}
