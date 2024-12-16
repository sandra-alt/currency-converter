//
//  NetworkError.swift
//  currency-converter
//
//  Created by  Oleksandra on 15.12.2024.
//

import Foundation

// Potential errors that can occur during network operations
enum NetworkError: Error {
    case invalidURL // constructed URL is invalid
    case requestFailed(statusCode: Int) // failed network request with a specific HTTP status code
    case invalidResponse
    case invalidData // received data could not be decoded
    
    var errorInfo: String {
        switch self {
        case .invalidURL:
            return "Please check your data and try again"
        case .requestFailed(let code):
            return "Conversion failed with error code \(code). Please try again"
        default:
            return self.localizedDescription
        }
    }
}
