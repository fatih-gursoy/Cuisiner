//
//  ImageView+Extension.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 26.04.2022.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setImage(url: String?) {
        
        if let url = url {
            self.kf.setImage(with: URL(string: url))
        }
    }
    
}
