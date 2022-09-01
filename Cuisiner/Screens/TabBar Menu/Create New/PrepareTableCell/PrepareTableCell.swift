//
//  PrepareTableViewCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 15.03.2022.
//

import UIKit

protocol PrepareCellDelegate: AnyObject {
    func updateCell(textView: String?, timeText: String?, cell: PrepareTableCell)
}

class PrepareTableCell: UITableViewCell {

    static let identifier = "PrepareTableCell"
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var rowLabel: UILabel!
    @IBOutlet private weak var timeTextField: UITextField!
    
    weak var delegate: PrepareCellDelegate?
    
    override func layoutSubviews() {
        textView.delegate = self
        timeTextField.delegate = self        
        rowLabel.layer.cornerRadius = rowLabel.frame.width / 2
        rowLabel.clipsToBounds = true
        textView.layer.cornerRadius = 20.0
        textView.layer.borderWidth = 2.0
        textView.layer.borderColor = UIColor(named:"Dark Red")?.cgColor
        textView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    override func prepareForReuse() {
        textView.text = nil
        timeTextField.text = nil
    }
    
    func configure(instruction: Instruction?) {
        guard let instruction = instruction else {return}
        rowLabel.text = "\(self.tag + 1)"
        textView.text = instruction.text
        if let time = instruction.time {timeTextField.text = String(describing: time)}
    }
}

extension PrepareTableCell: UITextViewDelegate, UITextFieldDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.updateCell(textView: textView.text,
                                  timeText: self.timeTextField.text, cell: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.updateCell(textView: textView.text,
                                  timeText: textField.text, cell: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringLenght = textField.text?.count ?? 0
        if range.length + range.location > stringLenght { return false }
        let maxLenght = stringLenght + string.count - range.length
        return maxLenght <= 3
    }
}


