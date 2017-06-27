//
//  RoundBtnCorners.swift
//  GiphyApp
//
//  Created by Connor - Udemy on 2017-06-21.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import UIKit

@IBDesignable
class RoundImageCorners: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
