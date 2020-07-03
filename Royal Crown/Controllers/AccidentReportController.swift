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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet weak private var myCollectionView: UICollectionView!
    @IBOutlet weak private var reportButton: UIButton!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var telNumTextField: UITextField!
    @IBOutlet weak var regNumTextField: UITextField!
    @IBOutlet weak var countTellNum: UILabel!
    @IBOutlet weak var indicatorView: UICollectionView!
    
    //MARK: - Variable
    var dataSource = [UIImage]()
    var border = CALayer()
    var switchValue = true
    var count = 0
    let url = "http://31.131.21.105:82/api/v1/accident_reports"
    
    //MARK: Live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.createImageToNavigationBar(navigationController: self.navigationController!, navigationItem: navigationItem, text: "Accident report")
        addCollectionCell()
        nameTextField.delegate = self
        telNumTextField.delegate = self
        regNumTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textFieldBorderColor(textField: nameTextField)
        textFieldBorderColor(textField: telNumTextField)
        textFieldBorderColor(textField: regNumTextField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
    
    //MARK: - Private func
    private func textFieldBorderColor(textField: UITextField) {
        if textField.text?.count ?? 0 < 1 {
            self.emphasis(textField: textField, color: UIColor.lightGray.cgColor)
        } else {
            self.emphasis(textField: textField, color: UIColor.purple.cgColor)
        }
    }

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
    
    func message(_ text: Message) {
        activityIndicator.isHidden = true
        var string = ""
        if let message = text.message {
            self.messageLabel.text = message
            self.backRootController()
        } else {
            guard let error = text.errors else { return }
            for i in error {
                string  += i
            }
            self.messageLabel.text = string
            self.messageLabel.backgroundColor = .red
            self.backRootController()
        }
    }
    
    private func postRequest(url: URL, param: [String: String]) {
        DispatchQueue.main.async {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json;", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: param, options: []) else {return}
            request.httpBody = httpBody
            NetworkService.shared.postRequest(request: request) { (results) in
                switch results {
                case .success(let result):
                    do {
                        let json = try JSONDecoder().decode(Message.self, from: result)
                        self.message(json)
                        self.messageLabel.isHidden = false
                    } catch {
                    }
                case .failure(_): break
                }
            }
        }
    }

    @IBAction func didChangeSwitch(_ sender: UISwitch!) {
        switchValue = sender.isOn
        if sender.isOn {
        reportButton.isEnabled = true
        reportButton.alpha = 1.0
        } else {
            reportButton.isEnabled = false
            reportButton.alpha = 0.6
        }
    }
    
    @IBAction func report(_ sender: UIButton!) {
        activityIndicator.isHidden = false
        
        let encodedImages = dataSource.compactMap({ $0.pngData()?.base64EncodedString() })
        let param = ["name": "\(nameTextField.text ?? "")" , "reg_policy_number": "\(regNumTextField.text ?? "")", "phone_number": "\(regNumTextField.text ?? "")", "photos_attributes": "\(encodedImages)"]
        guard let url = URL(string: "http://31.131.21.105:82/api/v1/accident_reports") else {return}
        self.postRequest(url: url, param: param)
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
            cell.isHidden = false
            cell.deleteButton.isHidden = true
            cell.photos.contentMode = .scaleAspectFit
            cell.photos.image = #imageLiteral(resourceName: "icAdd")
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
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch textField.tag {
        case 2:
                if  textField.text!.count <= 8 {
                    self.countTellNum.isHidden = false
                } else {
                    self.countTellNum.isHidden = true
                }
        default:
            break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case nameTextField:
            regNumTextField.becomeFirstResponder()
        case regNumTextField:
            telNumTextField.becomeFirstResponder()
        case telNumTextField:
            textField.resignFirstResponder()
        default:
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

extension UIView {
    
    
}
