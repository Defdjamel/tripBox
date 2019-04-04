//
//  TranslatorViewController.swift
//  TripBox
//
//  Created by james on 03/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit

class TranslatorViewController: UIViewController {
    var langFrom : Lang?
    var langTo : Lang?

    @IBOutlet weak var btnLangFrom: UIButton!
    @IBOutlet weak var btnLangTo: UIButton!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var InputTextHeight: NSLayoutConstraint!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputLabel: UILabel!
    
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
        ANLoader.showLoading()
        NetworkManager.sharedInstance.getTranslation(text, langFrom, langTo, { (responseText) in
            self.outputLabel.text = responseText
            ANLoader.hide()
        }) {
            ANLoader.hide()
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
    
   
   // MARK: - UI
    private func updateBtnLang(){
        guard let langFrom = langFrom , let langTo =  langTo else{
            return
        }
        btnLangTo.setTitle(langTo.language, for: .normal)
        btnLangFrom.setTitle(langFrom.language, for: .normal)
    }
    
    // MARK: - Action
    @IBAction func onClickBtnSwap(_ sender: Any) {
        //swap Lang object
        swap(&langFrom, &langTo)
        //swap textvalut
        swap(&inputTextView.text, &outputLabel.text)
        
        updateBtnLang()
        
        
    }
    @IBAction func onClickBtnLangFrom(_ sender: Any) {
    }
    @IBAction func onClickBtnLangTo(_ sender: Any) {
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
// MARK: - UITextViewDelegate
extension TranslatorViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView){
//        Update size TextView
       InputTextHeight.constant = min( textView.getAutoSizeTextView().height, 220)
        
//        Show/hide placeHolder
        placeHolderLabel.isHidden = !textView.text.isEmpty
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
