//
//  CreateViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 10.03.2022.
//

import UIKit
import Firebase

class CreateViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var pickerLogo: UIImageView!
    
    @IBOutlet weak var serveImage: UIImageView!
    @IBOutlet weak var cookTimeImage: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var serveView: UIView!
    @IBOutlet weak var cookTimeView: UIView!
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var recipeNameField: UITextField!
    @IBOutlet weak var serveField: UITextField!
    @IBOutlet weak var cookTimeField: UITextField!
    
    var recipeViewModel: RecipeViewModel?
    
    var heightConstraint : NSLayoutConstraint?
    var arrayofIngredient = [Ingredient]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        foodImage.addGestureRecognizer(gesture)
        foodImage.isUserInteractionEnabled = true
        
        let barButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        self.navigationItem.rightBarButtonItem = barButton
        
        tableView.register(UINib(nibName: "IngredientTableCell", bundle: nil), forCellReuseIdentifier: IngredientTableCell.identifier)
                
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
        heightConstraint?.isActive = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
                
    }
    
    override func viewDidLayoutSubviews() {

        customLayout(customView: serveView)
        customLayout(customView: cookTimeView)
        customLayout(customView: categoryView)
        customLayout(customView: foodImage)
        customLayout(customView: recipeNameField)

        recipeNameField.layer.borderColor = UIColor.red.cgColor
        recipeNameField.layer.borderWidth = 0.3
        
        foodImage.image = UIImage(named: "launch")
        pickerLogo.image = UIImage(named: "edit")
        serveImage.image = UIImage(named: "serve")
        cookTimeImage.image = UIImage(named: "cook")
        categoryImage.image = UIImage(named: "cook")

    }
    
    func customLayout(customView: UIView) {
        
        customView.layer.cornerRadius = 15.0
        customView.layer.masksToBounds = true
        
    }
    

    func setTableViewHeight() {
        
        heightConstraint?.constant = tableView.contentSize.height
        heightConstraint?.isActive = true
        tableView.layoutIfNeeded()
        
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        let newIngredient = Ingredient()
        arrayofIngredient.append(newIngredient)
        
        tableView.reloadData()
        setTableViewHeight()
        
        let y = tableView.bounds.height
        scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        
    }

    @objc func closeTapped() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func continueClicked(_ sender: Any) {
       
        performSegue(withIdentifier: "toPrepareVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        configureModel()
        
        if segue.identifier == "toPrepareVC" {
            let vc = segue.destination as! PrepareViewController
            vc.recipeViewModel = recipeViewModel
        }
    }
    
    func configureModel() {
        
        getIngredientData()
        
        let recipe = Recipe(ownerId: CurrentUser.shared.userId,
                            id: UUID().uuidString ,
                            name: recipeNameField.text,
                            serve: serveField.text,
                            cookTime: cookTimeField.text,
                            category: .homeMeal,
                            ingredients: arrayofIngredient,
                            instructions: nil)
        
        recipeViewModel = RecipeViewModel(recipe: recipe)

    }
    

    
}


// MARK: - Tableview Delegate

extension CreateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayofIngredient.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableCell.identifier, for: indexPath) as! IngredientTableCell
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteRow(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func deleteRow(_ sender: UIButton) {
        
        let row = sender.tag
        arrayofIngredient.remove(at: row)
        tableView.reloadData()
        setTableViewHeight()
        
    }

    
    func getIngredientData() {
        
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! IngredientTableCell
            
            arrayofIngredient[i].name = cell.itemName.text
            arrayofIngredient[i].amount = cell.itemQuantity.text

        }
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerTitle: UILabel = {
            let title = UILabel()
            title.text = "Ingredients"
            title.font = UIFont(name: "Gill Sans SemiBold", size: 20.0)
            return title
        }()
        
        return headerTitle
    }
    
}


 // MARK: - ImagePickerDelegate
        
extension CreateViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    

    @objc func imageTapped() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        foodImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)

    }
    
}

