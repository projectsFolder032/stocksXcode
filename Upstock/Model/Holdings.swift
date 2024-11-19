//
//  Holdings.swift
//  Upstock
//
//  Created by Nikita Arora on 17/11/24.
//

import Foundation

struct APIResponse: Decodable {
    let data: UserHoldings
}

struct UserHoldings: Decodable {
    let userHolding: [Holding]
}

struct Holding: Decodable {
    let symbol: String       // Stock symbol
    let quantity: Int        // Quantity of the stock
    let ltp: Double          // Last traded price
    let avgPrice: Double     // Average price
    let close: Double        // Closing price
}

