//
//  EpisodeCell.swift
//  GameOfThronesGuide
//
//  Created by Valmir Junior on 05/09/17.
//  Copyright © 2017 Eldorado. All rights reserved.
//

import Foundation
import UIKit

class EpisodeCell : UITableViewCell {
    @IBOutlet weak var episodeName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: RatingView!
    @IBOutlet weak var duration: UILabel!
}

