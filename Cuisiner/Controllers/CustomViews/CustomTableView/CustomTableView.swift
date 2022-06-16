//
//  CustomTableView.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 10.06.2022.
//

import Foundation
import UIKit

class CustomTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    
    
}
