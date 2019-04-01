//
//  DecimalButton.swift
//  TripBox
//
//  Created by james on 01/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit

class DecimalButton: UIView {

    @IBOutlet weak var button: UIButton!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        layoutIfNeeded()
        self.button.cornerRadius = self.button.frame.width / 2
        self.button.layer.shadowColor = UIColor.blue.cgColor
        self.button.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.button.layer.shadowRadius = 4
        self.button.layer.shadowOpacity = 0.1
        self.button.layer.masksToBounds = false
    }
    
    func setText(_ text : String){
        button.setTitle(text, for: .normal)
    }
}
