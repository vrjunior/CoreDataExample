//
//  Episode.swift
//  GameOfThronesGuide
//
//  Created by Valmir Junior on 04/09/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation
import CoreData

class Episode : NSManagedObject {
    
    @NSManaged public var name: String
    @NSManaged public var duration: Int16
    @NSManaged public var releaseDate: Date
    @NSManaged public var rating: Int16
    
    @NSManaged public var season: Season?
    
    
    convenience init() {
        //getting context
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        //create description
        let description = NSEntityDescription.entity(forEntityName: "Episode", in: context)!
        
        //init
        self.init(entity: description, insertInto: nil)
        
    }
    
}
