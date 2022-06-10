//
//  LOSquareCell.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOSquareCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var leagueIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }

    
    func set(with titleText: String, leagueId: String) {
        titleLabel.text = titleText
        leagueIdLabel.text = leagueId
    }
}
