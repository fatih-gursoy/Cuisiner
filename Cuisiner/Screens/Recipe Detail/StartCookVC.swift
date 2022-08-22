//
//  StartCookVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 16.05.2022.
//

import UIKit

class StartCookVC: UIViewController, Storyboardable {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var nextButton: UIButton!
    
    var recipeViewModel: RecipeViewModel?
    weak var coordinator: RecipeDetailCoordinator?
    
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
//MARK: - Functions

    func configureUI() {
        
        guard let instructions = recipeViewModel?.instructions else { return }
        self.title = instructions.count > 0
        ? recipeViewModel?.recipeName
        : "There is no instruction"
        
        pageControl.numberOfPages = instructions.count
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: InstructionCollectionCell.identifier, bundle: nil), forCellWithReuseIdentifier: InstructionCollectionCell.identifier)
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        guard let instructions = recipeViewModel?.instructions else { return }
        
        if currentPage < instructions.count - 1    {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
        } else if currentPage == instructions.count - 1 {
            doneAlert()
        }
    }
    
    func doneAlert() {
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
        
        cell.configure(instruction: recipeViewModel?.instructions[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.frame.width
        let itemHeight = collectionView.frame.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for index in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? InstructionCollectionCell else {return}
            cell.timerReset()
        }
    }
    
}
