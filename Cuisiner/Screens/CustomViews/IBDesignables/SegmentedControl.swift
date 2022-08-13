//
//  SegmentedControl.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 28.06.2022.
//

import Foundation
import UIKit

@IBDesignable
class CustomSegmented: UISegmentedControl {
    
    @IBInspectable var selectedTextColor: UIColor {
         get {
             return self.selectedTextColor
         } set {
             let color = [NSAttributedString.Key.foregroundColor: newValue]
             self.setTitleTextAttributes(color, for: .selected)
         }
    }
}
