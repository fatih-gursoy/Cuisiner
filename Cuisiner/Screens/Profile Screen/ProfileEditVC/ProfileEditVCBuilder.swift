//
//  ProfileEditVCBuilder.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 28.07.2022.
//

import UIKit

class ProfileEditVCBuilder {
    
    static func build(viewModel: UserViewModel) -> UIViewController {
        
        let profileVC = UIStoryboard(name: "Main",
                                     bundle: nil).instantiateViewController(identifier: "ProfileEditVC") { coder in
            return ProfileEditVC(coder: coder, viewModel: viewModel)
        }
        return profileVC
    }
}
