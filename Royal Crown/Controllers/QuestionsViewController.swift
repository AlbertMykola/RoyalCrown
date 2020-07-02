//
//  QuestionsViewController.swift
//  Royal Crown
//
//  Created by Albert on 28.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class QuestionsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak private var myTableView: UITableView!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var questionLabel: UILabel!
    @IBOutlet weak private var pageControl: UIPageControl!
    
    //MARK: - Variable
    var url: String?
    var dataSource: [Question]?
    var id = 0
    var titleItem: String?
    private var answers: [Answers]?
    private var order = 0
    private let userDefault = UserDefaults.standard
    private var numberOfCorrectAnswers = 0
    private var dictionary = [Int: Bool]()
    private var cellIndex: Int?
    private var backCellIndex = [Int]()
    
    //MARK: - Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem, text: titleItem ?? "")
        pageControl.currentPage = 0
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "AnswerTableViewCell")
        parsing()
    }
    
    //MARK: - IBAction
    @IBAction func nextButton(_ sender: UIButton!)  {
        guard let cellIndex = cellIndex else { return }
        guard let dataSource = dataSource else { return }
        order += 1
        if order < dataSource.count - 1 {
            pageControl.currentPage = order
            let id = dataSource[order].id
            dictionary.updateValue(dataSource[order].answers[cellIndex].correct, forKey: id)
            calculation()
            myTableView.reloadData()
        } else if  order == dataSource.count - 1 {
            dictionary.removeAll()
            userDefault.set(counterLabel.text, forKey: "\(id)")
            navigationController?.popViewController(animated: true)
        }
        backCellIndex.append(cellIndex)
        self.cellIndex = nil
        myTableView.reloadData()
    }
    
    @IBAction func prevButton(_ sender: UIButton!)  {
        if order != 0 {
            order -= 1
            cellIndex = backCellIndex[order]
            pageControl.currentPage = order
            myTableView.reloadData()
        }
    }
    
    private func parsing() {
        NetworkService.shared.request(urlString: url!) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                do {
                    let result = try JSONDecoder().decode([Question].self, from: result)
                    self.dataSource = result
                    self.counterLabel.text = "0/\(self.dataSource!.count)"
                    self.pageControl.numberOfPages = self.dataSource!.count - 1
                    self.myTableView.reloadData()
                } catch {
                    break
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func calculation() {
        numberOfCorrectAnswers = 0
        for i in  dictionary.keys {
            if dictionary[i] == true {
                numberOfCorrectAnswers += 1
            }
        }
        self.counterLabel.text = "\(numberOfCorrectAnswers)/\(dataSource?.count ?? 0 - 1)"
    }
}

//MARK: - UITableViewDelegate
extension QuestionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellIndex = indexPath.row
        myTableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension QuestionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?[order].answers.count ?? 0 - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell", for: indexPath) as! AnswerTableViewCell
        if cellIndex == indexPath.row {
            cell.answerLabel?.text = dataSource?[order].answers[indexPath.row].text
            if #available(iOS 13.0, *) {
                cell.answerLabel.textColor = .tertiarySystemBackground
            } else {
                cell.answerLabel.textColor = .darkText
            }
            self.questionLabel.text = dataSource?[order].text
            return cell
        } else {
            cell.answerLabel?.text = dataSource?[order].answers[indexPath.row].text
            self.questionLabel.text = dataSource?[order].text
            cell.answerLabel.textColor = .lightGray
            return cell
        }
    }  
}
