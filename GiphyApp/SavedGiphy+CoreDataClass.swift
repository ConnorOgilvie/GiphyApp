//
//  SavedGiphy+CoreDataClass.swift
//  GiphyApp
//
//  Created by Connor - Udemy on 2017-06-26.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import Foundation
import CoreData

@objc(SavedGiphy)
public class SavedGiphy: NSManagedObject {
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
        
    }

}
