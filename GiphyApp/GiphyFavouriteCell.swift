//
//  GiphyFavouriteCell.swift
//  GiphyApp
//
//  Created by Connor - Udemy on 2017-06-23.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import CoreData

class GiphyFavouriteCell: UICollectionViewCell {
    
    @IBOutlet weak var giphyFavouriteImage: UIImageView!
    var id = String()
    
    
    func configureCell(savedGiphy: SavedGiphy) {
        
        if let url = savedGiphy.url {
            
            giphyFavouriteImage.image = UIImage.gif(url: url)
            
        }
    }
}
