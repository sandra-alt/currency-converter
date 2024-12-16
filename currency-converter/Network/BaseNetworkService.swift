//
//  BaseNetworkService.swift
//  currency-converter
//
//  Created by  Oleksandra on 15.12.2024.
//

import Foundation

// MARK: - Protocol defining the requirements for constructing a URLRequest
protocol URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var task: HTTPTask { get }
    
    func makeURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    
    /// Creates a URLRequest with standard configuration
    /// - Throws: NetworkError for invalid URL or encoding issues
    /// - Returns: A fully configured URLRequest
    func makeURLRequest() throws -> URLRequest {
        
        // URL creation with base URL and specific path
        guard let url = URL(string: APIServiceConstants.baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        // Create and configure the request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}

// MARK: - A generic base network service for handling network requests
class BaseNetworkService<Router: URLRequestConvertible> {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    /// Validates the network response
    /// - Parameters:
    ///   - data: The received data
    ///   - response: The network response
    /// - Throws: NetworkError for invalid responses or error status codes
    private func handleResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
    }

    /// Performs a network request and decodes the response
    /// - Parameters:
    ///   - returnType: The type to decode the response into
    ///   - router: The request router
    /// - Returns: Decoded response of specified type
    /// - Throws: Network-related errors
    func request<T: Decodable>(_ returnType: T.Type, router: Router) async throws -> T {
        let request = try router.makeURLRequest()
        
        // Perform network request
        let (data, response) = try await urlSession.data(for: request)
        
        // Validate response
        try handleResponse(data: data, response: response)
        
        // Decode response
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(returnType, from: data)
            return decodedData
        } catch {
            throw NetworkError.invalidData
        }
    }
}
