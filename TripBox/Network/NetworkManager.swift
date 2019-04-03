//
//  NetworkManager.swift
//  wzp_challenge
//
//  Created by james on 14/03/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
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
        
        //add parameters
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
    
   private  func dataRequest(_ method: httpMethod,_ url: String, success: @escaping (NSDictionary) -> Void, failed: @escaping () -> Void){
        //Create Request
        let request = createRequest(method, url, [:])
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
       
        dataRequest(httpMethod.post , Api.getLatestRate, success: { (responseDict) in
            if let rates = responseDict.object(forKey: "rates") as? NSDictionary,
                let timeStamp = responseDict.object(forKey: "timestamp") as? Double,
                let base = responseDict.object(forKey: "base") as? String{
                for rate in rates {
                    print(rate)
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
        
        dataRequest(httpMethod.post , Api.getSymbols, success: { (responseDict) in
            if let responseDict = responseDict.object(forKey: "symbols") as? NSDictionary {
                for rateSymb in responseDict {
                    print(rateSymb)
                    _ = Symbol.saveSymbol(["name": rateSymb.key, "detail" : rateSymb.value])
                    
                }
                success()
            }
        }) {
            failed()
        }
    }
}
