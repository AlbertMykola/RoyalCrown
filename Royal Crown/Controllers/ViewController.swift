//
//  ViewController.swift
//  Royal Crown
//
//  Created by Albert on 23.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak private var myCollectionView: UICollectionView!
    
    //MARK: - Variable
    private var imageArray = [UIImage(named: "imgRoyalAssist"), UIImage(named: "imgRoyalPayment"), UIImage(named: "imgServices"), UIImage(named: "imgWhatToDoIf"), UIImage(named: "imgAbout"), UIImage(named: "imgWhatToDoIf")]
    private var nameCellsArray = ["ROYAL ASSIST", "ROYAL PAYMENT", "SERVICES", "WHAT TO DO IT", "ABOUT", "QUESTIONNAIRES"]
    
    //MARK: - Live Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectionView()
        createImageToNavigationBar()
        createCollectionView()

    }
    
    //MARK: - Private func
    private func createCollectionView() {
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
    }
    
    private func createImageToNavigationBar() {
        guard let navigationController = navigationController else { return }
        let width = navigationController.navigationBar.frame.width * 0.5
        let height = navigationController.navigationBar.frame.height
        let container = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.image = #imageLiteral(resourceName: "icLogoMain-1")
        imageView.contentMode = .scaleAspectFit
        container.addSubview(imageView)
        navigationItem.titleView = container
    }
}

//MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            DataManager.shared.nextViewController(withIdentifier: "RoyalAssistController", navController: navigationController!)
        case 1:
            DataManager.shared.nextViewController(withIdentifier: "RoyalPaymentsViewController", navController: navigationController!)
        case 2:
            DataManager.shared.nextViewController(withIdentifier: "ServicesViewController", navController: navigationController!)
        case 3:
            DataManager.shared.nextViewController(withIdentifier: "WhatToDoITController", navController: navigationController!)
        case 4:
            DataManager.shared.nextViewController(withIdentifier: "AboutViewController", navController: navigationController!)
        case 5:
            DataManager.shared.nextViewController(withIdentifier: "QuestionnairesViewController", navController: navigationController!)
        default:
            break
        }
    }
}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameCellsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        cell.imageCell.image = imageArray[indexPath.row]
        cell.nameCell.text = nameCellsArray[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if indexPath.row == 2 || indexPath.row == 5 {
            let width  = view.frame.width
            let height = (view.frame.height - 120) / 4
            return CGSize(width: width, height: height)
        } else {
            let width  = (view.frame.width - 10) / 2
            let height = (view.frame.height - 50) / 4
            return CGSize(width: width, height: height)
        }
    }
}
