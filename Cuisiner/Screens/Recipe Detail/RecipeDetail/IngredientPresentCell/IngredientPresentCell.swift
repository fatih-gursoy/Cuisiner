//
//  IngredientPresentCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 20.09.2022.
//

import UIKit

class IngredientPresentCell: UITableViewCell {

    static let identifier = "IngredientPresentCell"
    
    @IBOutlet private weak var itemName: UILabel!
    
    func configureForPresent(ingredient: Ingredient?) {
        guard let name = ingredient?.name else {return}
        itemName.text =  "●  \(name)"
    }
    
    
}
