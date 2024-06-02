//
//  MainScreenCoordinator.swift
//  TryHotelApp
//
//  Created by Александр on 16.05.2024.
//

import Foundation

protocol MainScreenCoordinatorDelegate: AnyObject {
    func runHotelScreen(with hotelID: Int)
}

import UIKit

final class MainScreenCoordinator: BaseCoordinator {
    private var navigationController: UINavigationController
    weak var delegate: MainScreenCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let mainViewController = MainScreenViewController()
        mainViewController.delegateMainScreenCoordinator = self
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
}

extension MainScreenCoordinator: MainScreenCoordinatorDelegate {
    
    func runHotelScreen(with hotelID: Int) {
        let hotelScreenCoordinator = HotelScreenCoordinator(navigationController: navigationController, hotelID: hotelID)
        add(coordinator: hotelScreenCoordinator)
        hotelScreenCoordinator.start()
    }
}

extension MainScreenCoordinator: HotelScreenCoordinatorDelegate {
    func hotelScreenCoordinatorDidFinish(_ coordinator: HotelScreenCoordinator) {
        removeCoordinator(coordinator)
    }
}
