//
//  HotelScreenCoordinator.swift
//  TryHotelApp
//
//  Created by Александр on 23.05.2024.
//

import Foundation
import UIKit

protocol HotelScreenCoordinatorDelegate: AnyObject {
    func hotelScreenCoordinatorDidFinish(_ coordinator: HotelScreenCoordinator)
}

final class HotelScreenCoordinator: BaseCoordinator {
    private var navigationController: UINavigationController
    private let hotelID: Int
    weak var delegate: HotelScreenCoordinatorDelegate?
    
    init(navigationController: UINavigationController, hotelID: Int) {
        self.navigationController = navigationController
        self.hotelID = hotelID
    }
    
    override func start() {
        let viewModel = HotelScreenViewModel(hotelID: hotelID)
        let hotelViewController = HotelScreenViewController(viewModel: viewModel)
        hotelViewController.hotelScreenCoordinator = self
        hotelViewController.delegateHotelScreenCoordinator = self
        mediumScreenOpen(viewController: hotelViewController)
        navigationController.present(hotelViewController, animated: true, completion: nil)
    }

}

extension HotelScreenCoordinator: HotelScreenCoordinatorDelegate {
    func hotelScreenCoordinatorDidFinish(_ coordinator: HotelScreenCoordinator) {
        removeCoordinator(coordinator)
    }
}

private extension HotelScreenCoordinator {
    func mediumScreenOpen(viewController: UIViewController) {
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
    }
}

