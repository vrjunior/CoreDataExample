//
//  DAO.swift
//  GameOfThronesGuide
//
//  Created by Valmir Junior on 04/09/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation
import CoreData

class DAO {
    
    /// Method responsible for updating a season into database
    /// - parameters:
    ///     - objectToBeUpdated: season to be updated on database
    /// - throws: if an error occurs during updating an object into database (Errors.DatabaseFailure)
    static func update() throws {
        do {
            // persist changes at the context
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }
    
}
