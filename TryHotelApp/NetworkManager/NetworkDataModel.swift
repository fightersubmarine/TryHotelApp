//
//  NetworkDataModel.swift
//  TryHotelApp
//
//  Created by Александр on 16.05.2024.
//

import Foundation

// MARK: - Model For Main Screen

struct Hotel: Codable { 
    let id: Int
    let name: String
    let address: String
    let stars: Float
    let distance: Float
    let suitesAvailability: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance, suitesAvailability = "suites_availability"
    }
}

// MARK: - Model For Hotel Screen

struct SelectHotel: Codable {
    let id: Int
    let name: String
    let address: String
    let stars: Double
    let distance: Double
    let image: String?
    let suites_availability: String
    let lat: Double
    let lon: Double
}
