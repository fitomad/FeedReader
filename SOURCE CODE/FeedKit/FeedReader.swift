//
//  FeedReader.swift
//  FeedKit
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 Adolfo Vera Blasco. All rights reserved.
//

import Foundation

//
// Closure donde enviamos el Feed
//
public typealias FeedCompletionHandler = (_ feed: Feed?, _ error: FeedError?) -> Void

//
// Closure para la descarga de imagenes
//
public typealias FeedMediaCompletionHandler = (_ data: Data?, _ error: FeedError?) -> Void

//
// Aquí las peticiones Http
//
internal typealias HttpRequestCompletionHandler = (_ result: HttpResult) -> (Void)


public class FeedReader
{
    /// Singleton
    public static let shared = FeedReader()

    /// URL del feed
    private var feedURL: URL?

    /// Decodificador JSON
    private let decoder: JSONDecoder

    /// HTTP session ...
    private var httpSession: URLSession!
    /// ...y su configuración
    private var httpConfiguration: URLSessionConfiguration!

    /**

    */
    private init()
    {
        if let url = URL(string: "https://www.wired.com/feed/json")
        {
            self.feedURL = url
        }

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .formatted(DateFormatter.feedISO8601)

        self.httpConfiguration = URLSessionConfiguration.default
        self.httpConfiguration.httpMaximumConnectionsPerHost = 10
        
        let http_queue: OperationQueue = OperationQueue()
        http_queue.maxConcurrentOperationCount = 10
        
        self.httpSession = URLSession(configuration:self.httpConfiguration,
                                      delegate:nil,
                                      delegateQueue:http_queue)
    }

    //
    // MARK: - Operaciones de recuperación del Feed
    //

    /**
     Descargamos el feed
    */
    public func requestFeed(_ handler: @escaping FeedCompletionHandler) -> Void
    {
        self.processRequest { (resultado: HttpResult) -> (Void) in
            switch resultado
            {
                case .success(let feed):
                    handler(feed, nil)
                case.connectionError:
                    handler(nil, FeedError.serverError)
                case .invalidResponse:
                    handler(nil, FeedError.badRequest)
                case.requestError(let code, _):
                    handler(nil, FeedError(httpCode: code))
            }
        }
    }
    
    /**
        Descargamos una imagen
    */
    public func requestMedia(for url: URL, handler: @escaping FeedMediaCompletionHandler) -> URLSessionDataTask
    {
        let data_task = self.httpSession.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else
            {
                handler(nil, FeedError.notFound)
                return
            }
            
            handler(data, nil)
        })
        
        data_task.resume()
        
        return data_task
    }
    
    //
    // MARK: - Helper Methods
    //
    
    /**
        Wired incluye caracteres que provocan errores
        en el proceso de decodificación con `JSONDecoder`
     
        Lo mejor y más óptimo es hacerlo con expresiones
        regulares, pero vamos a hacerlo *rápido*
     
    */
    private func sanitize(json data: Data) -> Data?
    {
        if var jsonFeed = String(data: data, encoding: .utf8)
        {
            jsonFeed = jsonFeed.replacingOccurrences(of: " \\\"", with: " ")
            jsonFeed = jsonFeed.replacingOccurrences(of: "\\\" ", with: " ")

            return jsonFeed.data(using: .utf8)
        }
        
        return nil
    }

    //
    // MARK: - Operaciones HTTP
    //

    /**
        Operación de red

        - Parameter completionHandler: resultado HTTP
    */
    internal func processRequest(httpHandler: @escaping HttpRequestCompletionHandler) -> Void
    {
        guard let url = self.feedURL else
        {
            return 
        }
        
        let request = URLRequest(url: url)

        let data_task = self.httpSession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error
            {
                #if targetEnvironment(simulator)
                    print(error.localizedDescription)
                #endif
                
                httpHandler(HttpResult.connectionError)
                return
            }

            guard let data = data, let http_response = response as? HTTPURLResponse else
            {
                httpHandler(HttpResult.connectionError)
                return
            }
            
            guard let jsonData = self.sanitize(json: data) else
            {
                httpHandler(HttpResult.invalidResponse)
                return
            }

            switch http_response.statusCode
            {
                case 200:
                    if let feed = try? self.decoder.decode(Feed.self, from: jsonData)
                    {
                        httpHandler(HttpResult.success(feed: feed))
                    }
                    else
                    {
                      httpHandler(HttpResult.invalidResponse)
                    }
                
                default:
                    let code = http_response.statusCode
                    let message = HTTPURLResponse.localizedString(forStatusCode: code)

                    httpHandler(HttpResult.requestError(code: code, message: message))
            }
        })

        data_task.resume()
    }
}
