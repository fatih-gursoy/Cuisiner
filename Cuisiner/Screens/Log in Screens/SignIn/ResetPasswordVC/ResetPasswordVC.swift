//
//  CustomAlertVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 9.08.2022.
//

import UIKit

protocol ResetPasswordVCDelegate: AnyObject {
    func OkAction(completion: @escaping (Bool) -> Void)
}

class ResetPasswordVC: UIViewController {

    @IBOutlet private weak var messageText: UILabel!
    private var message: String
    weak var delegate: ResetPasswordVCDelegate?
    weak var coordinator: SignInCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        messageText.text = message
    }
    
    init(message: String) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func OkButtonTapped(_ sender: Any) {
        delegate?.OkAction(completion: { [weak self] success in
            if success {
                self?.messageText.text = "📮 Email was sent to your mail, please check your inbox"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        })
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
