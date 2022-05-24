//
//  CustomAlertVCViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 23.05.2022.
//

import UIKit
import Lottie

class CustomAlertVC: UIViewController {

    @IBOutlet private weak var animationParentView: UIView!
    @IBOutlet private weak var actionButton: UIButton!
    
    private var animationView: AnimationView?
    var doneTappedCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAnimation()
        
    }

    
    func configureAnimation() {
        
        animationView = .init(name: "done")
        guard let animationView = animationView else {return}

        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.5
        animationView.frame = animationParentView.bounds
        animationParentView.addSubview(animationView)
        animationView.play()
        
    }
    
     
    @IBAction func actionButtonClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: doneTappedCompletion)
        
    }
    

}
