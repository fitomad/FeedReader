//
//  Feed.swift
//  FeedKit
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

//
// Es el Feed de noticias
//
public struct Feed: Codable
{
    public private(set) var title: String
    public private(set) var feedDescription: String
    public private(set) var link: URL
    public private(set) var copyright: String
    public private(set) var canonicalUrl: URL
    public private(set) var buildAt: Date

    public private(set) var articles: [Article]

    /**

    */
    private enum CodingKeys: String, CodingKey
    {
        case title
        case feedDescription = "description"
        case link
        case copyright
        case canonicalUrl = "feedCanonicalUrl"
        case buildAt = "lastBuildDate"
        case articles = "items"
    }
}
