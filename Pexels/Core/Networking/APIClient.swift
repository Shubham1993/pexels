//
//  APIClient.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

protocol APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T
}


final class APIClientImpl: APIClient {
    private let baseURL: URL
    private let session: URLSession

    init(
        baseURL: URL,
        session: URLSession = URLSession.shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func request<T>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T where T : Decodable {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        )

        components?.queryItems = endpoint.queryItems

        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = endpoint.method.rawValue
        req.timeoutInterval = 30
        
        do {
            let (data, resp) = try await self.session.data(for: req)
            
            guard let httpResponse = resp as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            if httpResponse.statusCode == 429 {
                throw APIError.rateLimitReached
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch let error as DecodingError {
                print("DecodingError:", error.prettyDescription)
                throw APIError.decodingError
            } catch {
                print("Unknown decoding error:", error)
                throw APIError.decodingError
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.network(error)
        }
    }
}

