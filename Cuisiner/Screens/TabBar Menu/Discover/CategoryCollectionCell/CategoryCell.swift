//
//  CategoryCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 25.04.2022.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    static let identifier = "CategoryCell"
          
    @IBOutlet private weak var backView: CustomView!
    @IBOutlet private weak var categoryLabel: UILabel!
    
    func configureCell(title: String) {
        
        categoryLabel.text = title
        
        if self.isSelected {
            didSelect()
        } else {
            didDeSelect()
        }
    }
    
    func didSelect() {
        backView.backgroundColor = .red
        categoryLabel.textColor = .white
    }
    
    func didDeSelect() {
        backView.backgroundColor = #colorLiteral(red: 1, green: 0.8849676251, blue: 0.8622646928, alpha: 0.6999999881)
        categoryLabel.textColor = .black
    }
    
}
