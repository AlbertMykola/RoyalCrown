//
//  RoyalPaymentsViewController.swift
//  Royal Crown
//
//  Created by Albert on 24.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class RoyalPaymentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.createImageToNavigationBar(navigationController: navigationController!, navigationItem: navigationItem, text: "Royal Payments")
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        DataManager.shared.linksOfSafari(url: "https://www.jccsmart.com/eBills/Welcome/Index/9634031")
        
    }
}
