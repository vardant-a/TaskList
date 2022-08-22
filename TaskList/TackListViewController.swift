//
//  TackListViewController.swift
//  TaskList
//
//  Created by Алексей on 22.08.2022.
//

import UIKit

class TackListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupNavigationBar()
    }
    

}
extension TackListViewController {
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(
            red: 230/255,
            green: 190/255,
            blue: 0/255,
            alpha: 255/255
        )
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkGray]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .darkGray
    }
    
    @objc private func addNewTask() {
        let TackVC = TackViewController()
        present(TackVC, animated: true)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Add new task",
            message: nil,
            preferredStyle: .alert
        )
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let textField = alert.textFields?.first,
               let text = textField.text {
                print(text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new task"
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
