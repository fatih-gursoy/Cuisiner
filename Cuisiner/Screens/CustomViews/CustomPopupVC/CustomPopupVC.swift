//
//  CustomAlertVCViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 23.05.2022.
//

import UIKit
import Lottie

class CustomPopupVC: UIViewController {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var actionButton: UIButton!
    
    var animationView: AnimationView?
    var starView: StarView?
    var type: popUpType?
    var doneTappedCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubView()
    }
    
    init(type: popUpType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubView() {
        switch type {
        case .cookDone:
            configureAnimation()
        case .star(let score):
            configureStarView(score)
        case .none:
            return 
        }
    }
    
    func configureAnimation() {
        animationView = .init(name: "done")
        guard let animationView = animationView else {return}
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.5
        animationView.frame = subView.bounds
        subView.addSubview(animationView)
        animationView.play()
    }
    
    func configureStarView(_ score: Int) {
        starView = .init(frame: subView.frame)
        guard let starView = starView else {return}
        starView.score = score
        subView.addSubview(starView)
        starView.centerXAnchor.constraint(equalTo: subView.centerXAnchor).isActive = true
        starView.centerYAnchor.constraint(equalTo: subView.centerYAnchor).isActive = true
    }
     
    @IBAction func actionButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: doneTappedCompletion)
    }
    
    enum popUpType {
        case cookDone
        case star(score: Int)
    }
}
