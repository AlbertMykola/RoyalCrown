//
//  TaskManager.swift
//  Royal Crown
//
//  Created by Albert on 24.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.


import Foundation
import UIKit

class DataManager {
    static var shared = DataManager()
    
    func createTableView(tableView: UITableView, vc: UIViewController) {
        tableView.register(UINib(nibName: "TableCellForRoyalAssist", bundle: nil), forCellReuseIdentifier: "TableCellForRoyalAssist")
        
        tableView.delegate = vc as? UITableViewDelegate
        tableView.dataSource = vc as? UITableViewDataSource
    }

    func createImageToNavigationBar(navigationController: UINavigationController, navigationItem: UINavigationItem, text: String) {
        let navigationController = navigationController
        let width = navigationController.navigationBar.frame.width
        let height = navigationController.navigationBar.frame.height
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let imageView = UIImageView(frame: CGRect(x: width - 100, y: 0, width: 50, height: 40))
        imageView.image = #imageLiteral(resourceName: "icIconRed")
        imageView.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13.0)
        label.text = text
        label.numberOfLines = 0
        
        label.textColor = .blue
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: 200, height: height)
        label.center.x = navigationController.navigationBar.center.x  - 40
        
        container.addSubview(imageView)
        container.addSubview(label)
        navigationItem.titleView = container
    }
    
    func nextViewController(withIdentifier: String, navController: UINavigationController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: withIdentifier)
        navController.pushViewController(VC, animated: true)
    }
    
    func linksOfSafari(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}


