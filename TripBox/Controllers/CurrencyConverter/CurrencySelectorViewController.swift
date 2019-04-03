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
        let symbolSelected = symbols[indexPath.row]
        if let rate = Rate.getRateWithSymbol(symbolSelected.name!) {
            self.delegate?.currencySelectorDelegate_didSelect(rate: rate)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
// MARK: - UITableViewDataSource
extension CurrencySelectorViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  symbols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier",
                                                 for: indexPath)
        let symbol = symbols[indexPath.row]
        cell.textLabel?.text = symbol.name
        cell.detailTextLabel?.text = symbol.detail
       
        return cell
    }
   
}
