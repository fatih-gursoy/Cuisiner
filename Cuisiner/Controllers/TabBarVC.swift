//
//  ViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 11.03.2022.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = true
        tabBar.tintColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
                
        delegate = self
        
        let DiscoverVC = self.storyboard?.instantiateViewController(withIdentifier: "DiscoverNav") as! UINavigationController
        
        let MyRecipesVC = self.storyboard?.instantiateViewController(withIdentifier: "MyRecipesNav") as! UINavigationController
        
        let CreateNewVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewNav") as! UINavigationController
        
        
        // Create TabBar items
        DiscoverVC.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(named: "discover"), selectedImage: nil)
        
        MyRecipesVC.tabBarItem = UITabBarItem(title: "My Recipes", image: UIImage(named: "saved"), selectedImage: nil)
        
        CreateNewVC.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        
        // Assign viewControllers to tabBarController
        
        let viewControllers = [DiscoverVC, CreateNewVC, MyRecipesVC]
        self.setViewControllers(viewControllers, animated: false)
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        
        tabBar.didTapButton = { [unowned self] in
            self.routeToCreateNew()
        }
    }
    
    func routeToCreateNew() {
        guard let createNewVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewNav") else {return}
        
        createNewVC.modalPresentationCapturesStatusBarAppearance = true
        createNewVC.modalPresentationStyle = .fullScreen
        self.present(createNewVC, animated: true)
    }
}

    // MARK: - UITabBarController Delegate

    extension TabBarVC: UITabBarControllerDelegate {
        func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
                return true
            }
            
            if selectedIndex == 1 {
                return false
            }
            
            return true
        }

}

class CustomTabBar: UITabBar {
    
    public var didTapButton: (() -> ())?
    
    public lazy var middleButton: UIButton! = {
        
        let middleButton = UIButton()
        middleButton.frame.size = CGSize(width: 75, height: 75)
        let image = UIImage(named: "add")!
        middleButton.setImage(image, for: .normal)
        
        middleButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
        
        self.addSubview(middleButton)
        
        return middleButton
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        middleButton.center = CGPoint(x: frame.width / 2, y: -10)
    }
    
    @objc func middleButtonAction(sender: UIButton) {
        didTapButton?()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        return self.middleButton.frame.contains(point) ? self.middleButton : super.hitTest(point, with: event)
    }
}




    

