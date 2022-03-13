//
//  TableViewCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 13.03.2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
