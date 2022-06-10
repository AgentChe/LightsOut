//
//  LOOnlineRecordCell.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOOnlineRecordCell: UICollectionViewCell {

    @IBOutlet var numberImageView: UIImageView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
    
    func set(record: RecordModel, rankValue: Int) {
        numberImageView.image = UIImage(systemName: "\(rankValue).circle")
        topLabel.text = "\(record.recordTime) " + "seconds" + " - \(record.name!)"
        bottomLabel.text = Date(timeIntervalSince1970: record.timeStamp).convertToStringWithFormat()
    }

}
