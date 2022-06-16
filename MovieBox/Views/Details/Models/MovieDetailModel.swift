//
//  MovieDetailModel.swift
//
//  Created by Nicolae Rogojan on 22.10.2021.
//

import UIKit
import Combine

struct MovieDetailModel {
    let title: String
    let subtitle: String
    let overview: String
    let genres: [GenreType]?
    let poster: AnyPublisher<UIImage?, Error>
}

extension MovieDetailModel {
    init(movie: Movie, poster: AnyPublisher<UIImage?, Error>) {
        self.title = movie.title
        self.subtitle = MovieDetailModel.subtitle(movie: movie)
        self.overview = movie.overview
        self.genres = movie.genres
        self.poster = poster
    }
    
    private static func subtitle(movie: Movie) -> String {
        return "\(stringDate(movie)) - \(stringTime(movie))"
    }
    
    private static func stringTime(_ movie: Movie) -> String {
        guard let runtime = movie.runtime else { return "" }
        
        let timeInterval = TimeInterval(runtime * 60)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: timeInterval) ?? "\(runtime)m"
    }
    
    private static func stringDate(_ movie: Movie) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard
            let releaseDate = movie.releaseDate,
            let date = dateFormatter.date(from: releaseDate)
        else {
            return ""
        }
        
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
}
