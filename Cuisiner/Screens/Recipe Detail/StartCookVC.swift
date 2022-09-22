//
//  StartCookVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 16.05.2022.
//

import UIKit

class StartCookVC: UIViewController, Storyboardable {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var headerLabel: UILabel!
    
    var recipeViewModel: RecipeViewModel?
    weak var coordinator: RecipeDetailCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
//MARK: - Functions

    func configureUI() {
        
        guard let instructions = recipeViewModel?.instructions else { return }
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = instructions.count > 0
        ? recipeViewModel?.recipeName
        : "There is no instruction"
        headerLabel.text = " Preperation Steps 🥣 "
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: InstructionCollectionCell.identifier, bundle: nil), forCellWithReuseIdentifier: InstructionCollectionCell.identifier)
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        let alertVC = CustomPopupVC(type: .cookDone)
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.doneTappedCompletion = { [weak self] in self?.dismiss(animated: true) }
        present(alertVC, animated: true)
    }

    
}
//MARK: - CollectionView Delegates

extension StartCookVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let recipeViewModel = recipeViewModel else {return 0}
        return recipeViewModel.instructions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstructionCollectionCell.identifier, for: indexPath) as? InstructionCollectionCell else { fatalError("Could not load") }
        
        cell.tag = indexPath.row
        cell.configure(instruction: recipeViewModel?.instructions[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.frame.width
        let itemHeight = collectionView.frame.height * 0.2
        return CGSize(width: itemWidth, height: itemHeight)
    }    
    
}
