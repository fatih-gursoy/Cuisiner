//
//  MyRecipeTableCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 29.03.2022.
//

import UIKit

class MyRecipeTableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifier = "MyRecipeTableCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
