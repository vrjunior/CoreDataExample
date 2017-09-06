//
//  EpisodeDAO.swift
//  GameOfThronesGuide
//
//  Created by Valmir Junior on 04/09/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation
import CoreData

class EpisodeDAO : DAO {
    
    static func create(_ episode: Episode) throws {
        
        do {
            CoreDataManager.sharedInstance.persistentContainer.viewContext.insert(episode)
            
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }
    
    
    /// Method responsible for deleting a season from database
    /// - parameters:
    ///     - objectToBeSaved: season to be saved on database
    /// - throws: if an error occurs during deleting an object into database (Errors.DatabaseFailure)
    static func delete(_ episode: Episode) throws {
        do {
            // delete element from context
            CoreDataManager.sharedInstance.persistentContainer.viewContext.delete(episode)
            
            // persist the operation
            try CoreDataManager.sharedInstance.persistentContainer.viewContext.save()
        }
        catch {
            throw Errors.DatabaseFailure
        }
    }
    
    
    static func findAll() throws -> [Episode] {
        var episodeList: [Episode]
        
        do {
            let request = NSFetchRequest<Episode>(entityName: "Episode")
            
            episodeList =  try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
        }
        catch {
            throw Errors.DatabaseFailure
        }
        
        return episodeList
    }
    
    static func findEpisodes(bySeason season: Season) throws -> [Episode] {
        var episodes: [Episode]
        
        do {
            let request = NSFetchRequest<Episode>(entityName: "Episode")
            
            request.predicate = NSPredicate(format: "season == %@", season)
            
            request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: true)]
            
            episodes = try CoreDataManager.sharedInstance.persistentContainer.viewContext.fetch(request)
            
        }
        catch {
            throw Errors.DatabaseFailure
        }
        
        return episodes
    }

    
}
