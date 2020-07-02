//
//  RoyalAssistController.swift
//  Royal Crown
//
//  Created by Albert on 24.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

class RoyalAssistController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak private var myTableView: UITableView!
    
    //MARK: - Variable
    private var imageCellArray = [UIImage(named: "imgWhatToDoIf"), UIImage(named: "imgMakeACall"), UIImage(named: "imgWhatToDoIf")]
    private var nameCellArray = ["REPORT IN ACCIDENT", "MAKE A CALL", "ABOUT ROYAL ASSIST"]
    
    //MARK: - Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.createTableView(tableView: myTableView, vc: self)
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem, text: "Royal Assist")
    }
    
    //MARK: - Private functions
    private func callOfNumber() {
        let url = NSURL(string: "telprompt://77777773")!
        if UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}

//MARK: - UITableViewDelegate
extension RoyalAssistController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            DataManager.shared.nextViewController(withIdentifier: "CameraViewController", navController: navigationController!)
        case 1:
            callOfNumber()
        case 2:
            DataManager.shared.nextViewController(withIdentifier: "AboutRoyalAssistController", navController: navigationController!)
        default:
            break
        }
    }
}

//MARK: - UITableViewDataSource
extension RoyalAssistController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageCellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellForRoyalAssist", for: indexPath) as? TableCellForRoyalAssist else {return UITableViewCell()}
        cell.myImageView?.image = imageCellArray[indexPath.row]
        cell.nameLabel.text = nameCellArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return myTableView.frame.height / 3
    }
}
