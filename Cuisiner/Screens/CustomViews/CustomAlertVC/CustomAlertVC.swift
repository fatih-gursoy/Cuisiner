//
//  CustomAlertVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 11.08.2022.
//

import UIKit

protocol CustomAlertVCDelegate: AnyObject {
    func OkTapped(action: String?)
}

class CustomAlertVC: UIViewController {

    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    private var action: String?
    private var message: String
    private var image: UIImage?
    var doneCompletion: (() -> Void)?
    
    weak var delegate: CustomAlertVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
        
    init(action: String? = nil, message: String, image: UIImage?) {
        self.action = action
        self.message = message
        self.image = image
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        messageLabel.text = message
        imageView.image = image
    }
    
    @IBAction func OkTapped(_ sender: Any) {
        dismiss(animated: true, completion: doneCompletion)
        delegate?.OkTapped(action: self.action)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
