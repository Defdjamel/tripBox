//
//  TranslatorTableViewController.swift
//  TripBox
//
//  Created by james on 07/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit
import SVProgressHUD
class TranslatorTableViewController: UITableViewController {
    var langFrom : Lang?
    var langTo : Lang?
    @IBOutlet weak var btnLangFrom: UIButton!
    @IBOutlet weak var btnLangTo: UIButton!

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outPutTextView: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Lang.all.count == 0 {
            updateLangs()
        }else{
            setDefaultLangConvert()
        }
    }
    // MARK: - Data
    /** request to convert text
     */
    private func convertText(){
        guard let langFrom = langFrom?.language , let langTo =  langTo?.language , let text = inputTextView.text else{
            return
        }
        SVProgressHUD.show()
        NetworkManager.sharedInstance.getTranslation(text, langFrom, langTo, { (responseText) in
            self.outPutTextView.text = responseText
            SVProgressHUD.dismiss()
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }) {
            SVProgressHUD.dismiss()
            self.showErrorMessage("Error during requesting translation!", completionValid: nil)
        }
    }
    /** update langs available from API
     */
    private func updateLangs(){
        NetworkManager.sharedInstance.getLangs({
            self.setDefaultLangConvert()
        }) {
            self.showErrorMessage("Error during requesting languages.", completionValid: nil)
        }
    }
    
    /**
     set to init lang convert local to english
     */
    private func setDefaultLangConvert(){
        let from = Device.getDeviceLangcode()
        let to = "en"
        if let lang = Lang.getLangWithSymbol(from) {
            langFrom = lang
        }
        if let lang = Lang.getLangWithSymbol(to) {
            langTo = lang
        }
        updateBtnLang()
    }
    

    // MARK: - Action
    @IBAction func onClickBtnSwap(_ sender: Any) {
        //swap Lang object
        swap(&langFrom, &langTo)
        //swap textvalut
        swap(&inputTextView.text, &outPutTextView.text)
        updateBtnLang()
        convertText()
    }
    @IBAction func onClickBtnLangFrom(_ sender: Any) {
        //TODO BONUS SELECT LANG
    }
    @IBAction func onClickBtnLangTo(_ sender: Any) {
        //TODO BONUS SELECT LANG
    }
    
    
    // MARK: - UI
    private func updateBtnLang(){
        guard let langFrom = langFrom , let langTo =  langTo else{
            return
        }
        btnLangTo.setTitle(langTo.language, for: .normal)
        btnLangFrom.setTitle(langFrom.language, for: .normal)
    }

}

// MARK: - TableViewDataSource
extension TranslatorTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return min(inputTextView.contentSize.height + 16,240)
        case 1:
            return 60
        case 2:
            return min(outPutTextView.contentSize.height + 16, 240)
        default:
            return 0
        }
        
    }
}
// MARK: - UITextViewDelegate
extension TranslatorTableViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView){
        placeHolderLabel.isHidden = !textView.text.isEmpty
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        //        Avoid return line
        if( text == "\n" )
        {
            textView.resignFirstResponder()
            convertText()
            return false;
        }
        return true
    }
}
