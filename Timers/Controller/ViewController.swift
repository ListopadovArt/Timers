//
//  ViewController.swift
//  Timers
//
//  Created by Artem Listopadov on 24.09.21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Components
    var tableView = UITableView()
    
    // MARK: - Properties
    var tasks: [Task] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigtionBarItems()
        setupTableView()
    }
    
    
    // MARK: - Configure
    fileprivate func configureNavigtionBarItems() {
        let navigationBar = navigationController?.navigationBar
        navigationItem.title = "MultiTimer"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,target: self, action: #selector(showAlertView))
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .systemYellow
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight(900))]
            navigationBar?.standardAppearance = appearance
            navigationBar?.scrollEdgeAppearance = appearance
            
        } else {
            let barAppearance = UINavigationBar.appearance()
            navigationBar?.barTintColor = .systemYellow
            navigationBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight(900))]
            barAppearance.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.defaultPrompt)
            barAppearance.shadowImage = UIImage()
        }
    }
    
    // MARK: - Actions
    @objc func showAlertView() {
        let alert = UIAlertController(title: "Set a timer", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Timer name"
            textField.autocapitalizationType = .sentences
        }
        alert.addTextField { textField in
            textField.placeholder = "Time, sec."
            textField.autocapitalizationType = .sentences
        }
        let okAction = UIAlertAction(title: "Start", style: .default) { [weak alert] (_) in
            
            if let textFieldName = alert?.textFields?[0].text, let textFieldTime = alert?.textFields?[1].text {
                DispatchQueue.main.async { [self] in
                    let task = Task(name: String(textFieldName), time: Int(textFieldTime) ?? 0)
                    tasks.append(task)
                    let indexPath = IndexPath(row: tasks.count - 1, section: 0)
                    tableView.beginUpdates()
                    tableView.insertRows(at: [indexPath], with: .top)
                    tableView.endUpdates()
                }
            }
        }
        let canсelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(canсelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Extensions

extension ViewController {
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TimerTableViewCell.self, forCellReuseIdentifier: TimerTableViewCell.reuseID)
        tableView.rowHeight = TimerTableViewCell.rowHeight
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimerTableViewCell.reuseID, for: indexPath) as? TimerTableViewCell else {
            return UITableViewCell()
        }
        if let name = tasks[indexPath.row].name, let time = tasks[indexPath.row].time {
            cell.configure(name: name, time: time)
        }
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.placeholder = "Type something"
            return false
        } else {
            return true
        }
    }
}

extension ViewController: TimerTableViewCellDelegate {
    func deleteTableViewCell(at index: IndexPath) {
        tasks.remove(at: index.row)
        tableView.deleteRows(at: [index], with: .automatic)
    }
}
