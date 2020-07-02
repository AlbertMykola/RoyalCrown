//
//  PersonalViewController.swift
//  Royal Crown
//
//  Created by Albert on 24.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class PersonalViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak private var myTableView: UITableView!
    
    //MARK: - Variable
    var dataSource = [Services]()
    var titleItem: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
    }
    
    private func createTableView() {
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem, text: titleItem ?? "")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib(nibName: "AboutCellTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutCellTableViewCell")
    }
}

//MARK: - UITableViewDelegate
extension PersonalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CombinedViewController") as! CombinedViewController
        vc.dataSource = dataSource[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PersonalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCellTableViewCell", for: indexPath) as! AboutCellTableViewCell
        cell.textLabel?.text = dataSource[indexPath.row].title
        return cell
    }
}

