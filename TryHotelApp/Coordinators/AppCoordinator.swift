//
//  AppCoordinator.swift
//  TryHotelApp
//
//  Created by Александр on 16.05.2024.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    
    private var window: UIWindow
    
    private var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    override func start() {
        let mainScreenCoordinator = MainScreenCoordinator(navigationController: navigationController)
        add(coordinator: mainScreenCoordinator)
        mainScreenCoordinator.start()
    }
    
}
