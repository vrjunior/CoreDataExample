//
//  SeasonListViewController.swift
//  GameOfThronesGuide
//
//  Created by Fernando Celarino on 29/08/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation
import UIKit

class SeasonListViewController : UITableViewController {
    /// season list that will be displayed by this UI
    fileprivate var seasons: [Season] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    fileprivate let episodesSegue = "episodesList"
    fileprivate let addOrEditSeasonSegue = "addOrEditSeason"
    
    override func viewWillAppear(_ animated: Bool) {
        // call super
        super.viewWillAppear(animated)
        
        //allows select while editing 
        self.tableView.allowsSelectionDuringEditing = true
        
        // get all seasons
        SeasonServices.getAllSeasons { (error, seasons) in
            if (error == nil) {
                // assign season list
                self.seasons = seasons!
                
            }
            else {
                // display error here because it was not possible to load season list
            }
        }
    }
    @IBAction func edit(_ sender: UIBarButtonItem) {
        if(self.isEditing) {
            self.isEditing = false
            sender.title = "Editar"
        }
        else {
            self.isEditing = true
            sender.title = "Feito"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check for the correct transition
        if (segue.identifier == self.addOrEditSeasonSegue) {
            // cast destination controller and setup initial data
            let destinationViewController:AddOrEditSeasonViewController = segue.destination as! AddOrEditSeasonViewController
            destinationViewController.navigationItem.title = (sender is Season) ? "Editar Temporada" : "Nova Temporada"
            destinationViewController.season = sender as? Season
        }
        
        if(segue.identifier == self.episodesSegue) {
            
            let episodesViewController = segue.destination as! EpisodeListViewController
            let season = sender as! Season
            
            episodesViewController.seasonSelected = season
            
        }
    }
}

extension SeasonListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seasons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a new cell
        let cell:SeasonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SeasonCell", for: indexPath) as! SeasonTableViewCell
        
        // get the season data to be displayed
        let season:Season = self.seasons[indexPath.row]
        
        // fill cell with extracted information
        cell.resumeLabel.text = season.resume
        cell.numberLabel.text = "Season \(season.number)"
        cell.airedImage.isHidden = !season.aired
        
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentSeason = self.seasons[indexPath.row]
        
        if(self.isEditing) {
            self.performSegue(withIdentifier: self.addOrEditSeasonSegue, sender: currentSeason)
        }
        else {
            self.performSegue(withIdentifier: self.episodesSegue, sender: currentSeason)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // get season that will be deleted
            let season:Season = self.seasons[indexPath.row]
            
            // remove season from database
            SeasonServices.deleteSeason(season:season) { (error) in
                if ( error == nil ) {
                    
                    self.tableView.beginUpdates()
                    // remove element from array
                    self.seasons.remove(at: indexPath.row)
                    
                    // remove element from table view
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    self.tableView.endUpdates()
                }
                else {
                    // manage a possible problem to remove the item from database
                }
            }
        }
    }

}
