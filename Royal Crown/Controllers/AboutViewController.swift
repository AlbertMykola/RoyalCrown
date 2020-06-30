//
//  AboutViewController.swift
//  Royal Crown
//
//  Created by Albert on 24.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class AboutViewController: UIViewController {
    
    @IBOutlet weak private var myTableView: UITableView!
    
    //MARK: - Variable
    private var imagesCell = [UIImage(named: "imgAboutUs"), UIImage(named: "imgBranches"), UIImage(named: "imgEnshured")]
    private var nameCell = ["ABOUT US", "BRANCHES", "E-NSURED"]
    private var url = "http://31.131.21.105:82/api/v1/branches"
    private var dataSource: [Branches]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem)
        DataManager.shared.createTableView(tableView: myTableView, vc: self)
        DataManager.shared.createImageToNavigationBar(navigationController: navigationController!, navigationItem: navigationItem)
        parsing()
    }
    
    //MARK: - Private func
    private func parsing() {
        NetworkService.shared.request(urlString: url) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                do {
                    let result = try JSONDecoder().decode([Branches].self, from: result)
                    self.dataSource = result
                } catch {
                    break
                }
            case .failure(_):
                break
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            DataManager.shared.nextViewController(withIdentifier: "AboutUsViewController", navController: navigationController!)
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
            vc.dataSource = self.dataSource
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            DataManager.shared.linksOfSafari(url: "http://cw.royalcrowninsurance.eu/Login.aspx?ReturnUrl=%2f")
        default:
            break
        }
    }
}

//MARK: - UITableViewDataSource
extension AboutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellForRoyalAssist", for: indexPath) as! TableCellForRoyalAssist
        cell.myImageView.image = imagesCell[indexPath.row]
        cell.nameLabel.text = nameCell[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return myTableView.frame.height / 3
    }
    
}
