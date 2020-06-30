//
//  WhatToDoITController.swift
//  Royal Crown
//
//  Created by Albert on 26.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class WhatToDoITController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak private var myTableView: UITableView!
    
    //MARK: - Variable
    var dataSource: [WhatToDoIt]?
    private let url = "http://31.131.21.105:82/api/v1/accident_instructions"
    
    //MARK: - Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem)
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(UINib(nibName: "AboutCellTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutCellTableViewCell")
        parsing()
    }
    
    //MARK: - Private func
    private func parsing() {
        NetworkService.shared.request(urlString: url) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                do {
                    let result = try JSONDecoder().decode([WhatToDoIt].self, from: result)
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
}

//MARK: - UITableViewDelegate
extension WhatToDoITController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AccidentInstructionsController") as! AccidentInstructionsController
        vc.dataSource = dataSource?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension WhatToDoITController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCellTableViewCell", for: indexPath) as! AboutCellTableViewCell
        cell.textLabel?.text = dataSource![indexPath.row].title
        return cell
    }
}
