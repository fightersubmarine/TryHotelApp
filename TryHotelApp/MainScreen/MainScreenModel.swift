//
//  MainScreenModel.swift
//  TryHotelApp
//
//  Created by Александр on 16.05.2024.
//

import Foundation

struct MainScreenModel {
    let id: Int
    let name: String
    let address: String
    let stars: Float
    let distance: Float
    let suitesAvailability: String
    
    init(hotel: Hotel) {
        self.id = hotel.id
        self.name = hotel.name
        self.address = hotel.address
        self.stars = hotel.stars
        self.distance = hotel.distance
        self.suitesAvailability = hotel.suitesAvailability
    }
}


extension MainScreenModel {
    var formattedSuitesAvailability: Int {
        suitesAvailability.components(separatedBy: ",").count
    }
}
