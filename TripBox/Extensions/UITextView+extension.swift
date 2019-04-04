//
//  UITextView+extension.swift
//  TripBox
//
//  Created by james on 04/04/2019.
//  Copyright © 2019 intergoldex. All rights reserved.
//

import UIKit

extension UITextView {
     func getAutoSizeTextView() -> CGSize{
        let newSize = self.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        return newSize
    }
}
