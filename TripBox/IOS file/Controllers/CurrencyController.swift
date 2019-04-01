//
//  CurrencyController.swift
//  TripBox
//
//  Created by james on 01/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit

class CurrencyController: UIViewController {
    private var currencyFrom : Rate! //default Local
    private var currencyTo : Rate! // default USD
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    @IBOutlet weak var fromBtn: UIButton!
    @IBOutlet weak var toBtn: UIButton!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fromTextField.becomeFirstResponder()
        setNotificationKeyboardChange()
        
        //update rate if last_update Date < 24H
        if Rate.needUpdate() {
            updateRate()
            updateSymbols()
        }else {
            setDefaultCurrency()
            convert()
            updateUI()
        }
    }
    

    // default currency
    private func setDefaultCurrency(){
        setLocalRate()
        setUSDRate()
        
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
    
    //MARK: - Data
    
    
    /** request new Rate
     and add to coreData
     */
    private func updateRate(){
        NetworkManager.sharedInstance.getRates({
            
        }) {
            
        }
    }
    
    /** request Symbols
     and add to coreData
     */
    private func updateSymbols(){
        Symbol.removeAll()
        NetworkManager.sharedInstance.getSymbols({
            if self.currencyFrom  == nil {
                self.setDefaultCurrency()
            }
        }) {
            
        }
    }

     //MARK: - UI
    
    private func updateUI(){
        updateBtnCurrency()
    }
    
    private func updateBtnCurrency(){
        toBtn.setTitle(currencyTo.symbol, for: .normal)
        fromBtn.setTitle(currencyFrom.symbol, for: .normal)
        
    }

    private func convert(){
        let fromVal = fromTextField.text!.textToDouble()
        
        //convert to base (EUR)
        let baseVal = fromVal / currencyFrom.value
        
        //convert from base (EUR) to new Currency
        let finalVal =  baseVal * currencyTo.value
        toTextField.text = self.getFormattedCurrency(value: NSNumber.init(value: finalVal))
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
     func getFormattedCurrency(value: NSNumber) -> String {
       
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale.current // This is the default
        return  formatter.string(from: value)!
    }

}



 // MARK: - UITextFieldDelegate
extension CurrencyController: UITextFieldDelegate {
    private func setNotificationKeyboardChange(){
       fromTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    @objc func textFieldDidChange(textFiedl : UITextField){
        convert()
    }
    
}
