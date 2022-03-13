//
//  CreateViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 10.03.2022.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var pickerLogo: UIImageView!
    
    @IBOutlet weak var serveImage: UIImageView!
    @IBOutlet weak var cookTimeImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var serveView: UIView!
    @IBOutlet weak var cookTimeView: UIView!
    
    var heightConstraint : NSLayoutConstraint?
    var arrayofIngredient = [Ingredient]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        foodImage.image = UIImage(named: "launch")
        pickerLogo.image = UIImage(named: "edit")

        serveImage.image = UIImage(named: "serve")
        cookTimeImage.image = UIImage(named: "cook")
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        foodImage.addGestureRecognizer(gesture)
        foodImage.isUserInteractionEnabled = true
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableCell" )
        
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
        heightConstraint?.isActive = true
    }
    
    override func viewDidLayoutSubviews() {

        makeCustomLayout(customView: serveView)
        makeCustomLayout(customView: cookTimeView)

    }
    
    func makeCustomLayout(customView: UIView) {
        
        customView.layer.cornerRadius = 20.0
        customView.layer.masksToBounds = false
        
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
        
    }

    
}

extension CreateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayofIngredient.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        
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
    
}


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

        if info.count > 0 {
            foodImage.contentMode = .scaleAspectFill
        }
    }
    
}

