//
//  HotelScreenViewController.swift
//  TryHotelApp
//
//  Created by Александр on 23.05.2024.
//

import UIKit
import RxSwift
import MapKit


final class HotelScreenViewController: UIViewController {

// MARK: - Properties
    
    weak var hotelScreenCoordinator: HotelScreenCoordinator?
    weak var delegateHotelScreenCoordinator: HotelScreenCoordinatorDelegate?
    private let viewModel: HotelScreenViewModel
    private let disposeBag = DisposeBag()
        
    lazy var nameLabel: UILabel = {
        let label = labelForHotelScreen.customLabelForHotelScreen(text: "")
        label.textAlignment = .center
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = labelForHotelScreen.customLabelForHotelScreen(text: "")
        return label
    }()
    
    lazy var starsLabel: UILabel = {
        let label = labelForHotelScreen.customLabelForHotelScreen(text: "")
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = labelForHotelScreen.customLabelForHotelScreen(text: "")
        return label
    }()
    
    lazy var suitesLabel: UILabel = {
        let label = labelForHotelScreen.customLabelForHotelScreen(text: "")
        return label
    }()
        
    lazy var hotelImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var mapForHotelLocation: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        var activity = UIActivityIndicatorView.customActivityIndicator()
        return activity
    }()
        
// MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        bindUILabel()
        bindImage()
        bindMapView()
    }
    
    init(viewModel: HotelScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent || self.isBeingDismissed {
            delegateHotelScreenCoordinator?.hotelScreenCoordinatorDidFinish(hotelScreenCoordinator!)
        }
    }
}

// MARK: - UI  Configuration

private extension HotelScreenViewController {
    
    func setupView() {
        view.backgroundColor = .white
    }
    
    func setupHierarchy() {
        view.addSubview(nameLabel)
        view.addSubview(addressLabel)
        view.addSubview(starsLabel)
        view.addSubview(distanceLabel)
        view.addSubview(suitesLabel)
        view.addSubview(hotelImage)
        view.addSubview(mapForHotelLocation)
        hotelImage.addSubview(activityIndicator)
    }
    
    func setupLayout() {
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constraint.constant20)
            $0.leading.trailing.equalToSuperview().inset(Constraint.constant12)
        }
        
        hotelImage.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(Constraint.constant12)
            $0.leading.trailing.equalToSuperview().inset(Constraint.constant12)
            $0.height.equalTo(Constraint.constant220)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(hotelImage.snp.bottom).offset(Constraint.constant12)
            $0.leading.trailing.equalToSuperview().inset(Constraint.constant12)
        }
        
        starsLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(Constraint.constant12)
            $0.leading.trailing.equalToSuperview().inset(Constraint.constant12)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.top.equalTo(starsLabel.snp.bottom).offset(Constraint.constant12)
            $0.leading.trailing.equalToSuperview().inset(Constraint.constant12)
        }
        
        suitesLabel.snp.makeConstraints {
            $0.top.equalTo(distanceLabel.snp.bottom).offset(Constraint.constant12)
            $0.leading.trailing.equalToSuperview().inset(Constraint.constant12)
        }
        
        mapForHotelLocation.snp.makeConstraints {
            $0.top.equalTo(suitesLabel.snp.bottom).offset(Constraint.constant12)
            $0.leading.trailing.equalToSuperview().inset(Constraint.constant12)
            $0.height.equalTo(Constraint.constant192)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Bind UI func
    
    func bindUILabel() {
        viewModel.hotelData
            .subscribe(onNext: { [weak self] hotelScreenModel in
                self?.nameLabel.text = hotelScreenModel.name
                self?.addressLabel.text = hotelScreenModel.address
                self?.starsLabel.text = "Stars: \(hotelScreenModel.stars)"
                self?.distanceLabel.text = "Distance: \(hotelScreenModel.distance) km"
                self?.suitesLabel.text = "Suites: \(hotelScreenModel.formattedSuitesAvailability)"
            }, onError: { error in
                print("Error fetching hotel data: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func bindImage() {
        viewModel.hotelData
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] hotelScreenModel in
                guard let self = self else { return }

                guard let imageUrl = hotelScreenModel.imageUrl else {
                    self.setPlaceholderImage()
                    return
                }
                
                self.activityIndicator.startAnimating()

                self.viewModel.loadImage(from: imageUrl) { [weak self] croppedImage in
                    guard let self = self else { return }
                    
                    self.activityIndicator.stopAnimating()

                    if let croppedImage = croppedImage {
                        self.hotelImage.image = croppedImage
                    } else {
                        self.setPlaceholderImage()
                    }
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                print("Error fetching hotel data: \(error)")
                self.setPlaceholderImage()
                self.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
    
    func bindMapView() {
        viewModel.hotelData
            .subscribe(onNext: { [weak self] hotelScreenModel in
                guard let self = self else { return }
                self.updateMap(with: hotelScreenModel)
            })
            .disposed(by: disposeBag)
    }

    func updateMap(with hotel: HotelScreenModel) {
        clearAnnotations()
        let mapData = viewModel.mapData(for: hotel)
        mapForHotelLocation.addAnnotation(mapData.annotation)
        mapForHotelLocation.setRegion(mapData.region, animated: true)
    }
    
    func clearAnnotations() {
        let annotations = mapForHotelLocation.annotations
        mapForHotelLocation.removeAnnotations(annotations)
    }

    func setPlaceholderImage() {
        self.hotelImage.image = UIImage(systemName: "exclamationmark.triangle")?.withRenderingMode(.alwaysTemplate)
        self.hotelImage.tintColor = .red
    }

}

