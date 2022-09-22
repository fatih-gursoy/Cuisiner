//
//  InstructionCollectionCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 17.05.2022.
//

import UIKit

class InstructionCollectionCell: UICollectionViewCell {

    static let identifier = String(describing: InstructionCollectionCell.self)
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    func configure(instruction: Instruction?) {
        guard let instruction = instruction,
              let text = instruction.text else { return }
                
        instructionLabel.text = "\(self.tag + 1) - \(text))"
    }
    

}

