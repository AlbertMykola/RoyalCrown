//
//  PhotoCollectionCell.swift
//  Royal Crown
//
//  Created by Albert on 26.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit

//MARK: - Delegat
protocol removeCollectionCell: class {
    
    func didTapedButton(from cell: UICollectionViewCell)
}

class PhotoCollectionCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var photos: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK: - Variable
    weak var delegate: removeCollectionCell? = nil

    //MARK: - Action
    @IBAction func deletePhoto(_ sender: UIButton) {
        delegate?.didTapedButton(from: self)
    }

}
