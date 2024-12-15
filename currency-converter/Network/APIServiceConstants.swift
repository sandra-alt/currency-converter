//
//  APIServiceConstants.swift
//  currency-converter
//
//  Created by  Oleksandra on 15.12.2024.
//

import Foundation

enum APIServiceConstants {
    // MARK: - Base URL
    static let baseURL = "http://api.evp.lt"
    
    // MARK: - Currency exchange
    
    /// Generates the path for currency conversion
    /// - Parameters:
    ///   - fromAmount: The amount to convert
    ///   - fromCurrency: The source currency
    ///   - toCurrency: The target currency
    /// - Returns: Formatted path for currency exchange
    static func exchangePath(fromAmount: String, fromCurrency: String, toCurrency: String) -> String {
        "/currency/commercial/exchange/\(fromAmount)-\(fromCurrency)/\(toCurrency)/latest"
    }
}
