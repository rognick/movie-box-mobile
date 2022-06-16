//
//  Movie.swift
//
//  Created by Nicolae Rogojan on 21.10.2021.
//

import Foundation

struct Genre: Decodable {
    let id: Int
    let name: String
}

struct Movie {
    let id: Int
    let title: String
    let overview: String
    let poster: String?
    let voteAverage: Double
    let releaseDate: String?
    let runtime: Int?
    let genres: [Genre]?
    
    static var dummyMovies: [Movie] = []
}

extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Movie: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case poster = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case runtime
        case genres
    }
}

struct Movies {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let items: [Movie]
}

extension Movies: Decodable {
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case items = "results"
    }
}
