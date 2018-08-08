//
//  FeedCellCancelable.swift
//  WiredReader
//
//  Created by Adolfo Vera Blasco on 8/8/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import Foundation

internal protocol FeedCellCancelable
{
    /**
        Si la celda sale de la pantalla
        cancelamos la descarga de la imagen
    */
    func cancelMediaRequest() -> Void
}
