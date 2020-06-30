//
//  AboutRoyalAssistController.swift
//  Royal Crown
//
//  Created by Albert on 24.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class AboutRoyalAssistController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak private var myTextView: UITextView!
    
    //MARK: - Variable
    private var url = "http://31.131.21.105:82/api/v1/about_royal_assist"
    
    //MARK: - Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        parsing()
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem)
    }
    
    //MARK: - Private func
    private func parsing() {
        NetworkService.shared.request(urlString: url) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                do {
                    let result = try JSONDecoder().decode(Info.self, from: result)
                    let string = result.aboutRoyalAssist
                    guard let strings = string else {return}
                    self.myTextView.attributedText = strings.htmlToAttributedString
                    self.myTextView.textColor = .blue
                } catch {
                    break
                }
            case .failure(_): break
            }
        }
    }
}


