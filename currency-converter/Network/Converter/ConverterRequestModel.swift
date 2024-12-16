//
//  ConverterRequestModel.swift
//  currency-converter
//
//  Created by  Oleksandra on 15.12.2024.
//

import Foundation

struct ConverterRequestModel: Codable {
    let fromAmount: String
    let fromCurrency: String
    let toCurrency: String
}
