//
//  RecipeCollectionCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 25.04.2022.
//

import UIKit

protocol CellActionButtonDelegate: AnyObject {
    func actionButtonTapped(cell: UICollectionViewCell)
}

class RecipeCell: UICollectionViewCell {

    static let identifier = String(describing: RecipeCell.self)
    
    @IBOutlet private weak var foodImage: CustomImageView!
    @IBOutlet private weak var recipeName: UILabel!
    @IBOutlet private weak var starButton: UIButton!
    @IBOutlet private weak var actionButton: UIButton!

    weak var delegate: CellActionButtonDelegate?
    
    func configure(viewModel: RecipeViewModel?) {
        
        guard let viewModel = viewModel else { return }
        actionButton.isHidden = viewModel.ownerID == AuthManager.shared.userId ? true : false        
        recipeName.text = viewModel.recipe.name
        foodImage.setImage(url: viewModel.recipe.foodImageUrl)
        
        starButton.setTitle(viewModel.averageScore, for: .normal)
        starButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        starButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        delegate?.actionButtonTapped(cell: self)
    }
}


