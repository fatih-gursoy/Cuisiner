//
//  RecipeCollectionCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 25.04.2022.
//

import UIKit

class RecipeCell: UICollectionViewCell {

    static let identifier = String(describing: RecipeCell.self)
    
    @IBOutlet weak var foodImage: CustomImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    func configure(viewModel: RecipeViewModel?) {
        
        guard let viewModel = viewModel else { return }

        recipeName.text = viewModel.recipe.name
        foodImage.setImage(url: viewModel.recipe.foodImageUrl)
        
        starButton.setTitle(viewModel.star, for: .normal)
        starButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        starButton.layer.cornerRadius = 10.0
        
    }
    
    
}
