//
//  Season.swift
//  GameOfThronesGuide
//
//  Created by Fernando Celarino on 29/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation
import CoreData

class Season: NSManagedObject {

    @NSManaged public var number: Int16
    @NSManaged public var resume: String?
    @NSManaged public var aired: Bool

    //relationships
    @NSManaged public var episodes: NSSet?
    
    convenience init() {
        // get context
        let managedObjectContext: NSManagedObjectContext = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        // create entity description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Season", in: managedObjectContext)
        
        // call super
        self.init(entity: entityDescription!, insertInto: nil)
    }
    
    @NSManaged func addEpisodeObject(value:Episode)
    @NSManaged func removeEpisodeObject(value:Episode)
    @NSManaged func addEpisodes(value:Set<Episode>)
    @NSManaged func removeEpisodes(value:Set<Episode>)
}
