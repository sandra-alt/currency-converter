//
//  ConverterNetworkRepository.swift
//  currency-converter
//
//  Created by  Oleksandra on 15.12.2024.
//

import Foundation

protocol ConverterRepositoryProtocol {
    /// Performs currency exchange
    /// - Parameter model: The conversion request model
    /// - Returns: The conversion response model
    /// - Throws: Network-related errors
    func exchange(model: ConverterRequestModel) async throws -> ConverterResponseModel
}

// Concrete implementation of currency converter repository
class ConverterNetworkRepository: ConverterRepositoryProtocol {
    private let service: ConverterNetworkService
    
    init(networkService: ConverterNetworkService) {
        self.service = networkService
    }
    
    func exchange(model: ConverterRequestModel) async throws -> ConverterResponseModel {
        return try await service.exchange(model: model)
    }
}
