//
//  ViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 11.03.2022.
//

import UIKit

class TabBarVC: UITabBarController, Storyboardable {
    
    weak var coordinator: TabBarCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = true
        tabBar.tintColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        tabBar.backgroundColor = #colorLiteral(red: 1, green: 0.8846692443, blue: 0.8606837988, alpha: 0.7)
        delegate = self
        
        guard let discoverVC = coordinator?.startDiscoverCoordinator() else { return }
        guard let myRecipesVC = coordinator?.startMyRecipesCoordinator() else { return }
        
        // Create TabBar items
        discoverVC.tabBarItem = UITabBarItem(title: "Discover",
                                             image: UIImage(named: "discover"), selectedImage: nil)
        
        myRecipesVC.tabBarItem = UITabBarItem(title: "My Recipes",
                                              image: UIImage(named: "saved"), selectedImage: nil)
        
        // Assign viewControllers to tabBarController
        
        let viewControllers = [discoverVC, UIViewController(), myRecipesVC]
        self.setViewControllers(viewControllers, animated: false)
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        
        tabBar.didTapButton = { [unowned self] in
            self.coordinator?.startCreateNewVC()
        }
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
        middleButton.frame.size = CGSize(width: 50, height: 50)
        let image = UIImage(named: "add")!
        middleButton.setImage(image, for: .normal)
        middleButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
        self.addSubview(middleButton)
        return middleButton
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.layer.shadowRadius = 7
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        middleButton.center = CGPoint(x: frame.width / 2, y: 0.0 )
    }
    
    @objc func middleButtonAction(sender: UIButton) {
        didTapButton?()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        return self.middleButton.frame.contains(point) ? self.middleButton : super.hitTest(point, with: event)
    }
}






