//
//  ConverterRouter.swift
//  currency-converter
//
//  Created by  Oleksandra on 15.12.2024.
//

import Foundation

// Router for currency conversion network requests
enum ConverterRouter: URLRequestConvertible {
    
    // Specific cases for exchange request, can be extended
    case exchange(model: ConverterRequestModel)
    
    var path: String {
        switch self {
        case .exchange(let model):
            return APIServiceConstants.exchangePath(fromAmount: model.fromAmount, fromCurrency: model.fromCurrency, toCurrency: model.toCurrency)
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .exchange:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .exchange:
            return .request
        }
    }
}
