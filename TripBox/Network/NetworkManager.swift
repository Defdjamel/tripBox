//
//  NetworkManager.swift
//  wzp_challenge
//
//  Created by james on 14/03/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
import CoreLocation

enum  httpMethod : String{
     case post = "POST"
     case get = "GET"
}



class NetworkManager: NSObject {
    static let sharedInstance = NetworkManager()
    
    private override init() {} //init is not accessible...singleton pattern
}

//MARK: - REQUESTS
extension NetworkManager {
    
    private  func createRequest(_ method: httpMethod,_ url : String, _ parameters : [String:Any]) -> URLRequest {
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = method.rawValue
       
        //add parameters for post
        let data = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = data
        //add parameters for get
        
         //add parameters header
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
   private  func dataRequest(_ method: httpMethod,_ url: String, _ parameters : [String:Any], success: @escaping (NSDictionary) -> Void, failed: @escaping () -> Void){
        //Create Request
        let request = createRequest(method, url,parameters)
        print(url)
        let session = URLSession(configuration: .default)
        
        //init Task queu separed
         let session_task = session.dataTask(with: request) { (data, response, error) in
           
            guard let data = data, error == nil else {
                print(error.debugDescription)
                failed()
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                failed()
                return
            }
            
            do {
                 let jsonDict =   try JSONSerialization.jsonObject(with: data)
                // Le code ici s'éxecute dans la Main Queue
                if let jsonDict = jsonDict as? NSDictionary {
                     DispatchQueue.main.async {
                         success(jsonDict)
                    }
                }
            }
            catch{
                print(error)
            }
        }
        
        session_task.resume()
    }

    //MARK: - GET RATES
    func getRates(_ success: @escaping () -> Void, failed: @escaping () -> Void) {
       
        dataRequest(httpMethod.post , Api.getLatestRate,[:], success: { (responseDict) in
            if let rates = responseDict.object(forKey: "rates") as? NSDictionary,
                let timeStamp = responseDict.object(forKey: "timestamp") as? Double,
                let base = responseDict.object(forKey: "base") as? String{
                for rate in rates {
                   _ = Rate.saveRate(["value": rate.value, "symbol" : rate.key, "timestamp" : timeStamp, "base" : base])
                }
                success()
            }
        }) {
            failed()
        }
    }
    //MARK: - GET SYMBOL
    func getSymbols(_ success: @escaping () -> Void, _ failed: @escaping () -> Void) {
        
        dataRequest(httpMethod.post , Api.getSymbols,[:], success: { (responseDict) in
            if let responseDict = responseDict.object(forKey: "symbols") as? NSDictionary {
                for rateSymb in responseDict {
                    _ = Symbol.saveSymbol(["name": rateSymb.key, "detail" : rateSymb.value])
                    
                }
                success()
            }
        }) {
            failed()
        }
    }
    
     //MARK: - GET LANGS
    func getLangs(_ success: @escaping () -> Void, _ failed: @escaping () -> Void) {
        let params = ["target":"en"]
        dataRequest(httpMethod.post , Api.getLanguages,params, success: { (responseDict) in
            if let responseDict = responseDict.object(forKey: "data") as? NSDictionary ,
                let languages = responseDict.object(forKey: "languages") as?  [NSDictionary] {
                Lang.removeAll()
                for lang in languages {
                  _ = Lang.saveLang(lang)
                }
                success()
            }
        }) {
            failed()
        }
    }
    func getTranslation(_ text : String, _ from: String, _ to  :String,   _ success: @escaping (String) -> Void, _ failed: @escaping () -> Void) {
        let params = ["target":to, "source" : from, "q" : text,  "format": "text"]
        dataRequest(httpMethod.post , Api.translate,params, success: { (responseDict) in
            if let responseDict = responseDict.object(forKey: "data") as? NSDictionary ,
                let responses = responseDict.object(forKey: "translations") as?  [NSDictionary] ,
                let response = responses.first,let translatedText = response.object(forKey: "translatedText") as? String  {
                success(translatedText)
            }
            else{
                failed()
            }
        }) {
            failed()
        }
    }
    
     //MARK: - WEATHERS
    func getWeather(_ idCity : NSNumber?,_ location: CLLocation?, _ success: @escaping (Weather) -> Void, _ failed: @escaping () -> Void) {
          var url = Api.getWeather
        if let location = location {
            url.append("&lat=\(location.coordinate.latitude)")
             url.append("&lon=\(location.coordinate.longitude)")
        }
        if let idCity = idCity {
              url.append("&id=\(idCity.int64Value)")
        }
    
        dataRequest(httpMethod.post , url,[:], success: { (responseDict) in
                let weather = Weather.saveWeather(responseDict)
                success(weather)
            
        }) {
            failed()
        }
    }
    
}
