//
//  FeedCellAdaptable.swift
//  WiredReader
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 Adolfo Vera Blasco. All rights reserved.
//

import UIKit
import Foundation

internal protocol FeedCellAdaptable
{
    /// Tamaño de la celda
    var cellSize: CGSize { get }
    /// Identificador único
    static var cellIdentifier: String { get }

    /**
        Obtenemos una celda para la `UICollectionView`
    */
    mutating func dequeueCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
}
