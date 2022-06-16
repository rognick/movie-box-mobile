//
//  MoviePopularView.swift
//
//  Created by Nicolae Rogojan on 23.10.2021.
//

import UIKit
import Combine

class MovieNowPlayingView: BaseView {
    
    private var dataSource: [MovieListModel] = []
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
        }
    }
    
    func render(_ dataSource: [MovieListModel]) {
        self.dataSource = dataSource
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension MovieNowPlayingView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        let model = dataSource[indexPath.row]
        cell.render(model)
        
        return cell
    }
}
