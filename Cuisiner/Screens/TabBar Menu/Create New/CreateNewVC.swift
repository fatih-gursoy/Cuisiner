//
//  CreateViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 10.03.2022.
//

import UIKit

class CreateNewVC: UIViewController {
    
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
        
    private var ingredients = [Ingredient]()
    var recipeViewModel: RecipeViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        hideKeyboard()
        keyboardNotification(scrollView: self.scrollView)
        configureNavBar()
        configureImagePicker()
        updateUI()
        configureTableView()
        
        serveField.delegate = self
        cookTimeField.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func updateUI() {
        guard let recipeViewModel = recipeViewModel else { return }
        self.headerLabel.text = "Update Recipe"
        self.recipeNameField.text = recipeViewModel.recipeName
        self.cookTimeField.text = recipeViewModel.recipe.cookTime
        self.serveField.text = recipeViewModel.recipe.serve
        self.foodImage.setImage(url: recipeViewModel.recipe.foodImageUrl)
        
        if let ingredients = recipeViewModel.ingredients {
            self.ingredients = ingredients
        }
        
        selectedCategory = recipeViewModel.recipe.category
        if let row = Recipe.Category.allCases.firstIndex(of: selectedCategory!) {
            pickerView.selectRow(row, inComponent: 0, animated: false)
            categoryButton.setTitle(selectedCategory?.rawValue, for: .normal)
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IngredientTableCell", bundle: nil), forCellReuseIdentifier: IngredientTableCell.identifier)
        tableView.reloadData()
    }
    

    func configureNavBar() {
        
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        self.navigationItem.rightBarButtonItem = barButton
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        getIngredientData()
        let newIngredient = Ingredient()
        ingredients.append(newIngredient)
        tableView.reloadData()
        let bottom = tableView.contentSize.height
        scrollView.setContentOffset(CGPoint(x: 0, y: bottom), animated: true)
    }
    
    @IBAction func continueClicked(_ sender: Any) {
        configureViewModel()
        guard let prepareVC = self.storyboard?.instantiateViewController(withIdentifier: "PrepareVC") as? PrepareVC else { fatalError("Error")}
      
        prepareVC.recipeViewModel = self.recipeViewModel
        prepareVC.delegate = self
        navigationController?.pushViewController(prepareVC, animated: true)
    }
    
    func configureViewModel() {
                
        guard let selectedCategory = selectedCategory else {
            return presentAlert(title: "Can not continue", message: "Please select a category!", completion: nil) }

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
                                      ratingList: [])
      
            self.recipeViewModel = RecipeViewModel(recipe: recipe)
        }
    }
    
}

// MARK: - ImagePass Delegate

protocol ImagePassDelegate: AnyObject {
    var foodImageToPass: UIImageView? { get }
}

extension CreateNewVC: ImagePassDelegate {
    var foodImageToPass: UIImageView? {
        get {return self.foodImage}
    }
}

// MARK: - Tableview Delegates

extension CreateNewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableCell.identifier, for: indexPath) as? IngredientTableCell else { fatalError("Could not Load")}
        
        cell.configureForUpdate(ingredient: ingredients[indexPath.row])
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteRow(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteRow(_ sender: UIButton) {
        let row = sender.tag
        ingredients.remove(at: row)
        tableView.reloadData()
    }
    
    func getIngredientData() {
        
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? IngredientTableCell else {return}
            
            ingredients[i].name = cell.itemName.text
            ingredients[i].amount = cell.itemQuantity.text
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
        pickerView.contentMode = .top
        pickerView.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        
        pickerView.backgroundColor = UIColor.systemBackground
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
        
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))]
        
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

