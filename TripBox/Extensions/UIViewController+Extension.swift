//
//  ViewController+Extension.swift
//  TripBox
//
//  Created by james on 03/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit

extension  UIViewController {
    func showErrorMessage(_ text: String, completionValid: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: completionValid)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
