//
//  LOOnlineRecordCell.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 30.05.2022.
//

import UIKit

class LOOnlineRecordCell: UICollectionViewCell {
    static let reuseID = "LOOnlineRecordCell"
    
    @IBOutlet var numberImageView: UIImageView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
    
    //.convertThreePointString()
    func set(record: RecordModel, rankValue: Int) {
        numberImageView.image = UIImage(systemName: "\(rankValue).circle")
        topLabel.text = "\(record.recordTime) " + "seconds" + " - \(record.name!)"
        bottomLabel.text = Date(timeIntervalSince1970: record.timeStamp).convertToStringWithFormat()
    }

}
