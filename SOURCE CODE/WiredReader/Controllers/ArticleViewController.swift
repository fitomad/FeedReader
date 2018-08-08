//
//  ArticleViewController.swift
//  WiredReader
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 Adolfo Vera Blasco. All rights reserved.
//

import UIKit
import Foundation
import SafariServices

import FeedKit
import WiredKit

internal class ArticleViewController: UIViewController
{
    /// Descripción del artículo
    @IBOutlet private weak var labelDescription: UILabel!
    /// Su autor (que ahora me doy cuenta que no lo estoy poniendo... ¬_¬
    @IBOutlet private weak var labelAuthor: UILabel!
    /// Secciones en las que se encuadra el artículo
    @IBOutlet private weak var labelSection: UILabel!
    /// Etiquetas asociadas
    @IBOutlet private weak var labelTag: UILabel!
    /// Su imagen
    @IBOutlet private weak var imageThumbnail: UIImageView!
    /// Boton para abrir el artículo en el navegador
    @IBOutlet private weak var buttonOpenInBrowser: UIButton!
    
    // La URL del artículo
    private var articleURL: URL?

    //
    // MARK: - Propiedades
    //

    /// Id único del artículo
    internal var articleIdentifier: String?

    //
    // MARK: - Ciclo de vida
    //

    /**
        Cargamos el controlador y preparamos el UI
    */
    override internal func viewDidLoad() -> Void
    {
        super.viewDidLoad()
        
        self.applyTheme()
    }
    
    /**
        Mostramos los datos
    */
    override internal func viewWillAppear(_ animated: Bool) -> Void
    {
        super.viewWillAppear(animated)
        
        self.loadArticle()
    }

    //
    // MARK: - Preparar UI
    //

    /**
        Tema visual
    */
    private func applyTheme() -> Void
    {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.view.backgroundColor = Theme.current.backgroundColor
        
        self.labelTag.textColor = Theme.current.secondaryTextColor
        self.labelSection.textColor = Theme.current.secondaryTextColor
        
        self.labelDescription.textColor = Theme.current.textColor
        
        self.buttonOpenInBrowser.tintColor = Theme.current.backgroundColor
        self.buttonOpenInBrowser.backgroundColor = Theme.current.tintColor
        self.buttonOpenInBrowser.layer.cornerRadius = 8.0
        self.buttonOpenInBrowser.layer.masksToBounds = true
    }
    
    //
    // MARK: -
    //
    
    /**
        Cargamos el artículo desde la versión local
    */
    private func loadArticle() -> Void
    {
        guard let articleIdentifier = self.articleIdentifier else
        {
            return
        }
        
        if let local = FeedDataManager.shared.fetchArticle(identifiedWith: articleIdentifier)
        {
            self.title = local.title
            
            if let data = local.thumbnail as Data?
            {
                self.imageThumbnail.image = UIImage(data: data)
            }
            
            self.labelDescription.text = local.excerpt
            self.labelTag.text = local.tags
            self.labelSection.text = local.sections
            
            self.articleURL = local.canonicalURL
        }
    }

    //
    // MARK: - Actions
    //

    /**
        Abrimos en Safari porque permite el uso
        de la vista de lectura.
    */
    @IBAction private func handleOpenInBrowserButtonTap(_ sender: UIButton) -> Void
    {
        guard let articleURL = self.articleURL else
        {
            return
        }
        
        sender.tapFeedback()
        
        let safariController = SFSafariViewController(url: articleURL)
        
        self.present(safariController, animated: true, completion: nil)
    }
}
