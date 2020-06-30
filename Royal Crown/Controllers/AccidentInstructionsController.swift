//
//  AccidentInstructionsController.swift
//  Royal Crown
//
//  Created by Albert on 26.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class AccidentInstructionsController: UIViewController {
    
    var dataSource: WhatToDoIt?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentControll: UISegmentedControl!
    @IBOutlet weak var myTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem)
        if dataSource?.tabs == false {
            titleLabel.isHidden = false
            titleLabel.text = dataSource?.tabTitleFirst
        } else {
            segmentControll.isHidden = false
        }
        segmentControll.setTitle(dataSource?.tabTitleFirst, forSegmentAt: 0)
        segmentControll.setTitle(dataSource?.tabTitleSecond, forSegmentAt: 1)
        segmentControll.removeBorders()
        myTextView.attributedText = dataSource?.tabContentFirst.htmlToAttributedString
        myTextView.textColor = .blue
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if  sender.selectedSegmentIndex == 0 {
            self.myTextView.attributedText = dataSource?.tabContentFirst.htmlToAttributedString
            myTextView.textColor = .blue
        } else {
            self.myTextView.attributedText = dataSource?.tabContentSecond.htmlToAttributedString
            myTextView.textColor = .blue
        }
    }
}




