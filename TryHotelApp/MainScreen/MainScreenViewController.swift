//
//  ViewController.swift
//  TryHotelApp
//
//  Created by Александр on 16.05.2024.
//

import UIKit
import SnapKit
import RxSwift

private enum MainScreenViewControllerStrings {
    static let topTitle = "Hotels"
    static let distanceString = "Sort by distance"
    static let placeString = "Sort by free place"
    static let idCell = "CollectionViewCellID"
    static let defaultCellID = "DefaultCellID"
}

private extension CGFloat {
    static let minimumLineSpacing: CGFloat = 12
}

private extension CGSize {
    static let cellLayoutSize = CGSize(width: 360, height: 320)
}

final class MainScreenViewController: UIViewController {

// MARK: - Properties
    
    weak var delegateMainScreenCoordinator: MainScreenCoordinatorDelegate?
    private let viewModel = MainScreenViewModel()
    private let disposeBag = DisposeBag()
        
    lazy var hotelCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: hotelCollectionViewLayout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(HotelCollectionViewCell.self,
                            forCellWithReuseIdentifier: MainScreenViewControllerStrings.idCell)
        collection.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: MainScreenViewControllerStrings.defaultCellID)
        return collection
    }()
    
    lazy var hotelCollectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = CGFloat.minimumLineSpacing
        return layout
    }()
    
    lazy var buttonForSortByDistance: UIButton = {
        let button = UIButton.customSortButton(title: MainScreenViewControllerStrings.distanceString)
        return button
    }()
    
    lazy var buttonForSortByPlace: UIButton = {
        let button = UIButton.customSortButton(title: MainScreenViewControllerStrings.placeString)
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        var activity = UIActivityIndicatorView.customActivityIndicator()
        return activity
    }()
    
// MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setSortOption(.base)
        setupView()
        navigationBarStile()
        setupHierarchy()
        setupLayout()
        bindViewModel()
        bindSortByPlaceButton()
        bindSortByDistanceButton()
    }
        
}

// MARK: - UI  Configuration

private extension MainScreenViewController {
    
    func setupView() {
        view.backgroundColor = .white
    }
    
    func setupHierarchy() {
        view.addSubview(hotelCollectionView)
        view.addSubview(buttonForSortByDistance)
        view.addSubview(buttonForSortByPlace)
        hotelCollectionView.addSubview(activityIndicator)
    }
    
    func setupLayout() {
        
        buttonForSortByDistance.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constraint.constant12)
            $0.leading.equalToSuperview().offset(Constraint.constant12)
            $0.trailing.equalTo(view.snp.centerX)
            $0.height.equalTo(Constraint.constant36)
        }
        
        buttonForSortByPlace.snp.makeConstraints {
            $0.centerY.equalTo(buttonForSortByDistance)
            $0.trailing.equalToSuperview().inset(Constraint.constant12)
            $0.leading.equalTo(buttonForSortByDistance.snp.trailing).offset(Constraint.constant8)
            $0.height.equalTo(Constraint.constant36)
        }
        
        
        hotelCollectionView.snp.makeConstraints {
            $0.top.equalTo(buttonForSortByDistance.snp.bottom).offset(Constraint.constant8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
    }
    
    func navigationBarStile() {
        navigationController?.navigationBar.topItem?.title = MainScreenViewControllerStrings.topTitle
    }
    
    
    // MARK: - Bind UI
    
    func bindViewModel() {
        viewModel.hotels
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.hotelCollectionView.reloadData()
                self?.activityIndicator.stopAnimating()
    
            }, onCompleted: { [weak self] in
                self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        self.activityIndicator.startAnimating()
    }

    
    func bindSortByPlaceButton() {
        buttonForSortByPlace.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tapOnButtonAnimation(button: self.buttonForSortByPlace)
                self.viewModel.setSortOption(.place)
            })
            .disposed(by: disposeBag)
    }
    
    func bindSortByDistanceButton() {
        buttonForSortByDistance.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tapOnButtonAnimation(button: self.buttonForSortByDistance)
                self.viewModel.setSortOption(.distance)
            })
            .disposed(by: disposeBag)
    }
    
    func tapOnButtonAnimation(button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.layer.borderColor = UIColor.borderColorButtonPress.cgColor
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                button.layer.borderColor = UIColor.borderColor.cgColor
            })
        })
    }
    
}

// MARK: - Extension for UICollectionViewDataSource, UICollectionViewDelegate

extension MainScreenViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hotels.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScreenViewControllerStrings.idCell, for: indexPath) as? HotelCollectionViewCell else {
            return UICollectionViewCell()
        }
        let hotel = viewModel.hotels.value[indexPath.item]
        cell.configure(with: hotel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let hotel = viewModel.hotels.value[indexPath.item]
        delegateMainScreenCoordinator?.runHotelScreen(with: hotel.id)
    }
}


// MARK: - Extension for UICollectionViewDelegateFlowLayout

extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.cellLayoutSize
    }
}



