//
//  AddOrViewEpisodeViewController.swift
//  GameOfThronesGuide
//
//  Created by Valmir Junior on 05/09/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation
import UIKit

class AddOrEditEpisodeViewController : UITableViewController {
    
    var episode: Episode?
    var season: Season?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var releaseDatePicker: UIDatePicker!
    @IBOutlet weak var durationTimePicker: UIDatePicker!
    @IBOutlet weak var ratingPicker: RatingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let episode = self.episode {
            self.fillFields(episode: episode)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func fillFields(episode: Episode) {
        self.nameField.text = episode.name
        self.releaseDatePicker.date = episode.releaseDate
        self.ratingPicker.setRating(rating: Float(episode.rating))
        self.durationTimePicker.countDownDuration = TimeInterval(episode.duration)
    }
    
    @IBAction func saveEpisode(_ sender: UIBarButtonItem) {
        
        if let episodeToUpdate = self.episode {
            
            if(validateFields()) {
                self.updateEpisode(episodeToUpdate: episodeToUpdate)
                self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            if let season = self.season {
                
                if(validateFields()) {
                    
                    self.createEpisode(season: season)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    func validateFields() -> Bool {
        
        if(self.nameField.text == "") {
            return false
        }
        
        return true
    }
    
    func updateEpisode(episodeToUpdate: Episode) {
        
        episodeToUpdate.name = self.nameField.text!
        episodeToUpdate.duration = self.getMinutesOfDuration()
        episodeToUpdate.releaseDate = self.releaseDatePicker.date
        episodeToUpdate.rating = Int16(self.ratingPicker.currentRating)
        
        EpisodeServices.update { (error) in
            if let error = error {
                //TODO display error to the user
                print(error.localizedDescription)
            }
        }
    }
    
    func createEpisode(season: Season) {
        
        let episode = Episode()
        
        episode.name = self.nameField.text!
        episode.duration = self.getMinutesOfDuration()
        episode.releaseDate = self.releaseDatePicker.date
        episode.rating = Int16(self.ratingPicker.currentRating)
        
        //inserting episode in the season context
        season.managedObjectContext?.insert(episode)
        
        episode.season = season
        
        EpisodeServices.create(episode: episode) { (error) in
            if let error = error{
                //TODO display error to the user
                print(error.localizedDescription)
            }
        }
        
    }
    
    func getMinutesOfDuration() -> Int16{
        return Int16(self.durationTimePicker.countDownDuration / 60)
    }
    
}
