//
//  LOSquareCell.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 19.05.2022.
//

import UIKit

class LOSquareCell: UICollectionViewCell {

    static let reuseID = "LOSquareCell"
    
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
