//
//  Blocked UsersVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 12.08.2022.
//

import UIKit

class BlockedUsersVC: UIViewController, Storyboardable {

    @IBOutlet private weak var tableView: UITableView!
    var viewModel = BlockedUsersViewModel()
    weak var coordinator: ProfileCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        viewModel.delegate = self
        viewModel.fetchUsers()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: UserTableCell.identifier, bundle: nil),
                           forCellReuseIdentifier: UserTableCell.identifier)
    }

}

extension BlockedUsersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel.users?.count else {return 0 } 
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableCell.identifier, for: indexPath) as? UserTableCell else { fatalError("Could not load") }
        
        guard let users = viewModel.users else { return UITableViewCell() }
        cell.configure(user: users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            guard let userId = viewModel.users?[indexPath.row].userId else { return }
            viewModel.removeBlock(userId: userId)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        guard let users = viewModel.users else { return }
        let userViewModel = UserViewModel(user: users[indexPath.row])
        let vc = ProfileVC.instantiateFromStoryboard()
        vc.viewModel = userViewModel
        present(vc, animated: true)
    }
    
}

extension BlockedUsersVC: BlockedUsersViewModelDelegate {
    func updateView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
