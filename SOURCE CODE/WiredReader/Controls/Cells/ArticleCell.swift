//
//  ArticleCell.swift
//  WiredReader
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import UIKit
import Foundation

internal class ArticleCell: UICollectionViewCell
{
    /// La imagen que acompaña al articulo
    @IBOutlet private weak var imageThumbnail: UIImageView!
    /// Titulo
    @IBOutlet private weak var labelTitle: UILabel!
    /// breve resumen
    @IBOutlet private weak var labelExcerpt: UILabel!
    
    //
    // MARK: - Properties
    //
    
    /// No pasan el titulo
    internal var title: String?
    {
        didSet
        {
            if let title = self.title
            {
                self.labelTitle.text = title
            }
        }
    }
    
    /// Nos pasan el resumen
    internal var excerpt: String?
    {
        didSet
        {
            if let excerpt = self.excerpt
            {
                self.labelExcerpt.text = excerpt
            }
        }
    }
    
    /// ..y también la imagen
    internal var thumbnail: UIImage?
    {
        didSet
        {
            if let thumbnail = self.thumbnail
            {
                self.imageThumbnail.image = thumbnail
            }
        }
    }
    
    /**
        Creamos la celda
     */
    override internal func awakeFromNib() -> Void
    {
        super.awakeFromNib()
        
        self.applyTheme()
    }
    
    /**
        La preparamos para volver a ser usada
     */
    override internal func prepareForReuse() -> Void
    {
        super.prepareForReuse()
        
        self.labelTitle.text = ""
        self.labelExcerpt.text = ""
        
        if let placeholderImage = UIImage(named: "ArticleThumbnailPlaceHolder")
        {
            self.imageThumbnail.image = placeholderImage
        }
    }
    
    /**
        Tema visuals
     */
    private func applyTheme() -> Void
    {
        self.labelTitle.textColor = Theme.current.textColor
        self.labelExcerpt.textColor = Theme.current.secondaryTextColor
        
        self.backgroundColor = Theme.current.secondaryBackgroundColor
        
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }
}
