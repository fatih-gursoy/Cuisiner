//
//  ProfileVCBuilder.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 27.07.2022.
//

import UIKit

class ProfileVCBuilder {
    
    static func build(viewModel: UserViewModel) -> UIViewController {
        
        let profileVC = UIStoryboard(name: "Main",
                                     bundle: nil).instantiateViewController(identifier: "ProfileVC") { coder in
            return ProfileVC(coder: coder, viewModel: viewModel)
        }
        return profileVC
    }
}
