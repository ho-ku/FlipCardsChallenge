//
//  Game+CoreDataProperties.swift
//  
//
//  Created by Денис Андриевский on 11/21/19.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: String?
    @NSManaged public var image: Data?

}
