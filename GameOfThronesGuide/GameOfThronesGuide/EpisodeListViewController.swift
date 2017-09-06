//
//  EpisodeListViewController.swift
//  GameOfThronesGuide
//
//  Created by Valmir Junior on 05/09/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import UIKit

class EpisodeListViewController: UITableViewController {

    var seasonSelected: Season?
    
    fileprivate var episodes: [Episode] = [Episode]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    fileprivate var dateFormatter = DateFormatter()
    fileprivate let addEpisodeSegue = "addEpisode"
    fileprivate let editEpisodeSegue = "editEpisode"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allows select while editing
        self.tableView.allowsSelectionDuringEditing = true
        
        //setting date formatter
        self.dateFormatter.dateStyle = .short
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let season = self.seasonSelected {
            
            EpisodeServices.findEpisodes(bySeason: season) { [unowned self] (episodes, error) in
                
                if error == nil {
                    self.episodes = episodes!
                }
                else {
                    // display error here because it was not possible to load season list
                }
            }
            
            EpisodeServices.findAll{(allEpisodes, error) in
                if(error == nil) {
                    print(allEpisodes!.count)
                }
            }
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == self.addEpisodeSegue) {
            let addOrEditEpisodeViewController = segue.destination as! AddOrEditEpisodeViewController
            
            let season = sender as! Season
            
            addOrEditEpisodeViewController.season = season
        }
        
        if(segue.identifier == self.editEpisodeSegue) {
            let addOrEditEpisodeViewController = segue.destination as! AddOrEditEpisodeViewController
            
            let episode = sender as! Episode
            
            addOrEditEpisodeViewController.episode = episode
        }
    }
    
    @IBAction func addEpisode(_ sender: UIBarButtonItem) {
        if let season = seasonSelected {
            self.performSegue(withIdentifier: self.addEpisodeSegue, sender: season)
        }
    }
    
    @IBAction func editEpisode(_ sender: UIBarButtonItem) {
        if (self.isEditing) {
            self.isEditing = false
            sender.title = "Editar"
        }
        else {
            self.isEditing = true
            sender.title = "Feito"
        }
    }
    
    
    //MARK: Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.episodes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentEpisode = self.episodes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
        
        cell.episodeName.text = currentEpisode.name
        cell.rating.setRating(rating: Float(currentEpisode.rating))
        cell.releaseDate.text = dateFormatter.string(from: currentEpisode.releaseDate)
        cell.duration.text = "\(currentEpisode.duration) minutos"
        
        return cell
    }
    
    //MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.isEditing) {
            let selectedEpisode = self.episodes[indexPath.row]
            self.performSegue(withIdentifier: self.editEpisodeSegue, sender: selectedEpisode)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete) {
            
            let episode = self.episodes[indexPath.row]
            
            EpisodeServices.delete(episode: episode) { (error) in
                if(error == nil) {
                    
                    self.tableView.beginUpdates()
                    // remove element from array
                    self.episodes.remove(at: indexPath.row)
                    
                    // remove element from table view
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    self.tableView.endUpdates()

                }
                else {
                    //display error to user
                    print(error!.localizedDescription)
                }
            }
            
            
        }
        
    }
    
}
