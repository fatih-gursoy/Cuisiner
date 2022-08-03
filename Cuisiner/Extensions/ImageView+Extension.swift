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
    
    func isSame(with oldUrl: String) -> Bool {
        let urlImage = UIImageView()
        urlImage.setImage(url: oldUrl)
        return self.image == urlImage.image
    }
    
}
