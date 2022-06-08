//
//  LOFullSizeCell.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 19.05.2022.
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
