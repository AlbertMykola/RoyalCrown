//
//  QuestionnairesViewController.swift
//  Royal Crown
//
//  Created by Albert on 28.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class QuestionnairesViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak private var myTableView: UITableView!
    @IBOutlet weak var tryAgain: UIButton!
    
    //MARK: -Variable
    private var url = "http://31.131.21.105:82/api/v1/questionnaires"
    var dataSource: [Questionnaire]?
    
    //MARK: Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem, text: "Questionnaires")
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        myTableView.rowHeight = UITableView.automaticDimension
        parsing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        myTableView.reloadData()
    }
    
    //MARK - Functions
    private func tryAgainButtonIsHidden() {
        var count = 0
        guard let dataSource = dataSource else { return }
        for i in dataSource {
            if UserDefaults.standard.string(forKey: "\(i.id)") != nil {
                count += 1
            }
        }
        if count == dataSource.count {
            tryAgain.isHidden = false
            myTableView.isUserInteractionEnabled = false
        }
    }
    
    private func parsing() {
        NetworkService.shared.request(urlString: url) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                do {
                    let result = try JSONDecoder().decode([Questionnaire].self, from: result)
                    self.dataSource = result
                    self.myTableView.reloadData()
                } catch {
                    break
                }
            case .failure(_):
                break
            }
        }
    }
    
    //MARK: - Actions
    @IBAction private func tryAgainAction(_ sender: UIButton) {
        guard let dataSource = dataSource else { return }
        for i in dataSource {
            UserDefaults.standard.removeObject(forKey: "\(i.id)")
        }
        myTableView.isUserInteractionEnabled = true
        tryAgain.isHidden = true
        myTableView.reloadData()
    }
}

extension QuestionnairesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "QuestionsViewController") as! QuestionsViewController
        vc.url = "http://31.131.21.105:82/api/v1/questions?questionnaire_id=\(indexPath.row + 1)&"
        if let id = dataSource?[indexPath.row].id {
            vc.id = id
        }
        vc.titleItem = dataSource?[indexPath.row].title
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension QuestionnairesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.descriptionLabel.text = dataSource?[indexPath.row].description
        cell.titleLabel.text = dataSource?[indexPath.row].title
        
        if let order = UserDefaults.standard.string(forKey: "\(indexPath.row + 1)") {
            cell.heightCounterLabel.constant = 20.0
            cell.orderLabel.text = order
            tryAgainButtonIsHidden()
        } else {
            cell.heightCounterLabel.constant = 0.0
        }
        return cell
    }
    
    
}
