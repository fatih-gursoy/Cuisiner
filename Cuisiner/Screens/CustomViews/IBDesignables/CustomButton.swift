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
    
    @IBInspectable var numberOfLines: Int {
        get {
            guard let numberOfLines = self.titleLabel?.numberOfLines else {return 0}
            return numberOfLines
        }
        set {
            self.titleLabel?.numberOfLines = newValue
        }
    }
    
    @IBInspectable var titleAutoSize: Bool {
        get {
            return self.titleLabel?.adjustsFontSizeToFitWidth ?? false
        }
        set {
            self.titleLabel?.adjustsFontSizeToFitWidth = newValue
        }
    }
    
    @IBInspectable var minScaleFactor: CGFloat {
        get {
            return self.titleLabel?.minimumScaleFactor ?? 1
        }
        set {
            self.titleLabel?.minimumScaleFactor = newValue
        }
    }
    
    

}
