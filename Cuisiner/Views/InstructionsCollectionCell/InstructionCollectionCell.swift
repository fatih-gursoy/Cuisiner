//
//  InstructionCollectionCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 17.05.2022.
//

import UIKit
import Lottie

class InstructionCollectionCell: UICollectionViewCell {

    static let identifier = String(describing: InstructionCollectionCell.self)

    @IBOutlet weak var bottomView: UIView!
    
    var animationView: AnimationView?
    
    @IBOutlet weak var instructionText: UITextView!
    
    func configure(instruction: Instruction?) {

        animationView = .init(name: "cooking")
        animationView?.loopMode = .loop
        animationView?.contentMode = .scaleAspectFit
        animationView?.animationSpeed = 0.5
        bottomView.addSubview(animationView!)
        animationView?.play()
        
        guard let instruction = instruction else { return }
        instructionText.text = instruction.text
        
    }
    
    
}
