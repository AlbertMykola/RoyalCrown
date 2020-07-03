//
//  MapViewController.swift
//  Royal Crown
//
//  Created by Albert on 25.06.2020.
//  Copyright © 2020 Albert Mykola. All rights reserved.
//

import UIKit
import GoogleMaps


final class MapViewController: UIViewController {
    
    //MARK: - IBOtlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var myView: UIView!
    @IBOutlet weak private var phoneLabel: UILabel!
    @IBOutlet weak private var faxLabel: UILabel!
    @IBOutlet weak private var longitude: UILabel!
    @IBOutlet weak private var latitude: UILabel!
    @IBOutlet weak private var buttonOutlet: UIButton!
    @IBOutlet var constraintLabels: [NSLayoutConstraint]!
    @IBOutlet weak var heightMyView: NSLayoutConstraint!
    
    //MARK: - Variable
    private var camera: GMSCameraPosition?
    private var mapView: GMSMapView?
    private var open = false
    var dataSource: [Branches]?
    private var markerSelect: GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMarkersAndMap()
        DataManager.shared.createImageToNavigationBar(navigationController: navigationController!, navigationItem: navigationItem, text: "Branches")
    }
    
    //MARK: - IBAction
    @IBAction func openClosed(_ sender: UIButton) {
        open = !open
        loadViewIfNeeded()
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            if self.open {
            self.heightMyView.constant = 250.0
                self.buttonOutlet.setImage(#imageLiteral(resourceName: "icArrowDown"), for: .normal)
            for i in self.constraintLabels {
                i.constant = 20
            }
                self.view.layoutIfNeeded()
        } else {
                self.heightMyView.constant = 100.0
                self.buttonOutlet.setImage(#imageLiteral(resourceName: "icArrowUp"), for: .normal)
            for i in self.constraintLabels {
                i.constant = 0
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func createMarkersAndMap() {
        GMSServices.provideAPIKey("AIzaSyBNCtR2CHPG2Wg02TAMIQcihggFdidwvdU")
        guard let dataSource = dataSource else { return }
        camera = GMSCameraPosition.camera(withLatitude: dataSource.first?.latitude ?? 0.0, longitude: dataSource.first?.longitude ?? 0.0, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: CGRect(x:0, y:0, width: self.view.bounds.width, height: view.bounds.height), camera: camera!)
        mapView!.delegate = self
        view.addSubview(mapView!)
        mapView?.addSubview(myView)
        for value in dataSource {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: value.latitude!, longitude: value.longitude!)
            marker.title = value.title
            marker.snippet = value.address
            titleLabel.text = value.title
            addressLabel.text = value.address
            marker.icon = UIImage(named: "icPinPassive")
            marker.map = self.mapView
        }
    }
    
    private func addInfo(title: String) {
        for i in dataSource! {
            if i.title == title {
                phoneLabel.text = "phone: \(i.phone ?? "")"
                faxLabel.text = "fax: \(i.fax ?? "")"
                longitude.text = "longitude: \(i.longitude ?? 0.0)"
                latitude.text = "latitude: \(i.latitude ?? 0.0)"
            }
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        myView.isHidden = false
        titleLabel.text = marker.title
        addressLabel.text = marker.snippet
        addInfo(title: marker.title ?? "")
        markerSelect?.icon = UIImage(named: "icPinPassive")
        marker.icon = UIImage(named: "icPinActive")
        markerSelect = marker
        return true
    }
}



