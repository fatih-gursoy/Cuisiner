//
//  PrepareViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 15.03.2022.
//

import UIKit

class PrepareVC: UIViewController, Storyboardable {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var saveButton: UIButton!
    private var storage = StorageService.shared
    
    var recipeViewModel: RecipeViewModel?
    weak var delegate: ImagePassDelegate?
    weak var coordinator: CreateNewCoordinator?
    
    private var instructions = [Instruction]() {
        didSet {
            tableView.reloadData()
            recipeViewModel?.recipe.instructions = instructions
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        updateUI()
        configureTableView()
    }
    
//MARK: - Functions
    
    func updateUI() {
        guard let instructions = recipeViewModel?.instructions else {return}
        self.instructions = instructions
    }
    
    func saveRecipe() {
        
        guard let foodImage = delegate?.foodImageToPass,
              let uid = recipeViewModel?.recipe.id else {return}
                
        let oldUrl = self.recipeViewModel?.recipe.foodImageUrl ?? ""
        
        if foodImage.isSame(with: oldUrl) { self.recipeViewModel?.updateRecipe() }
        else {
            storage.imageUpload(to: .foodImages, id: uid , image: foodImage.image!) { [weak self] imageUrl in
                self?.recipeViewModel?.recipe.foodImageUrl = imageUrl
                self?.recipeViewModel?.updateRecipe()
            }
        }
    }

//MARK: - Button Taps
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let newInstruction = Instruction()
        instructions.append(newInstruction)
        scrollView.layoutIfNeeded()
        let bottom = scrollView.contentSize.height - scrollView.bounds.height
        scrollView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        if checkFieldValid {
            let alertVC = CustomAlertVC(action: nil, message: "Do you want to save your recipe?",
                                        image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis"))
            alertVC.delegate = self
            present(alertVC, animated: true)
        }
        
    }
    
    var checkFieldValid: Bool {

        guard !instructions.isEmpty else {
            presentAlert(title: "Can not continue", message: "Please enter an instruction", completion: nil);
            return false
        }
        
        guard !(instructions.contains { ($0.text?.isEmpty ?? true) }) else {
            presentAlert(title: "Can not continue", message: "Please fill all instruction fields", completion: nil);
            return false
        }
        return true   
    }
}

extension PrepareVC: CustomAlertVCDelegate {
    
    func OkTapped(action: String?) {
        saveRecipe()
        dismiss(animated: true)
    }
}

//MARK: - TableViewDelegates

extension PrepareVC: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PrepareTableCell.identifier, bundle: nil), forCellReuseIdentifier: PrepareTableCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrepareTableCell.identifier, for: indexPath) as? PrepareTableCell else {fatalError("Could not Load")}
        
        cell.tag = indexPath.row
        cell.configure(instruction: instructions[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            instructions.remove(at: indexPath.row)
            scrollView.layoutIfNeeded()
        }
    }
}

extension PrepareVC: PrepareCellDelegate {
    func updateCell(textView: String?, cell: PrepareTableCell) {
        let row = cell.tag
        instructions[row].text = textView
    }
}
