//
//  FeedViewController.swift
//  WiredReader
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 Adolfo Vera Blasco. All rights reserved.
//

import UIKit
import Foundation

import FeedKit
import WiredKit

internal class FeedViewController: UIViewController
{
    /// Detalle de la entradas en el Feed
    @IBOutlet private weak var collectionArticles: UICollectionView!

    /// Adaptadores de celdas
    private var articles: [FeedCellAdaptable]?


    /**
        Preparamos le `UICollectionView` y
        la barra de búsqueda
    */
    override internal func viewDidLoad() -> Void
    {
        super.viewDidLoad()
        
        self.collectionArticles.delegate = self
        self.collectionArticles.dataSource = self
        
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
        
        self.applyTheme()
        
        self.articles = [FeedCellAdaptable]()
    }

    /**
        Cargamos el Feed
    */
    override internal func viewWillAppear(_ animated: Bool) -> Void
    {
        super.viewWillAppear(animated)
        
        self.loadFeed()
    }

    //
    // MARK: - Preparación de la UI
    //

    /**
        Tema visual
    */
    private func applyTheme() -> Void
    {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.backgroundColor = Theme.current.backgroundColor
    }
    
    //
    // MARK: - Segues
    //
    
    /**
        Nos vamos a la vista de detalle del artículo
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) -> Void
    {
        guard let articles = self.articles, !articles.isEmpty else
        {
            return
        }
        
        if segue.identifier == "SegueArticleCellArticleController"
        {
            if let cell = sender as? ArticleCell,
               let indexPath = self.collectionArticles.indexPath(for: cell),
               let articleViewController = segue.destination as? ArticleViewController,
               let adapter = articles[indexPath.item] as? ArticleAdapter
            {
                
                articleViewController.articleIdentifier = adapter.articleIdentifier
            }
        }
    }

    //
    // MARK: - Datos
    //

    /**
        Cargamos el Feed desde Internet y según los vamos
        descargando los guardamos en local
     
        Si la conexión falla mostramos los artículos que tenemos
        guardados en local
    */
    private func loadFeed() -> Void
    {
        self.articles?.removeAll()
        self.collectionArticles.reloadData()
        
        FeedReader.shared.requestFeed { (feed: Feed?, error: FeedError?) -> Void in
            guard let feed = feed else
            {
                DispatchQueue.main.async
                {
                    self.loadLocalFeed()
                }
                
                return
            }
            
            let feedAdapter = FeedAdapter(named: feed.title, updated: feed.formattedDate)
            self.articles?.append(feedAdapter)
            
            for article in feed.articles
            {
                var articleAdapter = ArticleAdapter(titled: article.headline,
                                                    excerpt: article.excerpt,
                                                    withThumbnail: article.thumbnailUrl)
                
                articleAdapter.articleIdentifier = article.articleIdentifier
                
                self.articles?.append(articleAdapter)
            }
            
            DispatchQueue.main.async
            {
                self.collectionArticles.reloadData()
            }
            
            // Guardamos en local, si es necesario
            for article in feed.articles
            {
                self.saveLocal(article: article)
            }
        }
    }
    
    /**
        Vamos a mostrar los que tenemos en nuestra copia local
    */
    private func loadLocalFeed() -> Void
    {
        self.articles?.removeAll()
        self.collectionArticles.reloadData()
        
        guard let articles = FeedDataManager.shared.fetchArticles() else
        {
            return
        }
        
        self.loadLocalFeed(with: articles)
    }
    
    /**
        Mostramos los feed que se corresponden con la búsqueda
        que hace el usuario
    */
    private func loadLocalFeed(with articles: [ArticleLocal]) -> Void
    {
        let localArticles = articles.map({ (article: ArticleLocal) -> ArticleAdapter in
            var articleAdapter = ArticleAdapter(titled: article.title!,
                                                excerpt: article.excerpt!,
                                                withThumbnail: article.imageURL!)
            
            articleAdapter.articleIdentifier = article.articleIdentifier!
            
            return articleAdapter
        })
        
        self.articles?.append(contentsOf: localArticles)
        
        DispatchQueue.main.async
            {
                self.collectionArticles.reloadData()
        }
    }
    
    /**
        Guardamos el artículo si no lo tenemos ya
    */
    private func saveLocal(article: Article) -> Void
    {
        if !FeedDataManager.shared.existsArticle(identifiedWith: article.articleIdentifier)
        {
            FeedDataManager.shared.save(article)
        }
    }

    //
    // MARK: - Actions
    //
}

//
// MARK: - UICollectionViewDelegate Protocol
//

extension FeedViewController: UICollectionViewDelegate
{
    /**
        Animación para cuando aparecen las celdas
     */
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) -> Void
    {
        cell.alpha = 0.65
        
        let animator = UIViewPropertyAnimator(duration: 0.65, curve: .easeOut)
        
        animator.addAnimations()
        {
            cell.alpha = 1.0
        }
        
        animator.startAnimation()
    }
    
    /**
        Si dejamos de ver la celda no tiene sentido que sigamos
        descargando la imagen asociada.
     
        Así que si el adaptador implementa el protocolo
        `FeedCellCancelable` lo usamos y así detenemos la
        descarga
    */
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) -> Void
    {
        guard let articles = self.articles, !articles.isEmpty else
        {
            return
        }
        
        if let adapter = articles[indexPath.item] as? FeedCellCancelable
        {
            adapter.cancelMediaRequest()
        }
    }
}

//
// MARK: - UICollectionViewDataSource Protocol
//

extension FeedViewController: UICollectionViewDataSource
{
    /**
     Sólo tenemos una sección :(
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    /**
        Pero artículos hay muchos
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard let articles = self.articles else 
        {
            return 0
        }

        return articles.count
    }
    
    /**
        El adapter es el encargado de sacar la celda
        que tiene asociada
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let articles = self.articles, !articles.isEmpty else
        {
            return UICollectionViewCell()
        }

        var adapter = articles[indexPath.item]
  
        return adapter.dequeueCell(from: collectionView, at: indexPath)
    }
}

//
// MARK: - UICollectionViewDelegateFlowLayout Protocol
//

extension FeedViewController: UICollectionViewDelegateFlowLayout
{
    /**
        DE  nuevo le preguntamos al adapter por
        el tamaño de su celda
    */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        guard let adapters = self.articles, !adapters.isEmpty else
        {
            return CGSize.zero
        }
        
        return adapters[indexPath.item].cellSize
    }
}

//
// MARK: - UISearchResultsUpdating Protocol
//
extension FeedViewController: UISearchBarDelegate
{
    /**
        Buscar por título
    */
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        guard searchText.count > 0 else
        {
            // No hay nada escrito en la barra de búsqueda.
            // Mostramos todo lo que tenemos
            self.articles?.removeAll()
            self.collectionArticles.reloadData()
            
            self.loadLocalFeed()
            
            return
        }
        
        if let localArticles = FeedDataManager.shared.fetchArticles(titled: searchText)
        {
            self.articles?.removeAll()
            self.collectionArticles.reloadData()
            
            self.loadLocalFeed(with: localArticles)
        }
    }
    
    /**
        El usuario cancela la búsqueda
    */
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        // Preparamos para la siguiente busqueda
        searchBar.text = ""
        
        self.articles?.removeAll()
        self.collectionArticles.reloadData()
        
        self.loadLocalFeed()
    }
}
