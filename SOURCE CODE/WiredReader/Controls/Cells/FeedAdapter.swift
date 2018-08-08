//
//  FeedAdapter.swift
//  WiredReader
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 Adolfo Vera Blasco. All rights reserved.
//

import UIKit
import Foundation

internal struct FeedAdapter
{
    /// Nombre del feed (en este caso son las Top Stories de Wired)
    internal let name: String
    /// Fecha de última actualización en formato legible
    internal let lastUpdateFormatted: String

    /**
        Creamos un adaptador con el mínimo de datos
    */
    internal init(named name: String, updated at: String)
    {
        self.name = name
        self.lastUpdateFormatted = at
    }
}

//
// MARK: - FeedCellAdaptable
//

extension FeedAdapter: FeedCellAdaptable
{
    internal var cellSize: CGSize
    {
        return CGSize(width: 325.0, height: 90.0)
    }
    
    internal static var cellIdentifier: String
    {
        return "FeedCell"
    }
    
    internal func dequeueCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedAdapter.cellIdentifier, for: indexPath) as? FeedCell else
        {
            fatalError("Unable to dequeue a FeedCell")
        }
        
        feedCell.title = self.name
        feedCell.updatedAt = self.lastUpdateFormatted
        
        return feedCell
    }
}
