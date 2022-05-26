//
//  CustomAlert.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 23.05.2022.
//

import Foundation
import UIKit
import Lottie

class AnimationAlert: UIView {
    
    private var animationView = AnimationView()
    
    
    
    
    private func configureAnimation() {
        
        animationView = .init(name: "cooking")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.5
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        
    }

    
}
