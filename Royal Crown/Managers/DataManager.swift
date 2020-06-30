//
//  TaskManager.swift
//  Royal Crown
//
//  Created by Albert on 24.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//
//private func createImageToNavigationBar() {
//     guard let navigationController = navigationController else { return }
//     let width = navigationController.navigationBar.frame.width * 0.5
//     let height = navigationController.navigationBar.frame.height
//
//     let container = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//     let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//     imageView.image = #imageLiteral(resourceName: "icLogoMain")
//     imageView.contentMode = .scaleAspectFit
//     container.addSubview(imageView)
//     navigationItem.titleView = container
// }

import Foundation
import UIKit

class DataManager {
    static var shared = DataManager()
    
    func createTableView(tableView: UITableView, vc: UIViewController) {
        tableView.register(UINib(nibName: "TableCellForRoyalAssist", bundle: nil), forCellReuseIdentifier: "TableCellForRoyalAssist")
        
        tableView.delegate = vc as? UITableViewDelegate
        tableView.dataSource = vc as? UITableViewDataSource
    }
    
    func createImageToNavigationBar(navigationController: UINavigationController, navigationItem: UINavigationItem) {
        let navigationController = navigationController
        let container = UIView(frame: CGRect(x: navigationController.navigationBar.center.x, y: navigationController.navigationBar.center.y, width: 50, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        
        imageView.image = #imageLiteral(resourceName: "icIconRed")
        imageView.contentMode = .scaleAspectFit
        container.addSubview(imageView)
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


