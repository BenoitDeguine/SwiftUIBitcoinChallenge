//
//  Model.swift
//  BitcoinChallenge
//
//  Created by Benoit on 17/01/2021.
//

import Foundation

struct Response: Codable {
    let time: CustomTime
    let disclaimer: String
    let chartName: String
    let bpi: Bpi
}

struct CustomTime: Codable {
    let updated: String
    let updateduk: String
}

struct Bpi: Codable {
    let usd: Eur
    let gbp: Eur
    let eur: Eur
    
    private enum CodingKeys : String, CodingKey {
        case usd = "USD", gbp = "GBP",eur = "EUR"
    }
}

struct Eur: Codable {
    let code: String
    let symbol: String
    let rate: String
    var eurDescription: String
    let rateFloat: Double
    
    private enum CodingKeys : String, CodingKey {
        case code, symbol,rate, eurDescription = "description", rateFloat = "rate_float"
    }
}

struct Time: Codable {
    let updated: String
    let updatediso: Date
    let updateduk: String
}
