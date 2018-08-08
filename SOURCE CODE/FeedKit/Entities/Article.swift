//
//  Article.swift
//  FeedKit
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 Adolfo Vera Blasco. All rights reserved.
//

import Foundation


//
// Los datos de un artículo de Wired
//
public struct Article: Codable
{
    
    public private(set) var articleIdentifier: String
    public private(set) var headline: String
    public private(set) var url: URL
    
    public private(set) var excerpt: String
    
    public private(set) var author: String
    public private(set) var publishedAt: Date
    public private(set) var relativeTimeStamp: String
    public private(set) var sections: [[String]]
    public private(set) var tags: [String]
    public private(set) var thumbnailUrl: URL

    ///
    public var formattedSections: [String]
    {
        return self.sections.flatMap({ $0 }).map({ $0.joined(separator: ", ") })
    }

    ///
    public var formattedTags: String
    {
        return self.tags.joined(separator: ", ")
    }

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        
        case articleIdentifier = "id"
        case headline = "storyHeadline"
        case url
 
        case excerpt
        
        case author = "byline"
        case publishedAt = "publishDate"
        case relativeTimeStamp
        case sections = "section"
        case tags
        case thumbnailUrl
 
    }
}

