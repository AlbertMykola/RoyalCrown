//
//  AccidentReportController.swift
//  Royal Crown
//
//  Created by Albert on 26.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit



final class AccidentReportController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet weak private var myCollectionView: UICollectionView!
    @IBOutlet weak private var reportButton: UIButton!
    @IBOutlet weak private var messageLabel: UILabel!
    
    //MARK: - Variable
    var dataSource = [UIImage]()
    var border = CALayer()
    var switchValue = true
    var count = 0
    let url = "http://31.131.21.105:82/api/v1/accident_reports"
    
    //MARK: Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem)
        addCollectionCell()
        for textField in textFieldCollection {
            textField.delegate = self
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for textField in textFieldCollection {
            switch textField.tag {
            case 2:
                if textField.text?.count ?? 0 < 5 {
                    self.emphasis(textField: textField, color: UIColor.red.cgColor)
                } else {
                    self.emphasis(textField: textField, color: UIColor.lightGray.cgColor)
                }
            default:
                if textField.text?.count ?? 0 < 3 {
                    self.emphasis(textField: textField, color: UIColor.red.cgColor)
                } else {
                    self.emphasis(textField: textField, color: UIColor.lightGray.cgColor)
                }
            }
        }
    }
    
    //MARK: - Private func
    private func addCollectionCell() {
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(UINib(nibName: "PhotoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionCell")
    }
    
    private func backRootController() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self](_) in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func emphasis(textField: UITextField, color: CGColor) {
        border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = color
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: textField.frame.size.height)
        textField.borderStyle = .none
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
    @IBAction func didChangeSwitch(_ sender: UISwitch!) {
        switchValue = sender.isOn
    }
    
    @IBAction func report(_ sender: UIButton!) {
        let encodedImages = dataSource.compactMap({ $0.pngData()?.base64EncodedString() })
        let param = ["name": "\(textFieldCollection[0].text ?? "")" , "reg_policy_number": "\(textFieldCollection[1].text ?? "")", "phone_number": "\(textFieldCollection[2].text ?? "")", "photos_attributes": "\(encodedImages)"]
        guard let url = URL(string: "http://31.131.21.105:82/api/v1/accident_reports") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json;", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: param, options: []) else {return}
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {return}
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let string = json as? [String: String]
                let error =  json as? [String: [String]]
                
                DispatchQueue.main.async {
                    self.backRootController()
                }
                DispatchQueue.main.async {
                    self.messageLabel.isHidden = false
                    if string != nil {
                        self.messageLabel.text = string?["message"]
                    } else {
                        let massage =  error?["errors"]
                        var string = ""
                        for i in massage! {
                            string += "\(i), "
                        }
                        self.messageLabel.text = string
                        self.messageLabel.backgroundColor = .red
                    }
                }
            }
            catch {
            }
        }.resume()
    }
}

extension AccidentReportController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
}

extension AccidentReportController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
        cell.delegate = self
        if indexPath.row == 0 {
            cell.deleteButton.isHidden = true
            cell.photos.image = #imageLiteral(resourceName: "icAdd-1")
            return cell
        }
        cell.photos.image = dataSource[indexPath.row - 1]
        return cell
    }
}

extension AccidentReportController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (myCollectionView.bounds.width - 20) / 3, height: myCollectionView.bounds.height)
    }
}

extension AccidentReportController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 2:
            textField.resignFirstResponder()
        default:
            textFieldCollection[textField.tag + 1].becomeFirstResponder()
            return true
        }
        return false
    }
}

extension AccidentReportController: removeCollectionCell {
    func didTapedButton(from cell: UICollectionViewCell) {
        let indexPath = myCollectionView.indexPath(for: cell)
        myCollectionView.deleteItems(at: [indexPath!])
        if indexPath!.row != 0 {
            dataSource.remove(at: indexPath!.row - 1)
        }
    }
}
