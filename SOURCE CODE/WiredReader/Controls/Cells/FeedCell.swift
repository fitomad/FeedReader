//
//  FeedCell.swift
//  WiredReader
//
//  Created by Adolfo Vera Blasco on 7/8/18.
//  Copyright © 2018 desappstre {eStudio}. All rights reserved.
//

import UIKit
import Foundation

internal class FeedCell: UICollectionViewCell
{
    /// Titulo del Feed
    @IBOutlet private weak var labelSectionTitle: UILabel!
    /// Última actualización
    @IBOutlet private weak var labelLastUpdate: UILabel!
    
    //
    // MARK: - Properties
    //
    
    /// Establecemos el titulo
    internal var title: String?
    {
        didSet
        {
            if let title = self.title
            {
                self.labelSectionTitle.text = title
            }
        }
    }
    
    /// Establecemos la fecha de actualización
    internal var updatedAt: String?
    {
        didSet
        {
            if let updatedAt = self.updatedAt
            {
                self.labelLastUpdate.text = updatedAt
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
        La preparamos para un nuevo uso
    */
    override internal func prepareForReuse() -> Void
    {
        super.prepareForReuse()
        
        self.labelSectionTitle.text = ""
        self.labelLastUpdate.text = ""
    }
    
    /**
        Tema visual 
    */
    private func applyTheme() -> Void
    {
        self.labelSectionTitle.textColor = Theme.current.textColor
        self.labelLastUpdate.textColor = Theme.current.secondaryTextColor
        
        self.backgroundColor = Theme.current.secondaryBackgroundColor
        
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }
}
