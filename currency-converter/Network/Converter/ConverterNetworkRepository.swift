//
//  ConverterNetworkRepository.swift
//  currency-converter
//
//  Created by  Oleksandra on 15.12.2024.
//

import Combine
import Foundation

protocol ConverterRepositoryProtocol {
    /// Performs currency exchange
    /// - Parameter model: The conversion request model
    /// - Returns: The conversion response model
    /// - Throws: Network-related errors
    func exchange(model: ConverterRequestModel) async throws -> ConverterResponseModel
    
    func exchangePublisher(model: ConverterRequestModel) -> AnyPublisher<ConverterResponseModel, Error>
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

    /// Performs a currency exchange and returns an AnyPublisher
    /// - Parameter model: The conversion request details
    /// - Returns: A publisher that emits the conversion response or an error
    func exchangePublisher(model: ConverterRequestModel) -> AnyPublisher<ConverterResponseModel, Error> {
        // Create a Combine publisher using Future
        return Future { promise in
            // Use a detached task to handle the async operation
            Task.detached {
                do {
                    // Perform the async exchange
                    let result = try await self.exchange(model: model)
                    
                    // Send the successful result to the promise
                    promise(.success(result))
                    
                } catch {
                    // Forward any errors
                    promise(.failure(error))
                }
            }
        }
        // Ensure the publisher runs on the main scheduler
        .receive(on: DispatchQueue.main)
        // Type-erase the publisher
        .eraseToAnyPublisher()
    }
}
