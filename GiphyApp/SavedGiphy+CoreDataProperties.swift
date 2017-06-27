//
//  SavedGiphy+CoreDataProperties.swift
//  GiphyApp
//
//  Created by Connor - Udemy on 2017-06-26.
//  Copyright © 2017 ConnorOgilvie. All rights reserved.
//

import Foundation
import CoreData


extension SavedGiphy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedGiphy> {
        return NSFetchRequest<SavedGiphy>(entityName: "SavedGiphy")
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var url: String?
    @NSManaged public var id: String?

}
