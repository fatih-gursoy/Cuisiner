//
//  StartCookVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 16.05.2022.
//

import UIKit
import SwiftUI

class StartCookVC: UIViewController, Storyboardable {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var finishButton: UIButton!
    @IBOutlet private weak var headerLabel: UILabel!
    
    var recipeViewModel: RecipeViewModel?
    weak var coordinator: RecipeDetailCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
//MARK: - Functions

    func configureNavBar() {
                
        let clockButton = UIBarButtonItem(image: UIImage(named: "clock"), style: .plain,
                                          target: self, action: #selector(showTimerView))
        
        self.navigationItem.rightBarButtonItem = clockButton
    }
    
    @objc func showTimerView() {
        guard let recipeViewModel,
                let cookTime = Int(recipeViewModel.cookTime) else { return }
        
        let timeVM = TimeViewModel(initialTimeMin: cookTime)
        let timerView = UIHostingController(rootView: TimerMainView(viewModel: timeVM))
        present(timerView, animated: true)
    }
    
    func configureUI() {
        guard let instructions = recipeViewModel?.instructions else { return }
        self.title = instructions.count > 0
        ? recipeViewModel?.recipeName
        : "There is no instruction"
        headerLabel.text = " Preperation Steps 🥣 "
    }
    
    func configureTableView() {
        
        tableView.register(UINib(nibName: String(describing: InstructionCell.self), bundle: nil), forCellReuseIdentifier: InstructionCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    @IBAction func finishButtonClicked(_ sender: Any) {
        let alertVC = CustomPopupVC(type: .cookDone)
        alertVC.modalPresentationStyle = .overCurrentContext
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.doneTappedCompletion = { [weak self] in self?.dismiss(animated: true) }
        present(alertVC, animated: true)
    }

}

//MARK: - TableView Delegates

extension StartCookVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipeViewModel = recipeViewModel else {return 0}
        return recipeViewModel.instructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InstructionCell.identifier, for: indexPath) as? InstructionCell else { fatalError("Could not load") }
        
        cell.tag = indexPath.row
        cell.configure(instruction: recipeViewModel?.instructions[indexPath.row])
        return cell
    }
    
}
