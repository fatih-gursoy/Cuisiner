//
//  CustomButton.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 5.08.2022.
//

import Foundation
import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
         get {
             return self.layer.cornerRadius
         } set {
             self.layer.cornerRadius = newValue
         }
    }
}
