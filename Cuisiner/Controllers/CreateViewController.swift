//
//  CreateViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 10.03.2022.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var categoryButton: UIButton!
    
    @IBOutlet private weak var foodImage: UIImageView!
    @IBOutlet private weak var pickerLogo: UIImageView!
    @IBOutlet private weak var serveImage: UIImageView!
    @IBOutlet private weak var cookTimeImage: UIImageView!
    @IBOutlet private weak var categoryImage: UIImageView!
    
    @IBOutlet private weak var recipeNameField: UITextField!
    @IBOutlet private weak var serveField: UITextField!
    @IBOutlet private weak var cookTimeField: UITextField!
    
    private var recipeViewModel: RecipeViewModel?
    
    private var pickerView = UIPickerView()
    private var toolBar = UIToolbar()
    
//    private var storage = StorageService.shared
    
    private var heightConstraint : NSLayoutConstraint?
    private var ingredients = [Ingredient]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboard()
        configureNavBar()
        configureImagePicker()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "IngredientTableCell", bundle: nil), forCellReuseIdentifier: IngredientTableCell.identifier)
                
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
        heightConstraint?.isActive = true
            
    }
    
    override func viewDidLayoutSubviews() {

        recipeNameField.layer.borderColor = UIColor.red.cgColor
        recipeNameField.layer.borderWidth = 0.3
        
    }
    

    func configureNavBar() {
        
        let barButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        self.navigationItem.rightBarButtonItem = barButton
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    
    @objc func closeTapped() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

    func setTableViewHeight() {
        
        heightConstraint?.constant = tableView.contentSize.height
        heightConstraint?.isActive = true
        tableView.layoutIfNeeded()
        
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        let newIngredient = Ingredient()
        ingredients.append(newIngredient)
        
        tableView.reloadData()
        setTableViewHeight()
        
        let y = tableView.bounds.height
        scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        
    }

    
    @IBAction func continueClicked(_ sender: Any) {
       
        configureViewModel()
        
        guard let prepareVC = self.storyboard?.instantiateViewController(withIdentifier: "PrepareVC") as? PrepareViewController else { fatalError("Error")}
      
        prepareVC.recipeViewModel = recipeViewModel
        prepareVC.delegate = self
        navigationController?.pushViewController(prepareVC, animated: true)
        
    }
    
    func configureViewModel() {
        
        getIngredientData()
        
        let recipe = Recipe(ownerId: CurrentUser.shared.userId,
                                  id: UUID().uuidString ,
                                  name: self.recipeNameField.text,
                                  serve: self.serveField.text,
                                  cookTime: self.cookTimeField.text,
                                  category: .homeMeal,
                                  ingredients: self.ingredients,
                                  favoriteStar: 0)
  
        recipeViewModel = RecipeViewModel(recipe: recipe)

    }
    
}

protocol ImagePassDelegate: AnyObject {
    
    var foodImageToPass: UIImageView? { get }
    
}


extension CreateViewController: ImagePassDelegate {
    
    var foodImageToPass: UIImageView? {
        
        get {
            return self.foodImage
        }
    }
    
    
    
}




// MARK: - Tableview Delegate

extension CreateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableCell.identifier, for: indexPath) as! IngredientTableCell
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteRow(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func deleteRow(_ sender: UIButton) {
        
        let row = sender.tag
        ingredients.remove(at: row)
        tableView.reloadData()
        setTableViewHeight()
        
    }

    
    func getIngredientData() {
        
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! IngredientTableCell
            
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
        
extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

// MARK: PickerView Delegate

extension CreateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        
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
        
        let buttonTitle = Recipe.Category.allCases[row].rawValue
        categoryButton.setTitle(buttonTitle, for: .normal)
    }
    
    
    @IBAction func categoryButtonClicked(_ sender: Any) {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
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

