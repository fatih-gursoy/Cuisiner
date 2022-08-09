//
//  StarView.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 27.05.2022.
//

import UIKit

class StarView: UIStackView {
    
    private var buttons = [UIButton]()
    
    var score = Int() {
        didSet {
            updateButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alignment = .center
        self.axis = .horizontal
        self.distribution = .equalSpacing
        configureButtons()
        updateButton()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButtons() {
        for _ in 0..<5 {
            let button = UIButton()
            let image = UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate)
            button.setImage(image, for: .normal)
            button.tintColor = .green
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant:60.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
            button.addTarget(self, action: #selector(didTapped), for: .touchUpInside)
            
            addArrangedSubview(button)
            buttons.append(button)
        }
    }
    
    @objc func didTapped(sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else {
            fatalError("There is no Button")}
        
        let selectedScore = index + 1
        selectedScore == score ? (score = 0) : (score = selectedScore)
    }
    
    func updateButton() {
        for (index, button) in buttons.enumerated() {
            let imageName = index < score ? "star.fill" : "star"
            button.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
}
