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
    private let baseURL: String
    private let session: URLSession

    init(
        baseURL: String,
        session: URLSession = URLSession.shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func request<T>(_ endpoint: Endpoint, responseType: T.Type) async throws -> T where T : Decodable {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        
        print("Decoding type:", T.self)
        var req = URLRequest(url: url)
        req.httpMethod = endpoint.method.rawValue
        
        do {
            let (data, resp) = try await self.session.data(for: req)
            
            guard let httpResponse = resp as? HTTPURLResponse else {
                throw APIError.invalidResponse
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
            throw APIError.unknown(error)
        }
    }
}

