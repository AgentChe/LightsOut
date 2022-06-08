//
//  LOFullSizeCell.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOFullSizeCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    static let reuseID = "LOLongSizeCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }

    func setLabel(with titleText: String) {
        titleLabel.text = titleText

    }
    
    
}
