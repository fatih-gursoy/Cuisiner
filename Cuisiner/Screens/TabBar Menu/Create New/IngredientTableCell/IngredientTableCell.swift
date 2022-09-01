//
//  TableViewCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 13.03.2022.
//

import UIKit

protocol IngredientCellDelegate: AnyObject {
    func updateCell(itemName: String?, amount: String?, cell: IngredientTableCell)
    func deleteCell(cell: IngredientTableCell)
}

class IngredientTableCell: UITableViewCell {

    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var itemName: UITextField!
    @IBOutlet private weak var itemQuantity: UITextField!
    
    static let identifier = "IngredientTableCell"
    weak var delegate: IngredientCellDelegate?
    
    func configureForPresent(ingredient: Ingredient?) {
        guard let ingredient = ingredient else {return}
        itemName.text = ingredient.name
        itemQuantity.text = ingredient.amount
        itemName.isUserInteractionEnabled = false
        itemQuantity.isUserInteractionEnabled  = false
        deleteButton.isHidden = true
    }
    
    func configureForEdit(ingredient: Ingredient?) {
        guard let ingredient = ingredient else {return}
        itemName.text = ingredient.name
        itemQuantity.text = ingredient.amount
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteCell(cell: self)
    }
    
    override func layoutSubviews() {
        itemName.delegate = self
        itemQuantity.delegate = self
    }
}

extension IngredientTableCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateCell(itemName: itemName.text, amount: itemQuantity.text,
                             cell: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringLenght = textField.text?.count ?? 0
        if range.length + range.location > stringLenght { return false }
        let maxLenght = stringLenght + string.count - range.length
        return maxLenght <= 10
    }
}


