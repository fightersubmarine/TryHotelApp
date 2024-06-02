//
//  HotelScreenModel.swift
//  TryHotelApp
//
//  Created by Александр on 23.05.2024.
//

import Foundation

struct HotelScreenModel {
    let id: Int
    let name: String
    let address: String
    let stars: Double
    let distance: Double
    let image: String?
    let suites_availability: String
    let lat: Double
    let lon: Double

    init(selectHotel: SelectHotel) {
        self.id = selectHotel.id
        self.name = selectHotel.name
        self.address = selectHotel.address
        self.stars = selectHotel.stars
        self.distance = selectHotel.distance
        self.image = selectHotel.image
        self.suites_availability = selectHotel.suites_availability
        self.lat = selectHotel.lat
        self.lon = selectHotel.lon
    }
}

extension HotelScreenModel {
    var formattedSuitesAvailability: Int {
        suites_availability.components(separatedBy: ",").count
    }
    
    var imageUrl: URL? {
        guard let image = image else { return nil }
        return URL(string: "https://raw.githubusercontent.com/fightersubmarine/TryHotelApi/main/image/\(image)")
    }
}
