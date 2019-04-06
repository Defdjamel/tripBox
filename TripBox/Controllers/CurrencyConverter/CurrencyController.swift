//
//  CurrencyController.swift
//  TripBox
//
//  Created by james on 01/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
import SVProgressHUD
class CurrencyController: UIViewController {
    private var currencyFrom : Rate?//default Local
    private var currencyTo : Rate? // default USD
    private  var currencyInChangeIsFrom = false //flag indicated currency will be change
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    @IBOutlet weak var fromBtn: UIButton!
    @IBOutlet weak var toBtn: UIButton!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //update rate if last_update Date < 24H
        if Rate.needUpdate() {
            updateRate()
            updateSymbols()
        }
         self.setDefaultCurrency()
    }
    
    // default currency
    private func setDefaultCurrency(){
        setLocalRate()
        setUSDRate()
        updateUI()
        
    }
    private func setLocalRate(){
        let locale = Locale.current
        if let currencyCode = locale.currencyCode,
           let rate = Rate.getRateWithSymbol(currencyCode) {
            self.currencyFrom = rate
        }
       
    }
    private func setUSDRate(){
        if let rate = Rate.getRateWithSymbol("USD") {
            self.currencyTo = rate
        }
    }
    //MARK: - Action
    @IBAction func onClickFromBtn(_ sender: Any) {
        currencyInChangeIsFrom = true
        self.performSegue(withIdentifier: "currency_selector", sender: self)
    }
    
    @IBAction func onClickToBtn(_ sender: Any) {
        currencyInChangeIsFrom = false
         self.performSegue(withIdentifier: "currency_selector", sender: self)
    }
    
    //MARK: - UI
    
    private func updateUI(){
        updateBtnCurrency()
        updateLastUpdateLabel()
    }
    
    private func updateBtnCurrency(){
        guard let currencyTo = currencyTo, let currencyFrom = currencyFrom else{
            return
        }
        toBtn.setTitle(currencyTo.symbol, for: .normal)
        fromBtn.setTitle(currencyFrom.symbol, for: .normal)
    }
    private func updateLastUpdateLabel(){
        if let currencyTo = currencyTo, let currencyDate = currencyTo.date  {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .medium
            lastUpdateLabel.text = "Last updated at : " + df.string(from: currencyDate)
        }
    }
    
    //MARK: - Data
   
    /** request new Rate
     and add to coreData
     */
    private func updateRate (){
        SVProgressHUD.show()
        NetworkManager.sharedInstance.getRates({
            SVProgressHUD.dismiss()
            if self.currencyFrom  == nil {
                self.setDefaultCurrency()
            }
        }) {
          self.showErrorMessage("Error during requesting rate.", completionValid: nil)
        }
    }
    
    /** request Symbols
     and add to coreData
     */
    private func updateSymbols(){
        NetworkManager.sharedInstance.getSymbols({
            if self.currencyFrom  == nil {
                self.setDefaultCurrency()
            }
        }) {
            self.showErrorMessage("Error during request.", completionValid: nil)
        }
    }
    //MARK: - Converter
    private func convert(fromVal: Double, fromRate: Rate,toRate: Rate) -> Double{
        //convert to base (EUR)
        let baseVal = fromVal / fromRate.value
        
        //convert from base (EUR) to new Currency
        let finalVal =  baseVal * toRate.value
        return finalVal
    }
    
    private func updateConvert(_ fromValText : String){
        guard let currencyTo = currencyTo , let currencyFrom = currencyFrom else{
            return 
        }
        let fromVal =  fromValText.textToDouble()
        let newVal = convert(fromVal: fromVal, fromRate: currencyFrom, toRate: currencyTo)
        self.toTextField.text = NSNumber(value: newVal).getFormattedCurrency()
    }
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? CurrencySelectorViewController {
            vc.delegate = self
        }
    }
}

// MARK: - DecimalKeyboardDelegate
extension CurrencyController : DecimalKeyboardDelegate {
    func decimalKeyboardDidChange(text: String) {
        //updateUI
        self.fromTextField.text = text
       updateConvert(text)
    }
}

// MARK: - currencySelectorDelegate
extension CurrencyController : currencySelectorDelegate {
    func currencySelectorDelegate_didSelect(rate: Rate) {
        if currencyInChangeIsFrom {
             currencyFrom = rate
        }else{
            currencyTo = rate
        }
        updateUI()
        updateConvert(self.fromTextField.text!)
    }
}
