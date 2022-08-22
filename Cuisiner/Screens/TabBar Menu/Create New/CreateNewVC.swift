//
//  CreateViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 10.03.2022.
//

import UIKit

class CreateNewVC: UIViewController, Storyboardable {
    
//MARK: - Properties
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var categoryButton: UIButton!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var foodImage: UIImageView!
    @IBOutlet private weak var pickerLogo: UIImageView!
    @IBOutlet private weak var serveImage: UIImageView!
    @IBOutlet private weak var cookTimeImage: UIImageView!
    @IBOutlet private weak var categoryImage: UIImageView!
    @IBOutlet private weak var recipeNameField: UITextField!
    @IBOutlet private weak var serveField: UITextField!
    @IBOutlet private weak var cookTimeField: UITextField!
    
    private var selectedCategory: Recipe.Category?
    private var pickerView = UIPickerView()
    private var toolBar = UIToolbar()
        
    private var ingredients = [Ingredient]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var coordinator: CreateNewCoordinator?
    var recipeViewModel: RecipeViewModel?

//MARK: - Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        updateUI()
        configureTableView()
        configureImagePicker()
        serveField.delegate = self
        cookTimeField.delegate = self
    }

    // Runs if update recipe screen is appear
    func updateUI() {
        guard let recipeViewModel = recipeViewModel else { return }
        self.headerLabel.text = "Update Recipe"
        self.recipeNameField.text = recipeViewModel.recipeName
        self.cookTimeField.text = recipeViewModel.recipe.cookTime
        self.serveField.text = recipeViewModel.recipe.serve
        self.foodImage.setImage(url: recipeViewModel.recipe.foodImageUrl)
        self.ingredients = recipeViewModel.ingredients
        
        selectedCategory = recipeViewModel.recipe.category
        if let row = Recipe.Category.allCases.firstIndex(of: selectedCategory!) {
            pickerView.selectRow(row, inComponent: 0, animated: false)
            categoryButton.setTitle(selectedCategory?.rawValue, for: .normal)
        }
    }
    
    func configureViewModel() {
                
        guard let checkFieldValid = checkFieldValid,
              let selectedCategory = selectedCategory else { return }
                
        if checkFieldValid {
            if recipeViewModel != nil {
                recipeViewModel?.recipe.name = self.recipeNameField.text
                recipeViewModel?.recipe.serve = self.serveField.text
                recipeViewModel?.recipe.cookTime = self.cookTimeField.text
                recipeViewModel?.recipe.category = selectedCategory
                recipeViewModel?.recipe.ingredients = self.ingredients
            } else {
                let recipe = Recipe(ownerId: AuthManager.shared.userId,
                                    id: UUID().uuidString,
                                    name: self.recipeNameField.text,
                                    serve: self.serveField.text,
                                    cookTime: self.cookTimeField.text,
                                    category: selectedCategory,
                                    ingredients: self.ingredients,
                                    instructions: [],
                                    ratingList: [])
                self.recipeViewModel = RecipeViewModel(recipe: recipe)
            }
        }
    }
    
    var checkFieldValid: Bool? {
        
        guard selectedCategory != nil else {
            presentAlert(title: "Can not continue", message: "Please select a category!", completion: nil); return false }
        
        guard let recipeName = recipeNameField.text, !recipeName.isEmpty else {
            presentAlert(title: "Can not continue", message: "Please enter a Recipe name", completion: nil); return false
        }
        
        guard let serve = serveField.text, !serve.isEmpty else {
            presentAlert(title: "Can not continue", message: "Please fill serve field", completion: nil); return false
        }
        
        guard let cookTime = cookTimeField.text, !cookTime.isEmpty else {
            presentAlert(title: "Can not continue", message: "Please fill cook time field", completion: nil); return false
        }
        return true
    }
    
//MARK: - Button Taps
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let newIngredient = Ingredient()
        ingredients.append(newIngredient)
        let bottom = tableView.contentSize.height
        scrollView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        configureViewModel()
        coordinator?.gotoPrepareVC(viewModel: self.recipeViewModel, delegate: self)
    }
}

// MARK: - ImagePass Delegate

protocol ImagePassDelegate: AnyObject {
    var foodImageToPass: UIImageView? { get }
}

extension CreateNewVC: ImagePassDelegate {
    var foodImageToPass: UIImageView? { get {return self.foodImage} }
}

// MARK: - Tableview Delegates

extension CreateNewVC: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: IngredientTableCell.identifier, bundle: nil),
                           forCellReuseIdentifier: IngredientTableCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableCell.identifier, for: indexPath) as? IngredientTableCell else { fatalError("Could not Load")}
        
        cell.tag = indexPath.row
        cell.delegate = self
        cell.configureForEdit(ingredient: ingredients[indexPath.row])
        return cell
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

// MARK: - TableCell Delegate

extension CreateNewVC: IngredientCellDelegate {
    func updateCell(itemName: String?, amount: String?, cell: IngredientTableCell) {
        let row = cell.tag
        ingredients[row].name = itemName
        ingredients[row].amount = amount
    }
    
    func deleteCell(cell: IngredientTableCell) {
        let row = cell.tag
        ingredients.remove(at: row)
    }
}

// MARK: - ImagePickerDelegate
        
extension CreateNewVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func configureImagePicker() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        foodImage.addGestureRecognizer(gesture)
        foodImage.isUserInteractionEnabled = true
    }

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

// MARK: - PickerView Delegate

extension CreateNewVC: UIPickerViewDelegate, UIPickerViewDataSource {
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Recipe.Category.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Recipe.Category.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = Recipe.Category.allCases[row]
        let buttonTitle = selectedCategory?.rawValue
        categoryButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func categoryButtonClicked(_ sender: Any) {
        configurePickerView()
    }
    
    func configurePickerView() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.contentMode = .top
        pickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        
        pickerView.backgroundColor = UIColor.systemBackground
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
        
        toolBar.barStyle = .default
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        
        let barButton = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle.fill"),
                                        style: .done, target: self, action: #selector(doneButtonTapped))
        
        spacer.width = UIScreen.main.bounds.size.width - barButton.width
        toolBar.items = [spacer, barButton]
        toolBar.sizeToFit()
        
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve] , animations: {
            self.view.addSubview(self.pickerView)
            self.view.addSubview(self.toolBar)
        })
    }
    
    @objc func doneButtonTapped() {
        pickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
}

// MARK: - TextField Delegate

extension CreateNewVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let onlyNumbers = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return onlyNumbers.isSuperset(of: characterSet)
    }
}

