//
//  PrepareViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 15.03.2022.
//

import UIKit

class PrepareVC: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var saveButton: UIButton!
    
    private var instructions = [Instruction]()
    private var storage = StorageService.shared
    
    var recipeViewModel: RecipeViewModel?
    weak var delegate: ImagePassDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        updateUI()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: PrepareTableCell.identifier, bundle: nil), forCellReuseIdentifier: PrepareTableCell.identifier)
                
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        configureViewModel()
        
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        let newInstruction = Instruction()
        instructions.append(newInstruction)
        
        tableView.reloadData()
        scrollView.layoutIfNeeded()
        let bottom = scrollView.contentSize.height - scrollView.bounds.height
        scrollView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        presentAlert(title: "Updating Recipe", message: "Are you sure?") { _ in
            self.saveRecipe()
            self.dismiss(animated: true)
        }
        
    }
    
    func saveRecipe() {
        
        configureViewModel()
        
        guard let foodImage = delegate?.foodImageToPass,
              let uid = recipeViewModel?.recipe.id else {return}
                
        let oldUrl = self.recipeViewModel?.recipe.foodImageUrl ?? ""
        
        if foodImage.isSame(with: oldUrl) {
            self.recipeViewModel?.updateRecipe()
        } else {
            storage.imageUpload(to: .foodImages, id: uid , image: foodImage.image!) { imageUrl in
                self.recipeViewModel?.recipe.foodImageUrl = imageUrl
                self.recipeViewModel?.updateRecipe()
            }
        }
        
    }
    
    func updateUI() {
        guard let instructions = recipeViewModel?.instructions else {return}
        self.instructions = instructions
    }
    
    
    func configureViewModel() {
        
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! PrepareTableCell
            
            instructions[i].step = cell.rowLabel.text
            instructions[i].text = cell.textView.text
            
            if let cookTime = cell.timeTextField.text {
                instructions[i].time = Int(cookTime)
            }
        }
        recipeViewModel?.recipe.instructions = instructions
    }
    

}

//MARK: -TableViewDelegates

extension PrepareVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrepareTableCell.identifier, for: indexPath) as? PrepareTableCell else {fatalError("Could not Load")}
        
        cell.configure(instruction: instructions[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return instructions.count
    }
    
    
    
}
