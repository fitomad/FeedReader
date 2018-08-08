//
//  DateFormatter+TraktTV.swift
//  CoreTraktTV
//
//  Created by Adolfo Vera Blasco on 1/8/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

/**
    El formato de fecha devuelto por el servicio
    Trakt.TV no se ajusta al esperado por JSONDecoder.

    Por eso creamos nuestra propia *estrategia* de
    decodificación para que la empleemos con JSONDecoder
*/
extension DateFormatter 
{
    /**
        El formato que llega es...

        ```
        2007-09-24T00:00:00.000Z
        ```
    */
    static let feedISO8601: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        return formatter
    }()
}
