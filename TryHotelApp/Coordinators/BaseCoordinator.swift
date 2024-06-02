//
//  BaseCoordinator.swift
//  TryHotelApp
//
//  Created by Александр on 16.05.2024.
//

import Foundation

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func start() {
        fatalError("Child should implement funcStart")
    }
    
    func removeCoordinator(_ coordinator: Coordinator) {
        remove(coordinator: coordinator)
    }
}
