//
//  FeedError.swift
//  FeedKit
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 Adolfo Vera Blasco. All rights reserved.
//

//
// Los posibles errores que nos podemos encontrar
// durante la descarga del feed
//
public enum FeedError: Int
{
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    case serverOverloaded = 503
    case serverUnavailable = 504
    case serverIsDown = 521
    case connectionTimedOut = 522

    /**

    */
    internal init(httpCode code: Int)
    {
        if let error = FeedError(rawValue: code)
        {
            self = error
        }
        else
        {
            self = FeedError.badRequest
        }
    }
}
