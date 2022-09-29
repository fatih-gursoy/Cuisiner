//
//  TableViewCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 13.03.2022.
//

import UIKit

protocol IngredientCellDelegate: AnyObject {
    func updateCell(itemName: String?, cell: IngredientTableCell)
    func deleteCell(cell: IngredientTableCell)
}

class IngredientTableCell: UITableViewCell {

    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var item: UITextField!
    
    static let identifier = "IngredientTableCell"
    weak var delegate: IngredientCellDelegate?
    
    func configure(ingredient: Ingredient?) {
        guard let ingredient = ingredient else {return}
        item.text = ingredient.name
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteCell(cell: self)
    }
    
    override func layoutSubviews() {
        item.delegate = self
    }
}

extension IngredientTableCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.updateCell(itemName: item.text,
                             cell: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringLenght = textField.text?.count ?? 0
        if range.length + range.location > stringLenght { return false }
        let maxLenght = stringLenght + string.count - range.length
        return maxLenght <= 25
    }
}


