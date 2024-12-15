//
//  ConverterNetworkService.swift
//  currency-converter
//
//  Created by  Oleksandra on 15.12.2024.
//

import Foundation

protocol ConverterNetworkServiceProtocol {
    /// Performs currency exchange
    /// - Parameter model: The conversion request model
    /// - Returns: The conversion response model
    /// - Throws: Network-related errors
    func exchange(model: ConverterRequestModel) async throws -> ConverterResponseModel
}

// Concrete implementation of the converter network service
class ConverterNetworkService: BaseNetworkService<ConverterRouter>, ConverterNetworkServiceProtocol {
    func exchange(model: ConverterRequestModel) async throws -> ConverterResponseModel {
        return try await request(ConverterResponseModel.self, router: ConverterRouter.exchange(model: model))
    }
}
