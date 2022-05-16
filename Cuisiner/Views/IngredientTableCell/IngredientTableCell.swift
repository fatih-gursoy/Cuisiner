//
//  TableViewCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 13.03.2022.
//

import UIKit

class IngredientTableCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemQuantity: UITextField!
    
    static let identifier = "IngredientTableCell"
    
    func configure(ingredient: Ingredient?) {
        
        guard let ingredient = ingredient else {return}
                
        self.backgroundColor = .systemGray5
        
        itemName.text = ingredient.name
        itemQuantity.text = ingredient.amount
        
        itemName.backgroundColor = .systemGray5
        itemQuantity.backgroundColor = .systemGray5
        
        itemName.borderStyle = .none
        itemQuantity.borderStyle = .none
        
        itemName.isUserInteractionEnabled = false
        itemQuantity.isUserInteractionEnabled  = false
        deleteButton.isHidden = true
    }
    
    
}


