//
//  TripBoxTests.swift
//  TripBoxTests
//
//  Created by james on 31/03/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import XCTest
@testable import TripBox

class TripBoxTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: - Weather
    func testSearchCityIDInDatabase(){//check if database can find city by name
        let citiesFound = City.searchCityByKeyword("New York")
        let isFound = citiesFound.count > 0 ? true : false
        XCTAssertEqual(isFound, true , "searchCityIDInDatabase is wrong")
    }

    func testUpdateWeather(){
        let promise = expectation(description: "Status code: 200")
        //get 1st item in database
        guard let weather = TripBox.Weather.all.first else {
            return
        }
        //Request details information
        NetworkManager.sharedInstance.getWeather(weather.id_city, nil, { (weather) in
            promise.fulfill()
        }) {
            XCTFail("Status code: fail request getWeather")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    //MARK: - Translator
    func testGetLangs(){
        let promise = expectation(description: "Status code: 200")
        
        //Request details information
        NetworkManager.sharedInstance.getLangs({
            promise.fulfill()
        }) {
            XCTFail("Status code: fail request testGetLangs")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTranslateText(){
         let promise = expectation(description: "Status code: 200")
        //get Lang from and to in DataBase
        guard let langFrom = Lang.getLangWithSymbol("en"), let langNameFrom = langFrom.language  else{
             XCTFail("Status code: fail request testTranslateText")
        return
        }
       guard  let langTo = Lang.getLangWithSymbol("fr"),  let langNameTo = langTo.language  else {
             XCTFail("Status code: fail request testTranslateText")
        return
        }
        
         //Request details information
        NetworkManager.sharedInstance.getTranslation("Hello",langNameFrom, langNameTo, { (textTranslated) in
           print(textTranslated)
            if textTranslated == "Bonjour" {
                 promise.fulfill()
            }
        }) {
            XCTFail("Status code: fail request testTranslateText")
        }
         waitForExpectations(timeout: 5, handler: nil)
    }
    
     //MARK: - Currency Exchange
    func testGetSymbols(){
        let promise = expectation(description: "Status code: 200")
        
        NetworkManager.sharedInstance.getSymbols({
            promise.fulfill()
        }) {
            XCTFail("Status code: fail request testGetSymbols")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testGetLastRate(){
        let promise = expectation(description: "Status code: 200")
        
        NetworkManager.sharedInstance.getRates({
            promise.fulfill()
        }) {
             XCTFail("Status code: fail request testGetLastRate")
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    
    func testExchange(){
        guard let rateFrom = Rate.getRateWithSymbol("USD") else {
             XCTFail("Status code: fail request testExchange")
            return
        }
        guard let rateTo = Rate.getRateWithSymbol("EUR") else {
             XCTFail("Status code: fail request testExchange")
            return
        }
        
        let result =  Rate.convert(fromVal: 1.0, fromRate: rateFrom, toRate: rateTo)
        //result will be around 0.8 euro for 1 USD
        let isFound = ( result > 0.5 && result < 1.0 ) ? true : false
       XCTAssertEqual(isFound, true , "testExchange is wrong")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    

}
