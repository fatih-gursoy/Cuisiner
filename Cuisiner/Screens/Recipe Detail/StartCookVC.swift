//
//  StartCookVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 16.05.2022.
//

import UIKit

class StartCookVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    var recipeViewModel: RecipeViewModel?
    
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
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

extension StartCookVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeViewModel?.recipe.instructions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InstructionCollectionCell.identifier, for: indexPath) as? InstructionCollectionCell else { fatalError("Could not load") }
        
        cell.configure(instruction: recipeViewModel?.instructions?[indexPath.row])
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
}
