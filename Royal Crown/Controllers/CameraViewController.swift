//
//  CameraViewController.swift
//  Royal Crown
//
//  Created by Albert on 26.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//



import UIKit
import AVFoundation


final class CameraViewController: UIViewController, UINavigationControllerDelegate {
    
    enum Position {
        case front
        case back
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak private var previewView: UIView!
    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak var addImage: UIImageView!
    
    //MARK: - Variable
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    private var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    private var capturePhotoOutput: AVCapturePhotoOutput?
    private var photosArray = [UIImage]()
    private var flash: AVCaptureDevice.FlashMode? = .off
    private var boldButton = UIButton()
    private var imagePicker = UIImagePickerController()
    
    //MARK: - live cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        imageTintColor(button: rotateButton)
        createdCamera()
        addCustomNavBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PhotoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionCell")
    }
    
    //MARK: - Private functions
    func createdCamera() {
        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        do {
            guard let captureDevice = captureDevice else { return }
            let input = try AVCaptureDeviceInput(device: captureDevice)
            self.captureSession = AVCaptureSession()
            
            captureSession?.addInput(input)
            guard let captureSession = captureSession else { return }
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            guard let videoPreviewLayer = videoPreviewLayer else { return }
            videoPreviewLayer.frame = view.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer)
            captureSession.startRunning()
        } catch {
        }
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        captureSession?.addOutput(capturePhotoOutput!)
    }
    
    private func imageTintColor(button: UIButton) {
        let image = button.imageView?.image?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.tintColor = .white
    }
    
    private func addCustomNavBar() {
        let container = UIView(frame: CGRect(x: navigationController!.navigationBar.center.x, y: navigationController!.navigationBar.center.y, width: 50, height: 40))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icBack"), style: .done, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DONE", style: .done, target: self, action: #selector(savePhoto))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        boldButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        boldButton.setImage(#imageLiteral(resourceName: "flash-off"), for: .normal)
        boldButton.contentMode = .scaleAspectFit
        boldButton.addTarget(self, action: #selector(torchSwitch), for: .touchUpInside)
        imageTintColor(button: boldButton)
        container.addSubview(boldButton)
        navigationItem.titleView = container
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func camera(position: AVCaptureDevice?, side: Position) {
        let captureDevice: AVCaptureDevice?
        if position?.isConnected == true {
            captureSession?.stopRunning()
            if side == .back {
                captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            } else {
                captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            }
            do {
                guard let captureDevice = captureDevice else { return }
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                guard let captureSession = captureSession else { return }
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                guard let videoPreviewLayer = videoPreviewLayer else { return }
                videoPreviewLayer.frame = view.layer.bounds
                previewView.layer.addSublayer(videoPreviewLayer)
                captureSession.startRunning()
            } catch {
            }
            capturePhotoOutput = AVCapturePhotoOutput()
            guard let capturePhotoOutput = capturePhotoOutput else { return }
            capturePhotoOutput.isHighResolutionCaptureEnabled = true
            captureSession?.addOutput(capturePhotoOutput)
        }
    }
    
    @objc private func savePhoto() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AccidentReportController") as! AccidentReportController
        vc.dataSource = photosArray
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func torchSwitch(_ sender: Any) {
        if flash == AVCaptureDevice.FlashMode.off {
            boldButton.setImage(#imageLiteral(resourceName: "boldWhite"), for: .normal)
            imageTintColor(button: boldButton)
            flash = .on
        } else {
            boldButton.setImage(#imageLiteral(resourceName: "flash-off"), for: .normal)
           imageTintColor(button: boldButton)
            flash = .off
        }
        
        guard let device = backCamera else { return }
        guard device.isTorchAvailable else { return }
        do {
            try device.lockForConfiguration()
            if device.torchMode == .on {
                try device.setTorchModeOn(level: 0.7)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    //MARK: - IBAction
    @IBAction func didTakePhoto(_ sender: UIButton!) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = flash!
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @IBAction func rotateCamera(_ sender: UIButton!) {
        guard let currentCamera: AVCaptureInput  = captureSession?.inputs.first else { return }
        if let input = currentCamera as? AVCaptureDeviceInput {
            if input.device.position == .back {
                camera(position: frontCamera, side: .front)
            }
            if input.device.position == .front {
                camera(position: backCamera, side: .back)
            }
        }
    }
}

//MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {return}
        guard let imageData = photo.fileDataRepresentation() else {return}
        let captureImage = UIImage.init(data: imageData, scale: 1.0)
        if let image = captureImage {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            photosArray.insert(image, at: 0)
            photoImageView.image = image
            collectionView.reloadData()
        }
    }
}

//MARK: - UICollectionViewDataSource
extension CameraViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photosArray.count == 0 {
            return 1
        } else {
            return photosArray.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionCell
        
        if indexPath.row == 0 {
            cell.deleteButton.isHidden = true
            cell.addLabel.isHidden = false
            cell.photos.image = UIImage(named: "placeholder")
            return cell
        }
        let photo = photosArray[indexPath.row - 1]
        cell.photos.image = photo
        cell.deleteButton.isHidden = true
        cell.addLabel.isHidden = true
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension CameraViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension CameraViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.collectionView.frame.width / 6, height: collectionView.frame.height)
    }
}

extension CameraViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        photosArray.insert(photo, at: 0)
        picker.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}
