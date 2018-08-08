//
//  FeedDataManager+Article.swift
//  WiredKit
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import CoreData
import Foundation

import FeedKit

//
// Operaciones específicas de Core Data con los artículos
//
extension FeedDataManager
{
    /**
        Guardamos un artículo
    */
    public func save(_ article: Article) -> Void
    {
        let local = NSEntityDescription.insertNewObject(forEntityName: "ArticleLocal", into: self.managedContext) as! ArticleLocal
        
        local.articleIdentifier = article.articleIdentifier
        local.author = article.author
        local.createdAt = article.publishedAt.timeIntervalSinceReferenceDate
        local.excerpt = article.excerpt
        local.imageURL = article.thumbnailUrl
        local.sections = article.formattedSections.joined(separator: ", ")
        local.tags = article.formattedTags
        local.title = article.headline
        local.canonicalURL = article.url
        
        // ...lo estoy descargando dos veces. Una en la
        // celda y otra ahora al guardar... #NoEstáBien
        FeedReader.shared.requestMedia(for: article.thumbnailUrl) { (data: Data?, error: FeedError?) -> Void in
            local.thumbnail = data as NSData?
            
            DispatchQueue.main.async
            {
                self.saveContext()
            }
        }
        
        
    }
    
    /**
        Comprueba si el articulo existe en nuestra
        base de datos
    */
    public func existsArticle(identifiedWith identifier: String) -> Bool
    {
        let request: NSFetchRequest<ArticleLocal> = ArticleLocal.fetchRequest()
        
        request.propertiesToFetch = [ "articleIdentifier" ]
        request.resultType = .countResultType
        request.predicate = NSPredicate(format: "(articleIdentifier =  %@)", identifier)

        if let counter = try? self.managedContext.count(for: request)
        {
            return (counter > 0)
        }
        
        return false
    }
    
    /**
        Recupera un articulo en base a su identificador
     */
    public func fetchArticle(identifiedWith identifier: String) -> ArticleLocal?
    {
        let request: NSFetchRequest<ArticleLocal> = ArticleLocal.fetchRequest()
        request.propertiesToFetch = [ "articleIdentifier" ]
        request.predicate = NSPredicate(format: "(articleIdentifier =  %@)", identifier)

        if let results = try? self.managedContext.fetch(request), let result = results.first
        {
            return result
        }
        
        return nil
    }
    
    /**
        REcuperar todos los artículos ordenados por fecha
    */
    public func fetchArticles() -> [ArticleLocal]?
    {
        let request: NSFetchRequest<ArticleLocal> = ArticleLocal.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false) ]

        let results = try? self.managedContext.fetch(request)
        
        return results
    }

    /**
        Recupera en función de un día.
     
        Este no está en uso
    */
    public func fetchArticles(before date: Date) -> [ArticleLocal]?
    {
        let request: NSFetchRequest<ArticleLocal> = ArticleLocal.fetchRequest()
        request.predicate = NSPredicate(format: "createdAt <= %@", argumentArray: [ date ])
        
        if let results = try? self.managedContext.fetch(request)
        {
            return results
        }
        
        return nil
    }
    
    /**
        Busca artículos cuyo título contenga la
        cadena que se pasa como parámetro
    */
    public func fetchArticles(titled title: String) -> [ArticleLocal]?
    {
        let request: NSFetchRequest<ArticleLocal> = ArticleLocal.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", argumentArray: [ title ])
        
        if let results = try? self.managedContext.fetch(request)
        {
            return results
        }
        
        return nil
    }
}
