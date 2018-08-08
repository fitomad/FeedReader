//
//  ArticleLocal+CoreDataProperties.swift
//  WiredKit
//
//  Created by Adolfo Vera Blasco on 8/8/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//
//

import Foundation
import CoreData


extension ArticleLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleLocal> {
        return NSFetchRequest<ArticleLocal>(entityName: "ArticleLocal")
    }

    @NSManaged public var articleIdentifier: String?
    @NSManaged public var author: String?
    @NSManaged public var createdAt: TimeInterval
    @NSManaged public var excerpt: String?
    @NSManaged public var imageURL: URL?
    @NSManaged public var sections: String?
    @NSManaged public var tags: String?
    @NSManaged public var thumbnail: NSData?
    @NSManaged public var title: String?
    @NSManaged public var canonicalURL: URL?

}
