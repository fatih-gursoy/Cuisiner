//
//  MyRecipeTableCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 29.03.2022.
//

import UIKit

class MyRecipeTableCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var foodImage: UIImageView!
    
    static let identifier = "MyRecipeTableCell"

    func configure(viewModel: RecipeViewModel?) {
        
        guard let viewModel = viewModel else { return }
        
        nameLabel.text = viewModel.recipeName
        foodImage.setImage(url: viewModel.recipe.foodImageUrl)
        
    }

    
}
