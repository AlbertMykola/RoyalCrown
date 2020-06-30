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
    private var answers: [Answers]?
    private var order = 0
    private let userDefault = UserDefaults.standard
    private var numberOfCorrectAnswers = 0
    private var dictionary = [Int: Bool]()
    
    //MARK: - Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem)
        pageControl.currentPage = 0
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "AnswerTableViewCell")
        parsing()
    }
    
    //MARK: - IBAction
    @IBAction func nextButton(_ sender: UIButton!)  {
        guard let dataSourceCount = dataSource?.count else { return }
        if order < dataSourceCount - 1 {
            order += 1
            pageControl.currentPage = order
            myTableView.reloadData()
        }
    }
    
    @IBAction func prevButton(_ sender: UIButton!)  {
        if order != 0 {
            order -= 1
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
                    self.pageControl.numberOfPages = self.dataSource!.count
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
                self.counterLabel.text = "\(numberOfCorrectAnswers)/\(dataSource?.count ?? 0 - 1)"
            }
        }
    }
}

//MARK: - UITableViewDelegate
extension QuestionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }
        if order < dataSource.count - 1 {
            order += 1
            pageControl.currentPage = order
            let id = dataSource[order].answers[indexPath.row].id
            self.dictionary[id] = dataSource[order].answers[indexPath.row].correct
            calculation()
            myTableView.reloadData()
        } else if  order == dataSource.count - 1 {
            dictionary.removeAll()
            userDefault.set(counterLabel.text, forKey: "\(id)")
            navigationController?.popViewController(animated: true)
        }
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
        cell.answerLabel?.text = dataSource?[order].answers[indexPath.row].text
        self.questionLabel.text = dataSource?[order].text
        return cell
    }  
}
