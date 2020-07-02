//
//  CombinedViewController.swift
//  Royal Crown
//
//  Created by Albert on 24.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class CombinedViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var myTextView: UITextView!
    
    //MARK: - Variables
    var dataSource: Services?
    
    //MARK: - Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = dataSource?.title
        let textHTML = dataSource?.description
        myTextView.attributedText = textHTML?.htmlToAttributedString
        myTextView.textColor = .blue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem, text: dataSource?.title ?? "")
    }
    
    //MARK: - Actions
    @IBAction func goToTheWebsite(_ sender: UIButton) {
        guard let website = dataSource?.website else { return }
        DataManager.shared.linksOfSafari(url: website)
    }
}


