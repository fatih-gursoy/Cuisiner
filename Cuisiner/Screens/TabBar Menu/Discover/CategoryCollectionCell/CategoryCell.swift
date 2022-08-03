//
//  CategoryCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 25.04.2022.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    static let identifier = "CategoryCell"
          
    @IBOutlet weak var backView: CustomView!
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
        backView.backgroundColor = .clear
        categoryLabel.textColor = .darkGray
    }
}
