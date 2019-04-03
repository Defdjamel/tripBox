//
//  CurrencySelectorViewController.swift
//  TripBox
//
//  Created by james on 02/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
//MARK: - DecimalKeyboardDelegate
@objc protocol currencySelectorDelegate: AnyObject {
    // protocol definition goes here
    @objc func currencySelectorDelegate_didSelect(rate : Rate)
    
}


class CurrencySelectorViewController: UIViewController {
    var symbols : [Symbol] = []
     var symbolsUsed : [Symbol] = []
    weak var delegate: currencySelectorDelegate?
    
    @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateSymbols()
    }
    
 // MARK: - Data
    private func updateSymbols(){
        symbols = Symbol.all
        symbolsUsed  = Symbol.lastSelected
        tableView.reloadData()
    }
    
     // MARK: - Action
    @IBAction func onClickBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: - UITableViewDelegate
extension CurrencySelectorViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var symbolSelected : Symbol!
        switch indexPath.section {
        case 0:
            symbolSelected = symbolsUsed[indexPath.row]
        case 1:
            symbolSelected = symbols[indexPath.row]
        default:
            symbolSelected = symbols[indexPath.row]
        }
        
       
        symbolSelected.setSelected()
        if let rate = Rate.getRateWithSymbol(symbolSelected.name!) {
            self.delegate?.currencySelectorDelegate_didSelect(rate: rate)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
// MARK: - UITableViewDataSource
extension CurrencySelectorViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
       return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return symbolsUsed.count
        case 1:
           return  symbols.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier",
                                                 for: indexPath)
       
        var symbol : Symbol!
        switch indexPath.section {
        case 0:
            symbol = symbolsUsed[indexPath.row]
        case 1:
            symbol = symbols[indexPath.row]
        default:
            symbol = symbols[indexPath.row]
        }
       
        cell.textLabel?.text = symbol.name
        cell.detailTextLabel?.text = symbol.detail
       
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return  symbolsUsed.count > 0 ?  "Last selected : " : nil
        default:
            return "All"
        }
    }
   
}
