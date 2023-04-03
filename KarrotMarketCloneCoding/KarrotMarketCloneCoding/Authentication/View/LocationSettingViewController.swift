//
//  LocationSettingViewController.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 3/21/23.
//

import UIKit
import MapKit



class LocationSettingViewController: UIViewController {
    
    // MARK: - Properties

    private let locationManager = CLLocationManager()
    private let mapView = MKMapView()
    
    private let logoImageView = UIImageView(image: UIImage(named: "location")?.withTintColor(.orange))
    
    private let currentLocationButton = UIButton()
    private let locationSelectButton = UIButton()
    
    private var locationAlias: String?
    private var currentLoaction: CLLocation? = CLLocation(latitude: 37.47622, longitude: 126.79563)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCurrentLocationButton()
        setLocationSelectButton()
        setLocationManager()
        setMapView()
        
        locationManagerRequestAuthorization()
        
        configureViews()
    }
    
    // MARK: - Actions
    
    // 현재 위치로 돌아가는 기능
    
    @objc private func back() {
        self.dismiss(animated: true)
    }
    
    @objc func setCurrentLocationAction() {
        guard let currentLocation = locationManager.location else { return }
        mapView.updateLocation(currentLocation)
    }
    
    @objc func saveLocationAndPushNextVC() {
        let clGeocoder = CLGeocoder()
        guard let location = currentLoaction else { return }
        clGeocoder.reverseGeocodeLocation(location) { [weak self] (placeMarks, error) in
            guard let place = placeMarks?.first else {
                return
            }
            let doubleLongitude: Double = location.coordinate.longitude
            let doubleLatitude: Double = location.coordinate.latitude
            
            let intLongitude = Int(doubleLongitude * 1_000_000.0.rounded())
            let intLatitude = Int(doubleLatitude * 1_000_000.0.rounded())
            guard let townName = place.subLocality else { return }
            let alias = self?.locationAlias ?? "내동네" // domb 회원가입에서도 필수입력값인지 나중에 확인해서 없애기.
            
            DispatchQueue.main.async {
                self?.pushNextVC(location: LocationInfo(latitude: intLatitude, longitude: intLongitude, townName: townName, alias: alias))
            }
        }
    }
    
    func pushNextVC(location: LocationInfo) {
        let nextVC = SignUpViewController()
        nextVC.userLocation = location
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setCurrentLocationButton() {
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
        
        locationSelectButton.addTarget(self, action: #selector(saveLocationAndPushNextVC), for: .touchUpInside)
    }
    
    private func setMapView() {
        mapView.delegate = self
        mapView.updateLocation(currentLoaction)
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = 1000
    }
    
    // MARK: - Configure
    
    private func configureViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        view.addSubview(locationSelectButton)
        
        mapView.addSubview(currentLocationButton)
        mapView.addSubview(logoImageView)
    
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 30, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        currentLocationButton.anchor(bottom: locationSelectButton.topAnchor, bottomConstant: 20, trailing: locationSelectButton.trailingAnchor, width: 50, height: 50)
        
        logoImageView.centerXY(inView: mapView)
        logoImageView.anchor(width: 40, height: 40)
        
        locationSelectButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: 20, leading: view.safeAreaLayoutGuide.leadingAnchor, leadingConstant: 20, trailing: view.safeAreaLayoutGuide.trailingAnchor, trailingConstant: 20, height: 50)
    }
}

// MARK: - MKMapViewDelegate

extension LocationSettingViewController: MKMapViewDelegate {
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        self.currentLoaction = location
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationSettingViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            // 권한이 거절됐을 때 처리할 내용을 작성합니다.
            mapView.updateLocation(currentLoaction)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        } else {
            mapView.updateLocation(currentLoaction)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerRequestAuthorization() {
        // 사용자에게 동의 구함.
        locationManager.requestWhenInUseAuthorization()
    }
}
