//
//  PosterService.swift
//
//  Created by Nicolae Rogojan on 23.10.2021.
//

import UIKit
import Combine

typealias PosterPublisher = AnyPublisher<UIImage?, Error>

enum PosterSize: String {
    case small      = "w154"
    case medium     = "w300"
    case large      = "w500"
    case original   = "original"
}

class PosterService: BaseClient {
    
    let clientPath: ClientPath
    
    private var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "poster-operation-queue"
        operationQueue.maxConcurrentOperationCount = 8
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()
    
    init() {
        self.clientPath = ClientPath(baseURI: "https://image.tmdb.org",
                                     baseURIVersion: "",
                                     serviceName: "/t/p")
        
    }
    
    required init(clientPath: ClientPath) {
        self.clientPath = clientPath
    }
    
    func fetchPoster(poster: String?, size: PosterSize) -> PosterPublisher {
        guard var url = clientPath.clientURL, let poster = poster else {
            return .fail(URLError(.badURL)).eraseToAnyPublisher()
        }
        
        url.appendPathComponent(size.rawValue)
        url.appendPathComponent(poster)
        
        let dataTaskPublisher = dataTaskPublisher(for: url)
        
        let publisher = Deferred { Just(URLRequest(url: url)) }
            .flatMap { [unowned self] request in self.cachePublisher(for: request) }
            .catch { _ in dataTaskPublisher }
            .subscribe(on: operationQueue)
            .eraseToAnyPublisher()
        
        return publisher
    }
}

// MARK: - Helper

private extension PosterService {
    private func dataTaskPublisher(for url: URL) -> PosterPublisher {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> UIImage? in
                if let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: url))
                    return image
                }
                return nil
            }
            .eraseToAnyPublisher()
    }
    
    private func cachePublisher(for request: URLRequest) -> PosterPublisher {
        guard let data = URLCache.shared.cachedResponse(for: request)?.data,
              let image = UIImage(data: data)
        else {
            return .fail(URLError(.badURL)).eraseToAnyPublisher()
        }
        return .just(image).eraseToAnyPublisher()
    }
}
