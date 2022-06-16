//
//  MovieListModel.swift
//
//  Created by Nicolae Rogojan on 23.10.2021.
//

import UIKit
import Combine

struct MovieListModel {
    let id: Int
    let title: String
    let subtitle: String
    let votePercentage: Double
    let posterPublisher: AnyPublisher<UIImage?, Error>
}

extension MovieListModel {
    init(movie: Movie, poster: AnyPublisher<UIImage?, Error>) {
        self.id = movie.id
        self.title = movie.title
        self.subtitle = MovieListModel.subtitle(movie: movie)
        self.votePercentage = movie.voteAverage / 10 * 100
        self.posterPublisher = poster
    }
    
    private static func subtitle(movie: Movie) -> String {        
        guard let time = stringTime(movie) else {
            return "\(stringDate(movie))\n-"
        }
        return "\(stringDate(movie))\n\(time)"
    }
    
    private static func stringTime(_ movie: Movie) -> String? {
        guard let runtime = movie.runtime else { return nil }
        
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

extension MovieListModel: Hashable {
    static func == (lhs: MovieListModel, rhs: MovieListModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
