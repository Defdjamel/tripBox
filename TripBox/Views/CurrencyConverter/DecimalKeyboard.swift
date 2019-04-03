//
//  DecimalKeyboard.swift
//  TripBox
//
//  Created by james on 01/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit

//MARK: - DecimalKeyboardDelegate
@objc protocol DecimalKeyboardDelegate: AnyObject {
    // protocol definition goes here
    @objc func decimalKeyboardDidChange(text: String)
}

class DecimalKeyboard: UIView {
   @IBOutlet weak var delegate: DecimalKeyboardDelegate?
    var currentText  = ""
    var currentDecimal : Double = 0
    var isPopulated = false
    
   //MARK: - LifeCycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)) , owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        
    }
    override  func awakeFromNib() {
        needsUpdateConstraints()
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if !isPopulated {
            isPopulated  = true
            populatedButtons()
        }
    }
    //MARK: - UI
    private func populatedButtons(){
        let maxHeightbtn : CGFloat = 110.0
        let numberBtnHeight : CGFloat = 4
        let numberBtnWith : CGFloat = 3
        
        let btnText = ["1","2","3","4","5","6","7","8","9",".","0","<"]
       
        let widthView = self.frame.size.width
        let heightView = self.frame.size.height - 8
        
        let heightBtn = min( heightView / numberBtnHeight , maxHeightbtn)
        let widthBtn = heightBtn //btnSquare
        let marginLeft  = (widthView - ( widthBtn * numberBtnWith )) / 2
        let marginTop : CGFloat =  (heightView - (heightBtn * numberBtnHeight)) / 2
        
        //addButton
        var x = marginLeft
        var y = marginTop
        
        for i in 0..<btnText.count {
            let btnView = DecimalButton.instanceFromNib() as! DecimalButton
            btnView.frame =  CGRect.init(x: x, y: y, width: widthBtn, height: heightBtn)
            btnView.button.addTarget(self, action: #selector(clickBtn) , for: .touchUpInside)
            btnView.setText(btnText[i])
            self.addSubview(btnView)
             x += widthBtn
            if (i + 1) % 3  == 0{
                y += heightBtn
                x = marginLeft
            }
            
        }
    }
    //MARK: - Action 
    @objc func clickBtn(_ sender: UIButton){
      let title = sender.currentTitle!
        if title == "<" {
            currentText =  String(self.currentText.dropLast())
        }
        else if title == "." {
            if !currentText.contains("."){
               self.currentText.append(title)
            }
        }
        else {
            self.currentText.append(title)
        }
        self.delegate?.decimalKeyboardDidChange(text: currentText)
    }
}
