//
//  PrepareViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 15.03.2022.
//

import UIKit
import SwiftUI

class PrepareVC: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var tableHeightConstraint: NSLayoutConstraint!
    
    private var instructions = [Instruction]()
    private var storage = StorageService.shared
    
    var recipeViewModel: RecipeViewModel?
    weak var delegate: ImagePassDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: PrepareTableCell.identifier, bundle: nil), forCellReuseIdentifier: PrepareTableCell.identifier)
                
    }
    
    func setTableViewHeight() {
        
        tableHeightConstraint.constant = tableView.contentSize.height
        tableHeightConstraint.isActive = true
        tableView.layoutIfNeeded()
        
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        let newInstruction = Instruction()
        instructions.append(newInstruction)
        
        tableView.reloadData()
        setTableViewHeight()
        scrollView.layoutIfNeeded()
        
        let bottom = scrollView.contentSize.height - scrollView.bounds.size.height    
        scrollView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        saveRecipe()
        dismiss(animated: true)
        
    }
    
    func saveRecipe() {
        
        configureViewModel()
        
        guard let foodImage = delegate?.foodImageToPass?.image else { return }
        
        storage.imageUpload(to: .foodImages, image: foodImage) { imageUrl in
            
            self.recipeViewModel?.recipe.foodImageUrl = imageUrl
            self.recipeViewModel?.createNew()
            
        }
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



extension PrepareVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrepareTableCell.identifier, for: indexPath) as! PrepareTableCell
        
        cell.rowLabel.text = String(indexPath.row + 1)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return instructions.count
    }
    
    
    
}
