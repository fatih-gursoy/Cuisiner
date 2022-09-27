//
//  InstructionCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 23.09.2022.
//

import UIKit

class InstructionCell: UITableViewCell {

    static let identifier = String(describing: InstructionCell.self)

    @IBOutlet weak var instructionLabel: UILabel!
    
    func configure(instruction: Instruction?) {
        guard let instruction = instruction,
              let text = instruction.text else { return }
                
        instructionLabel.text = "\(self.tag + 1) - \(text)"
    }
    
}
