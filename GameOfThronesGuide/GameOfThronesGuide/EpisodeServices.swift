//
//  EpisodeServices.swift
//  GameOfThronesGuide
//
//  Created by Valmir Junior on 04/09/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation

class EpisodeServices {
    
    static func create(episode: Episode, completion: @escaping (_ error: Error?) -> Void) {
        
        let blockBackground = BlockOperation {
            
            var blockMain: BlockOperation
            
            do {
                try EpisodeDAO.create(episode)
                
                blockMain = BlockOperation {
                    completion(nil)
                }
            }
            catch let error {
                
                blockMain = BlockOperation {
                    completion(error)
                }
            }
            
            QueueManager.sharedInstance.executeBlock(blockMain, queueType: .main)
        }
        
        QueueManager.sharedInstance.executeBlock(blockBackground, queueType: .serial)
    }
    
    
    static func delete(episode: Episode, completion: @escaping (_ error: Error?) -> Void) {
        
        let blockBackground = BlockOperation {
            
            var blockMain: BlockOperation
            
            do {
                try EpisodeDAO.delete(episode)
                
                blockMain = BlockOperation {
                    completion(nil)
                }
            }
            catch let error {
                
                blockMain = BlockOperation {
                    completion(error)
                }
            }
            
            QueueManager.sharedInstance.executeBlock(blockMain, queueType: .main)
        }
        
        QueueManager.sharedInstance.executeBlock(blockBackground, queueType: .serial)
    }
    
    
    static func update(completion: @escaping (_ error: Error?) -> Void) {
        
        let blockBackground = BlockOperation {
            
            var blockMain: BlockOperation
            
            do {
                try EpisodeDAO.update()
                
                blockMain = BlockOperation {
                    completion(nil)
                }
            }
            catch let error {
                
                blockMain = BlockOperation {
                    completion(error)
                }
            }
            
            QueueManager.sharedInstance.executeBlock(blockMain, queueType: .main)
        }
        
        QueueManager.sharedInstance.executeBlock(blockBackground, queueType: .serial)
    }
    
    
    
    static func findAll(completion: @escaping(_ episodes: [Episode]?, _ error: Error?) -> Void) {
        
        let blockBackground = BlockOperation {

            var blockMain: BlockOperation
            
            do {
                let episodes = try EpisodeDAO.findAll()
                
                blockMain = BlockOperation {
                    completion(episodes, nil)
                }
                
            }
            catch let error {
                
                blockMain = BlockOperation {
                    completion(nil, error)
                }
            }
            
            QueueManager.sharedInstance.executeBlock(blockMain, queueType: .main)
            
        }
        
        QueueManager.sharedInstance.executeBlock(blockBackground, queueType: .serial)
    }
    
    
    
    static func findEpisodes(bySeason season:Season, completion: @escaping(_ episodes:[Episode]?, _ error: Error?) -> Void) {
        
        let blockBackground = BlockOperation {
            
            var blockMain: BlockOperation
            
            do {
                
                let episodes = try EpisodeDAO.findEpisodes(bySeason: season)
                
                blockMain = BlockOperation {
                    completion(episodes, nil)
                }
            }
            catch let error {
                
                blockMain = BlockOperation {
                    completion(nil, error)
                }
            }
            
            QueueManager.sharedInstance.executeBlock(blockMain, queueType: .main)
        }
        
        QueueManager.sharedInstance.executeBlock(blockBackground, queueType: .serial)
    }
    
}
