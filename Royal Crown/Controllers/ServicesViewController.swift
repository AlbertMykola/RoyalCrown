//
//  RoyalPaymentViewController.swift
//  Royal Crown
//
//  Created by Albert on 24.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class ServicesViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak private var myTableView: UITableView!
    
    //MARK: - Variable
    private var imagesForCell = [UIImage(named: "imgWhatToDoIf"), UIImage(named: "imgWhatToDoIf-1")]
    private var nameCell = ["BUSINESS", "PERSONAL"]
    private var url = "http://31.131.21.105:82/api/v1/services"
    private var dataSource: [Services]?
    private var personalTypeArray = [Services]()
    private var businessTypeArray = [Services]()
    
    //MARK: - Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    let result = try JSONDecoder().decode([Services].self, from: result)
                    self.dataSource = result
                    self.myTableView.reloadData()
                    self.sort()
                } catch {}
            case .failure(_):
                break
            }
        }
    }
    
    private func goToTheNextVC(param: [Services]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PersonalViewController") as! PersonalViewController
        vc.dataSource = param
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func sort() {
        guard let dataSource = dataSource else { return }
        for i in dataSource {
            if i.type == "personal" {
                personalTypeArray.append(i)
            } else {
                businessTypeArray.append(i)
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension ServicesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            goToTheNextVC(param: personalTypeArray)
        case 1:
            goToTheNextVC(param: businessTypeArray)
        default:
            break
        }
    }
}

//MARK: - UITableViewDataSource
extension ServicesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellForRoyalAssist", for: indexPath) as! TableCellForRoyalAssist
        cell.myImageView.image = imagesForCell[indexPath.row]
        cell.nameLabel.text = nameCell[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return myTableView.frame.height / 2
    }
}
