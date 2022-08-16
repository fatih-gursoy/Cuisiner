//
//  ActionSheet.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 16.08.2022.
//

import Foundation
import UIKit

protocol ActionSheetDelegate: AnyObject {
    func handler(index: Int, action: UIAlertAction)
}

class CustomActionSheet: UIAlertController {
    
    weak var delegate: ActionSheetDelegate?
    var tag: Int?
    
    override func viewDidLoad() {
        self.title = nil
        self.message = nil
        addAction(reportAction)
        addAction(hideAction)
        addAction(blockAction)
        addAction(cancelAction)
    }
    
    var reportAction: UIAlertAction {
        let reportAction = UIAlertAction(title: actionType.report.title, style: .default) { [weak self] action in
            guard let index = self?.tag else {return}
            self?.delegate?.handler(index: index, action: action)
        }
        return reportAction
    }
    
    var hideAction: UIAlertAction {
        let hideAction = UIAlertAction(title: actionType.hide.title, style: .default) { [weak self] action in
            guard let index = self?.tag else {return}
            self?.delegate?.handler(index: index, action: action)
        }
        return hideAction
    }
    
    var blockAction: UIAlertAction {
        let blockAction = UIAlertAction(title: actionType.block.title, style: .default) { [weak self] action in
            guard let index = self?.tag else {return}
            self?.delegate?.handler(index: index, action: action)
        }
        return blockAction
    }
    
    var cancelAction: UIAlertAction {
        let cancel = UIAlertAction(title: actionType.cancel.title, style: .cancel)
        return cancel
    }
}

enum actionType {
    case report
    case hide
    case block
    case cancel
    
    var title: String {
        switch self {
        case .report: return "Report as inappropriate"
        case .hide: return "Hide this content"
        case .block: return "Block this user"
        case .cancel: return "Cancel"
        }
    }
}

