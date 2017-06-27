//
//  GiphySearchCell.swift
//  GiphyApp
//
//  Created by Connor - Udemy on 2017-06-21.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import CoreData

class GiphySearchCell: UITableViewCell {

    @IBOutlet weak var giphyImg1: RoundImageCorners!
    @IBOutlet weak var giphyHeartBtn1: UIButton!
    
    var index = 0
    
    var arrayFromGiphySearchVC = GiphySearchVC()
    
    func configureCell(id: String, gifURL: String, index: Int) {
        
        giphyImg1.image = UIImage.gif(url: gifURL)
        
        self.index = index
        giphyHeartBtn1.tag = self.index
        
        
        if GlobalVariables.heartArray[index] == true {
            giphyHeartBtn1.setImage(UIImage(named: "FilledHeart"), for: .normal)
        } else if GlobalVariables.heartArray[index] == false {
            giphyHeartBtn1.setImage(UIImage(named: "EmptyHeart"), for: .normal)
        }
        
    }


}
