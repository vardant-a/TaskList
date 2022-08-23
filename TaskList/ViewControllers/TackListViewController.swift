//
//  TackListViewController.swift
//  TaskList
//
//  Created by Алексей on 22.08.2022.
//

import UIKit

class TackListViewController: UITableViewController {
    
    private let сontext = StorageManager.shared.persistentContainer.viewContext
    
    private let cellID = "task"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .white
        setupNavigationBar()
        fetchData()
    }
    
    // MARK: Setting TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .white
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let taskEdit = taskList[indexPath.row]
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            showAlertEdit(taskEdit)
            tableView.endUpdates()
        }
    }
}

extension TackListViewController {
    
    // MARK: - Setting NavigationBar
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .darkGray
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func didTapAddTask() {
        if taskList.isEmpty {
            showAlert(
                withTitle: "First task",
                andMessage: "What do you want to do first?"
            )
        } else {
            showAlert(
                withTitle: "New task",
                andMessage: "What do you want to do?"
            )
        }
    }
    
    // MARK: - Working Data Store
    
    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try сontext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func addTask(_ taskName: String) {
        let task = Task(context: сontext)
        task.title = taskName
        taskList.append(task)
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        if сontext.hasChanges {
            do {
                try сontext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func editTask(_ task: Task, newName: String) {
        task.title = newName
        
        if сontext.hasChanges {
            do {
                try сontext.save()
                fetchData()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        tableView.reloadData()
    }
    
    private func deleteTask(_ task: Task) {
        сontext.delete(task)
        
        if сontext.hasChanges {
            do {
                try сontext.save()
                fetchData()
            } catch let error {
                print(error.localizedDescription)
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Alert Controller
    
    private func showAlert(_ task: Task? = nil, withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Save",
                style: .default
            ) { [unowned self] _ in
                guard let taskName = alert.textFields?.first?.text, !taskName.isEmpty else { return }
                if title == "Edit" {
                    editTask(task ?? taskList[1], newName: taskName)
                    tableView.reloadData()
                } else {
                    addTask(taskName)
                    tableView.reloadData()
                }
        })
        
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .destructive) { _ in })
        alert.addTextField { textField in
            if title == "Edit" {
                textField.text = task?.title ?? nil
                textField.placeholder = "Make edits"
            } else {
                textField.placeholder = "Enter new task"
            }
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlertEdit(_ task: Task) {
        let alert = UIAlertController(
            title: task.title ?? "Task",
            message: "Please select an option required for this task",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Edit",
                style: .default,
                handler: { [unowned self] _ in
                    showAlert(task,
                        withTitle: "Edit",
                        andMessage: "Make changes")
                }
            ))
        
        alert.addAction(
            UIAlertAction(
                title: "Delete",
                style: .destructive,
                handler: { [unowned self] _ in
                    deleteTask(task)
                    tableView.reloadData()
                }
            ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true, completion: nil)
    }
}
