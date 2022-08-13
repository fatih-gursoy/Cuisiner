//
//  CustomAlertVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 11.08.2022.
//

import UIKit

protocol CustomAlertVCDelegate: AnyObject {
    func OkTapped()
}

class CustomAlertVC: UIViewController {

    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    var message: String
    var image: UIImage?
    var okCompletion: (() -> Void)?
    weak var delegate: CustomAlertVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    init(message: String, image: UIImage?) {
        self.message = message
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        messageLabel.text = message
        imageView.image = image
    }
    
    @IBAction func OkTapped(_ sender: Any) {
        delegate?.OkTapped()
        dismiss(animated: true, completion: okCompletion)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}
