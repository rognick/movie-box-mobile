//
//  BaseClient.swift
//
//  Created by Nicolae Rogojan on 24.10.2021.
//

import Foundation
import Combine

protocol BaseClient {
    
    init(clientPath: ClientPath)
    
    var clientPath: ClientPath { get }
}

extension BaseClient {
    
    func request(forPath: String, params: [String : CustomStringConvertible]?) -> URLRequest? {
        guard let url = clientPath.clientURL?.appendingPathComponent(forPath) else {
            return nil
        }
        return request(for: url, params: params)
    }
    
    func publisher<T: Decodable>(request: URLRequest) -> AnyPublisher<Result<T, Error>, Never> {
        let publisher = URLSession.shared
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<T, Error>, Never> in .just(.failure(error)) }
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    private func request(for url: URL, params: [String : CustomStringConvertible]?) -> URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = params?.keys.map { key in
            URLQueryItem(name: key, value: params?[key]?.description)
        }
        guard let url = components.url else {
            return nil
        }
        return URLRequest(url: url)
    }
}
