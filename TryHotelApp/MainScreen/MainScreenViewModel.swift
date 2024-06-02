//
//  MainScreenViewModel.swift
//  TryHotelApp
//
//  Created by Александр on 16.05.2024.
//

import Foundation
import RxSwift
import RxCocoa

 // MARK: - Enum for sort hotel

enum SortOption {
    case base
    case distance
    case place
    
    func sortHotels(_ hotels: [MainScreenModel]) -> [MainScreenModel] {
        switch self {
        case .base:
            return hotels
        case .distance:
            return hotels.sorted { $0.distance < $1.distance }
        case .place:
            return hotels.sorted { $0.formattedSuitesAvailability > $1.formattedSuitesAvailability }
        }
    }
}

final class MainScreenViewModel {
    
    // MARK: - Properties
    let networkManager = NetworkManager()
    private let disposeBag = DisposeBag()
    var hotels = BehaviorRelay<[MainScreenModel]>(value: [])
    private var sortOption: SortOption = .base
    
    // MARK: - Work with data

    func fetchData() {
        networkManager.fetchData()
            .subscribe(onNext: { [weak self] hotels in
                self?.convertAndSetHotelData(hotels)
            }, onError: { error in
                print("Error fetching data: \(error)")
            })
            .disposed(by: disposeBag)
    }

    private func convertAndSetHotelData(_ hotels: [Hotel]) {
        var mainScreenModels = hotels.map { MainScreenModel(hotel: $0) }
        mainScreenModels = sortOption.sortHotels(mainScreenModels)
        self.hotels.accept(mainScreenModels)
    }

    func setSortOption(_ option: SortOption) {
        sortOption = option
        fetchData()
    }
}
