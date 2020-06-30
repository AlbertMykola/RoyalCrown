//
//  AboutUsViewController.swift
//  Royal Crown
//
//  Created by Albert on 25.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class AboutUsViewController: UIViewController {
    
    @IBOutlet weak private var myTextView: UITextView!
    
    //MARK: - Variable
    private let url = "http://31.131.21.105:82/api/v1/about_us"
    private var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem)
        parsing()
    }
    
    //MARK: - Private func
    private func parsing() {
        NetworkService.shared.request(urlString: url) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                do {
                    let result = try JSONDecoder().decode(Info.self, from: result)
                    self.myTextView.attributedText = result.aboutUs?.htmlToAttributedString
                    self.myTextView.textColor = .blue
                } catch {
                    break
                }
            case .failure(_):
                break
            }
        }
    }
}
