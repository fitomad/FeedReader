//
//  Feed+Date.swift
//  WiredReader
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

import FeedKit

internal extension Feed
{
    /// La fecha del Feed en formato legible
    /// para el usuario
    internal var formattedDate: String
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        return formatter.string(from: self.buildAt)
    }
}
