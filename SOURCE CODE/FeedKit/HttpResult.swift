//
//  HttpResult.swift
//  FeedKit
//
//  Created by Adolfo on 7/8/18.
//  Copyright © 2018 Adolfo Vera Blasco. All rights reserved.
//
import Foundation

/**
 Los posibles valores devolvemos son:
 
 - Success: Recuperamos el contenido del stream
 - RequestError: Problema en la peticion HTTP
 - ConnectionError: Error general
 */
internal enum HttpResult
{
    /// La operacion ha terminado bien.
    /// Devolvemos el stream de datos reacuperados
    case success(feed: Feed)
    /// Algo ha salido mal.
    /// Devolvemos un mensaje con la descripcion del error
    /// y el codigo HTTP asociado
    case requestError(code: Int, message: String)
    /// Problemas de conexión con el servidor
    case connectionError
    ///
    case invalidResponse
}
