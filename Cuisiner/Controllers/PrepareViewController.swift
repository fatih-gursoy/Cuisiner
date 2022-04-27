//
//  PrepareViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 15.03.2022.
//

import UIKit

class PrepareViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var instructions = [Instruction]()
    var heightConstraint : NSLayoutConstraint?
    
    var recipeViewModel: RecipeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: PrepareTableCell.identifier, bundle: nil), forCellReuseIdentifier: PrepareTableCell.identifier)

        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
        heightConstraint?.isActive = true
        
    }
    
    func setTableViewHeight() {
        
        heightConstraint?.constant = tableView.contentSize.height
        heightConstraint?.isActive = true
        tableView.layoutIfNeeded()
        
    }

    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        let newInstruction = Instruction()
        instructions.append(newInstruction)
        
        tableView.reloadData()
        setTableViewHeight()
        
        let y = tableView.bounds.height
        scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        configureViewModel()
        recipeViewModel?.createNew()
        dismiss(animated: true)
        
    }
    
    
    func configureViewModel() {
        
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! PrepareTableCell
            
            instructions[i].step = cell.rowLabel.text
            instructions[i].text = cell.textView.text

        }
        recipeViewModel?.recipe.instructions = instructions
    }
    

}



extension PrepareViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrepareTableCell.identifier, for: indexPath) as! PrepareTableCell
        
        cell.rowLabel.text = String(indexPath.row + 1)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return instructions.count
    }
    
    
    
}
