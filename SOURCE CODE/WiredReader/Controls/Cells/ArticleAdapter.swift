//
//  ArticleAdapter.swift
//  WiredReader
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 Adolfo Vera Blasco. All rights reserved.
//

import UIKit
import Foundation

import FeedKit

internal struct ArticleAdapter
{
    /// Titulo del artículo
    internal private(set) var title: String
    /// Resumen
    internal private(set) var excerpt: String
    /// URL a la imagen
    internal private(set) var thumbnailURL: URL
    
    /// ID único de artículo
    internal var articleIdentifier: String?
    
    /// La sesion http para la descarga de la imagen
    private var mediaRequestTask: URLSessionDataTask?

    /**
        Un nuevo adaptador con los datos minimos
    */
    internal init(titled title: String, excerpt: String, withThumbnail thumbnail: URL)
    {
        self.title = title
        self.excerpt = excerpt
        self.thumbnailURL = thumbnail
    }

    /**
        Descarga la imagen en segundo plano para así
        evitar *tirones* en la UI.
     
        Guardamos un enlace a la sesion Http por si
        necesitamos cancelar
    */
    private mutating func downloadThumbnail(_ handler: @escaping (_ imageData: Data?) -> (Void)) -> Void
    {
        self.mediaRequestTask = FeedReader.shared.requestMedia(for: self.thumbnailURL) { (data: Data?, error: FeedError?) -> Void in
            if let data = data
            {
                handler(data)
            }
            else
            {
                handler(nil)
                
                if let error = error
                {
                    dump(error)
                }
            }
        }
    }
}

//
// MARK: - FeedCellAdaptable Protocol
// 

extension ArticleAdapter: FeedCellAdaptable
{
    internal var cellSize: CGSize
    {
        return CGSize(width: 325.0, height: 450.0)
    }
    
    internal static var cellIdentifier: String
    {
        return "ArticleCell"
    }
    
    
    internal mutating func dequeueCell(from collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let articleCell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleAdapter.cellIdentifier, for: indexPath) as? ArticleCell else
        {
            fatalError("Unable to dequeue a TaskCell")
        }
        
        articleCell.title = self.title
        articleCell.excerpt = self.excerpt
        
        self.downloadThumbnail { (data: Data?) -> (Void) in
            if let data = data
            {
                DispatchQueue.main.async
                {
                    articleCell.thumbnail = UIImage(data: data)
                }
            }
        }
        
        return articleCell
    }
}

extension ArticleAdapter: FeedCellCancelable
{
    func cancelMediaRequest() -> Void
    {
        self.mediaRequestTask?.cancel()
    }
}
