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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}


