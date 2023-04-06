//
//  MapViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/21/23.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    var locationIsSelctedAction: (LocationInfo) -> Void = { Location in }

    private let locationManager = CLLocationManager()
    private let mapView = MKMapView()
    
    private let dismissButton = UIButton()
    private let descriptionLabel = UILabel()
    private let logoImageView = UIImageView(image: UIImage(named: "location")?.withTintColor(.orange))
    
    private let currentLocationButton = UIButton()
    private let locationSelectButton = UIButton()
    
    private var locationAlias: String?
    private var initialLocation = CLLocation(latitude: 37.47622, longitude: 126.79563)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDismissButton()
        setDescriptionLabel()
        setCurrentLocatoinButton()
        setLocationSelectButton()
        setLocationManager()
        setMapView()
        setNotification()
        
        locationManagerRequestAuthorization()
        
        configureViews()
    }
    
    // MARK: - Actions
    
    // 현재 위치로 돌아가는 기능
    
    @objc private func back() {
        self.dismiss(animated: true)
    }
    
    @objc private func updateLocationInfo(_ notification: Notification) {
        let clGeocoder = CLGeocoder()
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        clGeocoder.reverseGeocodeLocation(location) { [weak self] (placeMarks, error) in
            guard let place = placeMarks?.first else {
                return
            }
            let doubleLongitude: Double = location.coordinate.longitude
            let doubleLatitude: Double = location.coordinate.latitude
            
            let intLongitude = Int(doubleLongitude * 1_000_000.0.rounded())
            let intLatitude = Int(doubleLatitude * 1_000_000.0.rounded())
            guard let townName = place.subLocality else { return }
            guard let alias = self?.locationAlias else { return }
            
            let locationInfo = LocationInfo(latitude: intLatitude, longitude: intLongitude, townName: townName, alias: alias)
            self?.locationIsSelctedAction(locationInfo)
        }
        self.dismiss(animated: true)
    }
    
    
    @objc func setCurrentLocationAction() {
        guard let currentLocation = locationManager.location else { return }
        mapView.updateLocation(currentLocation)
    }
    
    @objc func inputLocationAlias() {
        let bottomSheetVC = BottomSheetViewController()
        
        bottomSheetVC.doneButtonAction = { [weak self] alias in
            self?.locationAlias = alias
            self?.dismiss(animated: true) {
                NotificationCenter.default.post(name: .updateLocationInfo, object: nil)
            }
        }
        
        if let sheet = bottomSheetVC.sheetPresentationController {
            
            if #available(iOS 16.0, *) {
                sheet.detents = [ .custom { _ in return 300 } ]
                
            } else {
                // Fallback on earlier versions
            }
            
            sheet.preferredCornerRadius = 20
        }
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
    private func setDismissButton() {
        dismissButton.setImage(UIImage(named: "close")?.resizableImage(withCapInsets: .zero), for: .normal)
        dismissButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        dismissButton.tintColor = .black
    }
    
    private func setDescriptionLabel() {
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        descriptionLabel.text = "이웃과 만나서\n거래하고 싶은 장소를 선택해주세요."
    }
    
    private func setCurrentLocatoinButton() {
        currentLocationButton.setImage(UIImage(named: "aim")?.withTintColor(.white), for: .normal)
        currentLocationButton.backgroundColor = .black
        currentLocationButton.layer.cornerRadius = 50 / 2
        currentLocationButton.clipsToBounds = true
        currentLocationButton.addTarget(self, action: #selector(setCurrentLocationAction), for: .touchUpInside)
    }
    
    private func setLocationSelectButton() {
        locationSelectButton.setTitle("선택 완료", for: .normal)
        locationSelectButton.backgroundColor = .orange
        locationSelectButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        locationSelectButton.layer.cornerRadius = 8
        locationSelectButton.clipsToBounds = true
        
        locationSelectButton.addTarget(self, action: #selector(inputLocationAlias), for: .touchUpInside)
    }
    
    private func setMapView() {
        mapView.delegate = self
        mapView.updateLocation(initialLocation)
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocationInfo), name: .updateLocationInfo, object: nil)
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        view.addSubview(dismissButton)
        view.addSubview(descriptionLabel)
        view.addSubview(locationSelectButton)
        
        mapView.addSubview(currentLocationButton)
        mapView.addSubview(logoImageView)
        
        dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 10, leading: view.safeAreaLayoutGuide.leadingAnchor, leadingConstant: 10, width: 40, height: 40)
        
        descriptionLabel.anchor(top: dismissButton.bottomAnchor, topConstant: 20, leading: view.safeAreaLayoutGuide.leadingAnchor, leadingConstant: 10)
        
        mapView.anchor(top: descriptionLabel.bottomAnchor, topConstant: 30, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        currentLocationButton.anchor(bottom: locationSelectButton.topAnchor, bottomConstant: 20, trailing: locationSelectButton.trailingAnchor, width: 50, height: 50)
        
        logoImageView.centerXY(inView: mapView)
        logoImageView.anchor(width: 40, height: 40)
        
        locationSelectButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 20, leading: view.safeAreaLayoutGuide.leadingAnchor, leadingConstant: 20, trailing: view.safeAreaLayoutGuide.trailingAnchor, trailingConstant: 20, height: 50)
    }
}

// MARK: - MKMapView

extension MKMapView {
    
    func updateLocation(_ location: CLLocation?, regionRadius: CLLocationDistance = 1000) {
        guard let location = location else { return }
    
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        setRegion(coordinateRegion, animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            // 권한이 거절됐을 때 처리할 내용을 작성합니다.
            mapView.updateLocation(initialLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManagerRequestAuthorization() {
        // 사용자에게 동의 구함.
        locationManager.requestWhenInUseAuthorization()
    }
}
